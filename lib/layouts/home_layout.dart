import 'package:afmnewclareapp/layouts/calender_layout.dart';
import 'package:afmnewclareapp/layouts/ministries_layout.dart';
import 'package:afmnewclareapp/layouts/prayer_request_layout.dart';
import 'package:afmnewclareapp/layouts/suggestions_layout.dart';
import 'package:afmnewclareapp/layouts/sunday_word_layout.dart';
import 'package:afmnewclareapp/main.dart';
import 'package:afmnewclareapp/services/auth_services.dart';
import 'package:afmnewclareapp/services/database_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:expandable_card/expandable_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:math' as math;

String initialVideoId ="";
bool superUser = false;
String thisWeekUrl ;
Map<DateTime, List> eventsMap;

bool notPasswordLayout = true;
final  userController = TextEditingController();
final  passwordController = TextEditingController();
final  resetpasswordController = TextEditingController();
final  announcementHeadingController = TextEditingController();
final  announcementDecsController = TextEditingController();

final  userController1 = TextEditingController();
final  passwordController1 = TextEditingController();
class DesigningColor{
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
      return Colors.grey;
    }
  }

}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ScrollController scrollController;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool scrollVisible = true;
  Future getUrl() async{

 /*   var firestore = Firestore.instance;
   QuerySnapshot qn = await firestore.collection('videos').getDocuments();

    DocumentSnapshot ds = qn.documents[0];
    initialVideoId = YoutubePlayer.convertUrlToId(ds["videoULR"]);

    _firebaseMessaging.getToken().then((onValue)
        {
          _firebaseMessaging.subscribeToTopic("announcements");
          print("User Subscribed");
        }).catchError((onError)
        {
          print("User not Subscribed : " + onError.toString());
        });

  */
  }


  @override
  void initState() {
    super.initState();
    getUrl();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });

  }

  void setDialVisible(bool value) {
    setState(() {
      scrollVisible = value;
    });
  }

  BoomMenu buildBoomMenu() {
    return BoomMenu(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
       /// child: Icon(Icons.add),
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        scrollVisible: scrollVisible,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        children: [
          MenuItem(
            child: Icon(Icons.settings_backup_restore, color: Colors.white, size: 40,),
            title: "Sunday's Word",
            titleColor: Colors.white,
            subtitle: "Watch and listen to Sunday's sermon",
            subTitleColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: (){
            Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SundaysWord()));
            },
          ),
          MenuItem(
            child: Icon(Icons.format_list_bulleted      , color: Colors.grey[850], size: 40,),
            title: "Prayer Requests",
            titleColor: Colors.grey[850],
            subtitle: "Indercede for those in need of Prayer",
            subTitleColor: Colors.grey[850],
            backgroundColor: Colors.grey[50],
            onTap: () {
                 Navigator.push(context, MaterialPageRoute(
              builder: (context) => PrayerRequests()));
            },
          ),

          MenuItem(
            child: Icon(Icons.people, color: Colors.white, size: 40,),
            title: "Our Ministries",
            titleColor: Colors.white,
            subtitle: "All thr church ministries and their leaders",
            subTitleColor: Colors.white,
            backgroundColor: Colors.pinkAccent,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  Ministries()));
            },
          ),

          MenuItem(
            child: Icon(Icons.date_range, color: Colors.grey[850], size: 40,),
            //child: Image.asset (
            //'assets/logout_icon.png', color: Colors.grey[850]),
            title: "Church Calendar",
            titleColor: Colors.grey[850],
            subtitle: "View the important dates and events happening this month ",
            subTitleColor: Colors.grey[850],
            backgroundColor: Colors.grey[50],
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  CalendarScreen()));
            },
          ),
          MenuItem(
            child: Icon(Icons.input, color: Colors.white, size: 40,),
            title: "Suggestion Box",
            titleColor: Colors.white,
            subtitle: "Anonymously send suggestions to the leadership",
            subTitleColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: ()  {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  Suggestions()));
            },
          )
        ]
    );
  }
  @override
  Widget build(BuildContext context) {
    // ignore: missing_return
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
        return Colors.teal;
      }
    }
    return Material(
      child: Scaffold(
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
       AutoSizeText('AFM Newclare',style: TextStyle(color: Colors.indigo,fontSize: 16,fontWeight: FontWeight.w500),)
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
 /* actions: <Widget>[
    superUser ?  FlatButton(child: AutoSizeText('Add Admin',style: TextStyle(color: Colors.indigo,fontSize: 15,fontWeight: FontWeight.w500 ),),
      padding: EdgeInsets.all(5.0),
      onPressed: (){
        showDialog(
          context: context,
          builder: (BuildContext context)=> AddAdminDialog(),
        );
      },):
        SizedBox(height: 1,width: 1,),
    Padding(
      padding: const EdgeInsets.only(right: 10),
      child: superUser?  FlatButton(child: AutoSizeText('Sign Out',style: TextStyle(color: Colors.indigo,fontSize: 15,fontWeight: FontWeight.w500 ),),
        padding: EdgeInsets.all(5.0),
        onPressed:(){
          setState(() {
            superUser = false;
          });
        } ,)
      :
      FlatButton(child: AutoSizeText('Church Admin',style: TextStyle(color: Colors.indigo,fontSize: 15,fontWeight: FontWeight.w500 ),),
      padding: EdgeInsets.all(5.0),
      onPressed: (){
        showDialog(
          context: context,
          builder: (BuildContext context)=> LoginDialog(),
        );
      },
      onLongPress: (){
        setState(() {
         // superUser = true;
        });

      },)

    )
  ], */
) ,
        body: ExpandableCardPage(

    page: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: StreamBuilder(
            stream: Firestore.instance.collection(
              'announcements').orderBy('date', descending: true).snapshots(),
            builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Center(child: Text('Loading...'));
    }
    else {
              return Card(
                color: Colors.white70,
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Text(' Announcements',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: superUser?   Row( children: <Widget>[
                     IconButton(icon:  Icon(Icons.add,color: Colors.indigo,size: 40,), onPressed: (){

                       showDialog(
                           context: context,
                           builder: (BuildContext context)=> AddAnnouncement());
                     })
                        ,
                        ])
                        :Icon(Icons.notifications_active,color: Colors.indigo,size: 40,)


                      )
                    ],)
                    ,
                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
    itemCount: snapshot.data.documents.length,
    itemBuilder: (ctx, i) {
      DocumentSnapshot ds = snapshot.data.documents[i];
      //      Card1(loremIpsum,'No youth this week', getColor('No youth this week'),'1 Jun 2020', '10:20'),
      return Card1(
          ds["message"], ds["title"], getColor(ds["title"]),
          ds["date"], ' ');

    }

                  ),
                )
                  /*  ExpandableTheme(
                      data:
                      const ExpandableThemeData(
                        iconColor: Colors.blue,
                        useInkWell: true,
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: <Widget>[
                          Card1(),
                          Card2(),
                        ],
                      ),
                    ),*/
                  ],
                ),
              );
              }
            }
          ),
        ),
      ),
    ),
    expandableCard: ExpandableCard(
      hasShadow: true,
      hasHandle: true,
    minHeight: 110,
    hasRoundedCorners: true,
      backgroundColor: Colors.indigo,
    padding: EdgeInsets.only(left: 20, right: 20),
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
          children: <Widget>[

          AutoSizeText("Church Details",
            style: TextStyle( color: Colors.white, fontSize: 17)
            ,),

        ],),
      ),
      SingleChildScrollView(
          child: Center(
            child: Column(
                children: <Widget>[
                  SizedBox(height:10 ,),
                  Image.asset('images/logo.png',height: 145,),
                  AutoSizeText('AFM Immanuel Newclare',  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18)),
                  AutoSizeText("Where Jesus is Lord and People are Precious", textAlign: TextAlign.center, style: TextStyle( color: Colors.white,fontStyle: FontStyle.italic, fontSize: 17)),
                  SizedBox(height:20 ,),
                  Row(children: <Widget>[
                    Icon(Icons.phone_in_talk,color: Colors.white,),
                    SizedBox(width:10 ,),
                    Text('011 568 6848',  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16))
                  ],),
                 SizedBox(height:10 ,),
                  Row(children: <Widget>[
                    Icon(Icons.location_on,color: Colors.white,),
                    SizedBox(width:10 ,),
                    Container(child: AutoSizeText('Cnr Styler and Southey, Newclare, JHB',wrapWords: true ,  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16)))
                  ],)
                  , SizedBox(height:10 ,),
                  Row(children: <Widget>[
                    Icon(Icons.access_time,color: Colors.white,),
                    SizedBox(width:10 ,),
                    Text('Sundays @ 08:00 - 10:00',  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16))
                  ],)
                ],
            ),
          )
      ),
    ],
    ),),
      //  floatingActionButton: buildBoomMenu(),


      ),
    );
  }
}


