import 'package:afmnewclareapp/layouts/home_layout.dart';
import 'package:afmnewclareapp/services/database_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final  punserController = TextEditingController();
final  prayerRequestController = TextEditingController();
class PrayerRequests extends StatefulWidget {
  @override
  _PrayerRequestsState createState() => _PrayerRequestsState();
}

class _PrayerRequestsState extends State<PrayerRequests> {
  getColor (String word)
  {
    String letter = word.substring(0,1).toLowerCase();

    if(letter == 'a' || letter == 'b' || letter == 'c'|| letter == 'd' ){
      return Colors.pink;
    }
    if(letter == 'f' || letter == 'g' || letter == 'h'|| letter == 'i' ){
      return Colors.amber;
    }
    if(letter == 'k' || letter == 'l' || letter == 'm'|| letter == 'o' ){
      return Colors.deepOrange;
    }
    if(letter == 'q' || letter == 'r' || letter == 's'|| letter == 't' ){
      return Colors.blue;
    }
    if(letter == 'v' || letter == 'w' || letter == 'x'|| letter == 'y' || letter == 'z'){
      return Colors.indigo;
    }
    if(letter == 'n' || letter == 'u' || letter == 'p'|| letter == 'j' || letter == 'e'){
      return Colors.blue;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
              onLongPress: () { Navigator.pop(context);},),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SafeArea(
            child: Card(
              color: Colors.white70,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AutoSizeText(' Prayer Requests ',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                      Padding(  padding: const EdgeInsets.only(left: 10),
                          child: IconButton(icon: Icon(Icons.home ,color: Colors.indigo,size: 43,),onPressed:(){
                            Navigator.pop(context);
                          },)
                      )
                    ],)
                  ,

                  StreamBuilder(
                    stream: Firestore.instance.collection(
                        'prayerRequest').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('Loading...'));
                      }
                      else {
                        return Expanded(
                          child: ListView.builder(
                           // Card1(loremIpsum, 'Brother James',
                            //  getColor('No youth this week'),),
                              itemCount: snapshot.data.documents.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder:(ctx, i) {
                                DocumentSnapshot ds = snapshot.data
                                    .documents[i];
                               return Card1(ds["prayerRequest"], ds["name"],
                                     getColor(ds["name"]),ds["date"]);
                              }
                          ),
                        );
                      }
                    }
                  )

                ],
              ),
            ),
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton (
          elevation: 5,
          child: Icon(Icons.add),
          onPressed: (){showDialog(
            context: context,
            builder: (BuildContext context)=> AddPrayerReq(),
          );},
          backgroundColor: Colors.pink,
        )
    );
  }
}



class Card1 extends StatelessWidget {
  final String heading;
  final String body;
  final String date;

  final MaterialColor topColor;
  Card1(this.body, this.heading, this.topColor, this.date );
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
          child: Card(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: topColor,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: AutoSizeText(
                          heading,
                          style: Theme.of(context).textTheme.body2.copyWith(fontSize: 16,),
                        )),
                    collapsed: Column(
                      children: <Widget>[
                        Text(
                          body,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Builder(
                              builder: (context) {
                                var controller = ExpandableController.of(context);
                                return FlatButton(
                                  child: Text(
                                    controller.expanded ? "COLLAPSE" : "EXPAND",
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(color: Colors.deepPurple),
                                  ),
                                  onPressed: () {
                                    controller.toggle();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              body,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            )),
                        Divider(
                          height: 1,
                        ),
                 superUser ? FlatButton(
                    child: Text( "Delete",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.deepPurple),
                    ),
                    onPressed: () {
                      var firestore = Firestore.instance;
                      firestore.collection('prayerRequest').document(date).delete();
                    },
                  ):
                     SizedBox(height: 0,),
                        Divider(
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Builder(
                              builder: (context) {
                                var controller = ExpandableController.of(context);
                                return FlatButton(
                                  child: Text(
                                    controller.expanded ? "COLLAPSE" : "EXPAND",
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(color: Colors.deepPurple),
                                  ),
                                  onPressed: () {
                                    controller.toggle();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],

                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class AddPrayerReq extends StatefulWidget {
  @override
  _AddPrayerReqState createState() => _AddPrayerReqState();
}

class _AddPrayerReqState extends State<AddPrayerReq> {
  DatabaseServices _db = DatabaseServices();
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
                    AutoSizeText('Add Prayer Request', style: TextStyle(fontSize: 18),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField( controller: punserController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Name',
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
                      child: TextField( controller: prayerRequestController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.format_align_left),
                            hintText: 'Prayer Request',
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
                                try{
                             _db.addPrayerReq(punserController.text,prayerRequestController.text);

                             Navigator.pop(context);
                             showDialog(
                                 context: context,
                                 builder: (BuildContext context)=> MessageDialog("Thank you, your prayer request has been added"));
                             punserController.clear();
                             prayerRequestController.clear();
                                }
                                catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("Error: " + e.toString()));
                                }
                              }
                          ),

                        ],),
                    ),


                  ]),
            )));
  }
}


const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
