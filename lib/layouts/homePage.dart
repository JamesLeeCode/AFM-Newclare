import 'package:afmnewclareapp/layouts/calender_layout.dart';
import 'package:afmnewclareapp/layouts/home_layout.dart';
import 'package:afmnewclareapp/layouts/ministries_layout.dart';
import 'package:afmnewclareapp/layouts/prayer_request_layout.dart';
import 'package:afmnewclareapp/layouts/suggestions_layout.dart';
import 'package:afmnewclareapp/layouts/sunday_word_layout.dart';
import 'package:afmnewclareapp/services/auth_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


bool loggedIn = false;
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  YoutubePlayerController _controller;
  String initialVideoId2="";
  ScrollController scrollController;
  bool scrollVisible = true;
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
            child: Icon(Icons.alarm    , color: Colors.grey[850], size: 40,),
            title: "Church Announcements",
            titleColor: Colors.grey[850],
            subtitle: "List of important announcements",
            subTitleColor: Colors.grey[850],
            backgroundColor: Colors.grey[50],
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomePage()));
            },
          ),
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
  Future getUrl() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await Firestore.instance.collection(
        'videos').orderBy('date', descending: true).getDocuments();

    DocumentSnapshot ds = qn.documents[1];
    initialVideoId2 = YoutubePlayer.convertUrlToId(ds["videoULR"]);
   // initialVideoId = initialVideoId2;

    _firebaseMessaging.getToken().then((onValue)
    {
      _firebaseMessaging.subscribeToTopic("announcements");
      print("User Subscribed");
    }).catchError((onError)
    {
      print("User not Subscribed : " + onError.toString());
    });
  }
  void setDialVisible(bool value) {
    setState(() {
      scrollVisible = value;
    });
  }
    @override
  void initState(){

      scrollController = ScrollController()
        ..addListener(() {
          setDialVisible(scrollController.position.userScrollDirection ==
              ScrollDirection.forward);
        });
      getUrl();
    _controller = YoutubePlayerController(
      initialVideoId: initialVideoId,
      flags: YoutubePlayerFlags(
        mute: false,
        enableCaption:false ,
        hideControls: false ,
        autoPlay: false,
      ),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(top: true,
      bottom: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height:10 ,),
                      Image.asset('images/logo.png',height: 200,),
                      AutoSizeText('AFM Immanuel Newclare',  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18)),
                      AutoSizeText("Where Jesus is Lord and People are Precious", textAlign: TextAlign.center, style: TextStyle( color: Colors.white,fontStyle: FontStyle.italic, fontSize: 17)),
                      SizedBox(height:20 ,),
                      Row(children: <Widget>[
                        Icon(Icons.phone_in_talk,color: Colors.white,),
                        SizedBox(width:10 ,),
                        Text('011 568 6848',  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16))
                      ],),
                      Row(children: <Widget>[
                        Icon(Icons.location_on,color: Colors.white,),
                        SizedBox(width:10 ,),
                        Container(child: AutoSizeText('Cnr Styler and Southey, Newclare, JHB',wrapWords: true ,  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16)))
                      ],),
                      GestureDetector(
                        onTap: (){
                          _LaunchURL();
                        },
                        child: Row(children: <Widget>[
                          Icon(FontAwesomeIcons.facebook, color: Colors.white,),
                          SizedBox(width:10 ,),
                          Text('AFM Newclare',  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16))
                        ],),
                      ),
                      Row(children: <Widget>[
                        Icon(Icons.access_time,color: Colors.white,),
                        SizedBox(width:10 ,),
                        Text('Sundays @ 08:00 - 10:00',  style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16))
                      ],),
                      SizedBox(width:5 ,),
                      SizedBox(height:5 ,),
                    ],
                  ),
                ),
              ),
              SizedBox(height:10 ,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(elevation: 5,
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("  Sunday's Service" , style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          FlatButton(
                            child: Text('View All'),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder:  (context) => SundaysWord()));
                            },
                          )
                        ],
                      ),
                    ),
                    StreamBuilder(

                        stream: Firestore.instance.collection(
                            'videos').orderBy('date', descending: true).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Column ( children : <Widget>[
                              CircularProgressIndicator(),
                              Text('Loading...')
                            ], ));
                          }
                          else {
                            String videoId;
                            DocumentSnapshot ds = snapshot.data.documents.first;
                            videoId = YoutubePlayer.convertUrlToId(ds["videoULR"]);
                            initialVideoId = videoId;
                          //  _controller.load(videoId);
                            return Column(
                              children: <Widget>[
                                YoutubePlayer(
                                  controller: _controller,
                                  progressIndicatorColor: Colors.amber,
                                  showVideoProgressIndicator: true,

                                  progressColors: ProgressBarColors(
                                      handleColor: Colors.amberAccent,
                                      backgroundColor: Colors.lime,
                                      bufferedColor: Colors.orange,
                                      playedColor: Colors.amber),

                                  onReady: () {
                                  },

                                ),

                              ],);
                          }
                        }
                    ),
                  ],),
                ),
              ),

              Container(
                child:    loggedIn ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(elevation: 5,child: ListTile(trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo,),leading: Icon(FontAwesomeIcons.userPlus,color: Colors.indigo,),
                    title: Text("Add New Admin",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context)=> AddAdminDialog(),
                      );
                    },),
                  ),
                )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(elevation: 5,child: ListTile(trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo,),leading: Icon(FontAwesomeIcons.lock,color: Colors.indigo,),
                  title: Text("Admin Login",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context)=> LoginDialog(),
                    );
                  },),
                ),
              ),),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                child: Card(elevation: 5,child: ListTile(trailing: Icon(Icons.arrow_forward_ios,color: Colors.redAccent,),leading: Icon(Icons.exit_to_app,color: Colors.redAccent,),
                  title: Text("Exit App",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent ),),
                  onTap: () {
                    SystemNavigator.pop();
                  },),
                ),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
        floatingActionButton: buildBoomMenu(),
      ),);
  }
}


_LaunchURL() async {
  const url ="https://www.facebook.com/AFMIMMANUELNEWCLARE/";
  if(await canLaunch(url)){
     await launch(url);
  }
  else{
    throw 'Couldnt open link';
  }
}




class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
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
                    AutoSizeText('Admin Login', style: TextStyle(fontSize: 18),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField( controller: userController,
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
                      child: TextField( controller: passwordController,
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[ FlatButton(
                            child: AutoSizeText('Forgot your password???',style: TextStyle( ),),
                            shape: OutlineInputBorder(borderSide:BorderSide(color: Colors.transparent, width: 0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.only(left: 8,right: 8),
                            textColor: Colors.pink,
                            onPressed: ()  {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context)=> ForgotPassword());

                            }

                        ),
                        ]
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
                              child: AutoSizeText('  Login  ',style: TextStyle( ),),
                              shape: OutlineInputBorder(borderSide:BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(15),
                              textColor: Colors.blue,
                              onPressed: () async {
                                try{

                                  dynamic results = await _auth
                                      .signInWithEmailAndPassword(
                                      userController.text, passwordController.text);
                                 Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>  FirstPage()));
                                  results? showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("You are now in Admin Mode!!!"))
                                      :showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("Error: " + firebaseError));


                                  userController.clear();
                                  passwordController.clear();



                                }
                                catch (e) {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context)=>MessageDialog("Error: "+ e.string));

                                }
                              }
                          ),

                        ],),
                    ),


                  ]),
            )));
  }
}