const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class Card1 extends StatelessWidget {
  final String heading;
  final String body;
  final String date;
  final String time;
  final MaterialColor topColor;
  Card1(this.body, this.heading, this.topColor, this.date, this.time );
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
                  height: 3,
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
                        padding: EdgeInsets.all(5),
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
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                               date,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              time,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                          ),
                        ),
                        SizedBox(height: 10,),
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
                            firestore.collection('announcements').document(date).delete();
                          },
                        ):
                        SizedBox(height: 0,),
                        SizedBox(height: 10,),
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

class AddAdminDialog extends StatefulWidget {
  @override
  _AddAdminDialogState createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  final AuthService _auth = AuthService();
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
                    AutoSizeText('Add Admin', style: TextStyle(fontSize: 18),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField( controller: userController1,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Email',
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
                      child: TextField( controller: passwordController1,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
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
                              child: AutoSizeText('  Add Admin  ',style: TextStyle( ),),
                              shape: OutlineInputBorder(borderSide:BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(15),
                              textColor: Colors.blue,
                              onPressed: () async {
                                try{
                                dynamic results = await _auth
                                    .registerWithEmailAndPassword(
                                    userController1.text, passwordController1.text);
                                Navigator.pop(context);
                                results? showDialog(
                                    context: context,
                                    builder: (BuildContext context)=> MessageDialog("You have been registered as an Admin ,you can login now!!!"))
                                    :showDialog(
                                    context: context,
                                    builder: (BuildContext context)=> MessageDialog("Error: " + firebaseError));
                                }
                                catch (e) {
                                  MessageDialog("Error: "+ e.string);
                                  Navigator.pop(context);
                                }
                              }
                          ),

                        ],),
                    ),


                  ]),
                    ),


                  ),
            );
  }
}
TextStyle style = TextStyle(fontFamily: 'Montserrat', );

