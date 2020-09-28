import 'package:afmnewclareapp/layouts/home_layout.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String _dateName ;

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<EventsL> list = [];
  List<EventsL> filteredList = [];

  listEvents(String date){

  }

  Future getEvents() async{
    var firestore = Firestore.instance;
   await firestore.collection('Events').getDocuments().then((querySnapshot){
      querySnapshot.documents.forEach((result) async{
        setState(() {
          list.add(EventsL( name:  result.data["eventName"] , isDone: false,time: result.data["time"] , date: result.data["date"]));
          String today =  DateTime.now().year.toString() + ", " +DateTime.now().month.toString() +", " + DateTime.now().day.toString();
          if( result.data["date"] == today )
             {
               filteredList.add(EventsL( name:  result.data["eventName"] , isDone: false,time: result.data["time"] , date: result.data["date"]));
             }
        });


      });
    });



  }

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
      _dateName = _selectedDay.year.toString() + ', ' + _selectedDay.month.toString() + ', ' + _selectedDay.day.toString();
print(_dateName);
      filteredList.clear();
      list.forEach((result) async {
        if(result.date == _dateName )
          {
      filteredList.add(EventsL( name:  result.name, isDone: false,time: result.time , date: result.date));
          }
      });
    });

    }




  List _selectedEvents;
  DateTime _selectedDay;



  Map<DateTime, List> _events =
  {
    DateTime(2020, 6, 7): [
      {'Family Prayer': 'Event A', 'isDone': true, 'time': '10:30'},
    ],

  };

  @override
  void initState() {
    super.initState();
    getEvents();
    print(filteredList.length);
   // _handleNewDate(DateTime
      //  .now());
   /* String dateTime = DateTime
        .now()
        .year
        .toString() + ", " + DateTime
        .now()
        .month
        .toString() + ", " + DateTime
        .now()
        .day
        .toString();
    _selectedEvents = _events[_selectedDay] ?? [];

    filteredList.clear();
    list.forEach((result) async {
      if (result.date == dateTime) {
        filteredList.add(EventsL(name: result.name,
            isDone: false,
            time: result.time,
            date: result.date));
      }
    });
    */

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('images/logo.png',
              height: 45.0,
              fit: BoxFit.cover,
            ),
            Text('AFM Newclare', style: TextStyle(color: Colors.indigo,
                fontSize: 16,
                fontWeight: FontWeight.w500),)
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child:  FlatButton(child: AutoSizeText('Back  ', style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
                fontWeight: FontWeight.w500),),
              padding: EdgeInsets.all(5.0),
              onPressed: (){ Navigator.pop(context);},
              onLongPress: () {
                Navigator.pop(context);
              },),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(' Church Calender',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(icon: Icon(Icons.home ,color: Colors.indigo,size: 43,),onPressed:(){
                      Navigator.pop(context);
                    },)
                )
              ],)
            ,
            Container(

              child: Calendar(
                startOnMonday: true,
                weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                events: _events,
                onRangeSelected: (range) =>
                    print("Range is ${range.from}, ${range.to}"),
                onDateSelected: (date) => _handleNewDate(date),
                isExpandable: true,
                eventDoneColor: Colors.green,
                selectedColor: Colors.pink,
                todayColor: Colors.deepPurple,
                eventColor: Colors.grey,
                dayOfWeekStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 11),
              ),
            ),
          //  _buildEventList(),
            SizedBox(height: 5,),
            AutoSizeText("Events", style: TextStyle( fontWeight: FontWeight.bold),),
          Expanded(
              child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (ctx, i) {

                    return GestureDetector(
                      onTap: (){

                      },
                      child: Card(elevation: 2,
                          child: ListTile(onTap: () {


                          },
                              trailing: Icon(Icons.keyboard_arrow_right),
                              subtitle: AutoSizeText(filteredList[i].time) ,
                              leading: Icon(
                                Icons.event_note, color: Colors.pink,),
                              title: AutoSizeText(filteredList[i].name))),
                    );

                  }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: superUser ? FloatingActionButton (
        elevation: 5,
        child: Icon(Icons.add),
        onPressed: (){          showDialog(
            context: context,
            builder: (BuildContext context)=> AddEvent());},
        backgroundColor: Colors.pink,
      ) :
          SizedBox(height: 1,width: 1,),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          child: ListTile(
            title: Text(_selectedEvents[index]['name'].toString()),
            subtitle: Text(_selectedEvents[index]['time'].toString()),
            onTap: () {},
          ),
        ),
        itemCount: _selectedEvents.length,
      ),
    );
  }
}


class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    return Dialog (
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular( 7)),
        elevation: 3,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/logo.png',
                      height: 180.0,
                      fit: BoxFit.cover,
                    ),
                    AutoSizeText('Add Event', style: TextStyle(fontSize: 18),),
                    SizedBox(height: 8,),
                    Row(children: <Widget>[
                      Icon(Icons.date_range),
                      AutoSizeText('Selected Date: ' +_dateName,style: TextStyle(fontSize: 18),),
                    ],),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField( controller: eventNameController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.event),
                            hintText: 'Event ',
                            contentPadding: const EdgeInsets.all(15),
                            filled: true ,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                              borderRadius: BorderRadius.circular(6),
                            )
                        ) ,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField( controller: eventTimeController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.access_time),
                            hintText: 'Event Time ',
                            contentPadding: const EdgeInsets.all(15),
                            filled: true ,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                              borderRadius: BorderRadius.circular(6),
                            )
                        ) ,),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                              child: AutoSizeText('  Cancel  ',style: TextStyle( ),),
                              shape: OutlineInputBorder(borderSide:BorderSide(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(15),
                              textColor: Colors.red,
                              onPressed: ()  {
                                Navigator.pop(context);
                              }
                          ),

                          FlatButton(
                              child: AutoSizeText('  Add  ',style: TextStyle( ),),
                              shape: OutlineInputBorder(borderSide:BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(15),
                              textColor: Colors.blue,
                              onPressed: () {
                                //.instance.collection('calender').
                              //  document(_dateName).collection('events').document(eventNameController.text).setData({
                                 // 'eventName' : eventNameController.text,
                                  //'time' : eventTimeController.text,
                               // });
                                Firestore.instance.collection('calender').document(_dateName).setData({
                                  'date': _dateName,
                                });
                                String today =  DateTime.now().year.toString() + DateTime.now().month.toString() + DateTime.now().day.toString() + " " + DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
                                Firestore.instance.collection('Events').document(today).setData({
                                  'date': _dateName,
                                  
                                  'eventName' : eventNameController.text,
                                  'time' : eventTimeController.text,
                                });
                                eventNameController.clear();
                                eventTimeController.clear();
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context)=> MessageDialog("Thank you, the event has been added"));
                              }
                          ),

                        ],),
                    ),


                  ]),
            )));
  }
}


final  eventNameController = TextEditingController();
final  eventTimeController = TextEditingController();


