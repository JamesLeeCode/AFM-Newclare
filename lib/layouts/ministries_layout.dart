import 'package:afmnewclareapp/layouts/home_layout.dart';
import 'package:afmnewclareapp/services/database_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ministries extends StatefulWidget {
  @override
  _MinistriesState createState() => _MinistriesState();
}

class _MinistriesState extends State<Ministries> {
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
      return Colors.pink;
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
                      Text(' Our Ministries',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(icon: Icon(Icons.home ,color: Colors.indigo,size: 43,),onPressed:(){
                          Navigator.pop(context);
                        },)
                      )
                    ],)
                  ,
                  StreamBuilder(
                    stream: Firestore.instance.collection(
                        'ministries').snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) {
                        return Center(child: Text('Loading...'));
                      }
                      else {
                        return Expanded(
                          child: ListView.builder(
                            //  Card1(loremIpsum,'Sunday School', getColor('Sunday School'),'Sis Julia - 074 743 7874', 'Bro Tyron - 079 970 2454'),
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (ctx, i) {
                                DocumentSnapshot ds = snapshot.data
                                    .documents[i];
                                return Card1(
                                    ds["ministryDesc"], ds["ministryName"],
                                    getColor(ds["ministryName"]),
                                    ds["leaderName1"] + ' - ' +
                                        ds["leaderCell1"],
                                    ds["leaderName2"] + ' - ' +
                                        ds["leaderCell2"]);
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
      floatingActionButton: superUser ? FloatingActionButton(
        backgroundColor: Colors.pink,
        elevation: 5,
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context)=> AddMinistries());
        },
      ):
      SizedBox(height: 1),

    );
  }
}



class Card1 extends StatelessWidget {
  final String heading;
  final String body;
  final String firstContact;
  final String secondContact;
  final MaterialColor topColor;
  Card1(this.body, this.heading, this.topColor, this.firstContact, this.secondContact );
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                    header: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Container(margin: EdgeInsets.only(left: 10,top: 5,bottom: 5,right: 10),
                          height: 40,
                          width: 40,
                          child: Center(
                            child: AutoSizeText(heading.substring(0,1).toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                          decoration: BoxDecoration(
                            color: topColor,
                            shape: BoxShape.circle
                          ),

                          ),
                          Padding(
                          padding: EdgeInsets.only(right: 10,top: 10,bottom: 10),
                          child: AutoSizeText(
                            heading,
                            style: Theme.of(context).textTheme.body2.copyWith(fontSize: 16,),
                          )),
  ] ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(

                            children: <Widget>[
                              SizedBox(height: 10,),
                              Row(children: <Widget>[
                                AutoSizeText("Ministry Leaders:", style: TextStyle(fontWeight: FontWeight.bold), )
                              ],),
                              SizedBox(height: 10,),
                              Row(children: <Widget>[
                                Icon(Icons.person,color: Colors.indigo,size: 35),
                                AutoSizeText(firstContact, )
                              ],),
                              Divider(
                                height: 1,
                              ),
                              SizedBox(height: 10,),
                              Row(children: <Widget>[
                                Icon(Icons.person,color: Colors.indigo,size: 35,),
                                AutoSizeText(secondContact, )
                              ],)
                            ],
                          )
                        ),
                        SizedBox(height: 10,),
                        superUser ? FlatButton(
                          child: Text( "Delete",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.deepPurple),
                          ),
                          onPressed: () {
                            var firestore = Firestore.instance;
                            firestore.collection('ministries').document(heading).delete();
                          },
                        ):
                        SizedBox(height: 0,),
                        Divider(
                          height: 1,
                        ),
                        SizedBox(height: 10,),
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

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";


class AddMinistries extends StatefulWidget {
  @override
  _AddMinistriesState createState() => _AddMinistriesState();
}

class _AddMinistriesState extends State<AddMinistries> {
 final DatabaseServices db = DatabaseServices();
  @override
  Widget build(BuildContext context) {
    return Dialog (
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular( 7)),
        elevation: 3,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/logo.png',
                      height: 180.0,
                      fit: BoxFit.cover,
                    ),
                    AutoSizeText('Add A Ministry', style: TextStyle(fontSize: 18),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField( controller: ministryNameController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.wb_sunny),
                            hintText: 'Ministry Name',
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
                      child: TextField( controller: ministryDescController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            hintText: 'Ministry Description',
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
                      child: TextField( controller: leaderNameController1,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.perm_contact_calendar),
                            hintText: 'Leader Name',
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
                      child: TextField( controller: leaderCellController1,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_in_talk),
                            hintText: 'Cell Number',
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
                      child: TextField( controller: leaderNameController2,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.perm_contact_calendar),
                            hintText: 'Leader Name',
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
                      child: TextField( controller: leaderCellController2,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_in_talk),
                            hintText: 'Cell Number',
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
                                try {
                                  db.uploadMinistries(ministryNameController
                                      .text, ministryDescController.text,
                                      leaderNameController1.text,
                                      leaderCellController1.text,
                                      leaderNameController2.text,
                                      leaderCellController2.text);
                                  setState(() {
                                    ministryNameController.clear();
                                    ministryDescController.clear();
                                    leaderNameController1.clear();
                                    leaderCellController1.clear();
                                    leaderNameController2.clear();
                                    leaderCellController2.clear();
                                  });
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("Thank you, The ministry has been added"));
                                }
                                catch (e) {
                                  final snakeBar = SnackBar(elevation: 2,
                                    content: AutoSizeText(
                                        "Error :" + e.toString()),);
                                  Scaffold.of(context).showSnackBar(snakeBar);
                                }
                              }
                          ),

                        ],),
                    ),


                  ]),
            )));
  }
}


final  ministryNameController = TextEditingController();
final  ministryDescController = TextEditingController();

final  leaderNameController1 = TextEditingController();
final  leaderCellController1 = TextEditingController();

final  leaderNameController2 = TextEditingController();
final  leaderCellController2 = TextEditingController();