class AddAnnouncement extends StatefulWidget {
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
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
                    AutoSizeText('Add Announcement', style: TextStyle(fontSize: 18),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField( controller: announcementHeadingController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.notifications_active),
                            hintText: 'Announcement Heading',
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
                      child: TextField( controller: announcementDecsController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            hintText: 'Announcement Message',
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
                                  _db.addAnnouncements(announcementHeadingController.text,
                                      announcementDecsController.text);
                                  announcementHeadingController.clear();
                                  announcementDecsController.clear();
                                  Navigator.pop(context);
                                  firebaseResults? showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("Announcement was added"))
                                      :showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("Error: " + firebaseError));
                                }
                                catch (e) {
                                  Navigator.pop(context);
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


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Dialog (
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular( 7)),
        elevation: 3,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:   Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/logo.png',
                      height: 180.0,
                      fit: BoxFit.cover,
                    ),
                    AutoSizeText('Reset Password', style: TextStyle(fontSize: 18),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField( controller: resetpasswordController,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Email',
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
                              child: AutoSizeText('  Reset Password  ',style: TextStyle( ),),
                              shape: OutlineInputBorder(borderSide:BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(15),
                              textColor: Colors.blue,
                              onPressed: () async {
                                try{
                                  dynamic results = await _auth
                                      .resetPassword(
                                      resetpasswordController.text);
                                  setState(() {
                                                   resetpasswordController.clear();
                                  });

                                  Navigator.pop(context);
                                  results? showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("An Email with a link to reset your password was added to your email, open the link to reset your email"))
                                      :showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("Error: " + firebaseError));
                                }
                                catch (e) {
                                  MessageDialog("Error: "+ e.string);
                                  Navigator.pop(context);
                                }
                              }
                          ),

                        ],),
                    ),


                  ]),
            )));
  }
}


class MessageDialog extends StatelessWidget {
 final String message;
  MessageDialog(this.message);
  @override
  Widget build(BuildContext context) {
    return Dialog (
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular( 7)),
        elevation: 3,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:   Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
              Padding(
              padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(message,style: TextStyle(fontWeight: FontWeight.bold),)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height: 2,),

                          FlatButton(
                              child: AutoSizeText('  OK,Thanks  ',style: TextStyle( ),),
                              shape: OutlineInputBorder(borderSide:BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(15),
                              textColor: Colors.blue,
                              onPressed: () async {
                                Navigator.pop(context);
                                }
                          ),

                        ],),
                    ),


                  ]),
            )));
  }
}



class EventsL {
  final String name;
  final bool isDone;
  final String time;
  final String date;

  EventsL({
    this.name,
    this.isDone,
    this.time,
    this.date

  });
}
