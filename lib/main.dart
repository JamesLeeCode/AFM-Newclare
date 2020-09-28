import 'package:afmnewclareapp/layouts/homePage.dart';
import 'package:afmnewclareapp/layouts/home_layout.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AFM Newclare',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.indigo,
        ),
        home: SplashScreen()

    );
  }
}



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState(){
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2600),
      vsync: this,
    );
    _controller.repeat();
    new Future.delayed(const Duration(seconds: 5),
            ()=> Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => FirstPage()) ));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
        onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
    print("onResume: $message");
    },
    );
    _firebaseMessaging.subscribeToTopic("announcements");
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
        stream: Firestore.instance.collection(
        'videos').orderBy('date', descending: true).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: Column(children: <Widget>[
          CircularProgressIndicator(),
          Text('Loading...')
        ],));
      }
      else {
        String videoId;
        DocumentSnapshot ds = snapshot.data.documents.first;
        videoId = YoutubePlayer.convertUrlToId(ds["videoULR"]);
        initialVideoId = videoId;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Image.asset('images/logo.png'),
                    )),
              ),
              // AutoSizeText('AFM NEWCLARE ',style :TextStyle( color: Colors.white,fontWeight: FontWeight.bold,fontSize: 29 )),
              // SizedBox(height: 20,),
              // AutoSizeText('Where Jesus is Lord',style :TextStyle( color: Colors.white70,fontWeight: FontWeight.bold,fontSize: 18)),
              //AutoSizeText('and',style :TextStyle( color: Colors.white70,fontWeight: FontWeight.bold,fontSize: 15)),
              // AutoSizeText('People are Precious',style :TextStyle( color: Colors.white70,fontWeight: FontWeight.bold,fontSize: 18)),
            ],
          ),
        );
      }
    }),
        ),
      ),

    );
  }
}
