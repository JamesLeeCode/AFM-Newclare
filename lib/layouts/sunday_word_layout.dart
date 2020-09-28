import 'package:afmnewclareapp/layouts/home_layout.dart';
import 'homePage.dart';
import 'package:afmnewclareapp/services/database_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final  urlController = TextEditingController();
final  vidDateController = TextEditingController();

class SundaysWord extends StatefulWidget {
  @override
  _SundaysWordState createState() => _SundaysWordState();
}

class _SundaysWordState extends State<SundaysWord> {
  YoutubePlayerController _controller;


  @override
  void initState(){

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
      body: SafeArea(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,

          child:  StreamBuilder(

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
                _controller.load(videoId);
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
                       _controller.play();
                      },

                    ),
                    SizedBox(height: 10,),
                    Row(children: <Widget>[ SizedBox(width: 25,),
                      AutoSizeText('Select A Video', style: TextStyle(
                          fontSize: 20),)
                    ]),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (ctx, i) {
                          DocumentSnapshot ds = snapshot.data.documents[i];
                          return GestureDetector(
                          onTap: (){

                          },
                            child: Card(elevation: 2,
                                  child: ListTile(onTap: () {

                                    videoId = YoutubePlayer.convertUrlToId(ds["videoULR"]);
                                   _controller.load(videoId,startAt: 0);

                                    print(videoId);
                                  },
                                      trailing: Icon(Icons.keyboard_arrow_right),
                                      leading: Icon(
                                        Icons.video_library, color: Colors.pink,),
                                      title: AutoSizeText(ds["videoName"].toString()))),
                          );

    }
                      ),
                    ),
                  ],);
              }
            }
          )

          ),
        ),

     floatingActionButton: superUser ? FloatingActionButton(
       backgroundColor: Colors.pink,
       elevation: 5,
       child: Icon(Icons.add),
       onPressed: (){
         showDialog(
             context: context,
             builder: (BuildContext context)=> addVideo());
       },
     ):
      SizedBox(height: 1),

    );
  }}
  
  class addVideo extends StatefulWidget {
    @override
    _addVideoState createState() => _addVideoState();
  }
  
  class _addVideoState extends State<addVideo> {
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
                      AutoSizeText('Add new Video', style: TextStyle(fontSize: 18),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField( controller: urlController,
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.video_library),
                              hintText: 'Paste Youtube link',
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
                        child: TextField( controller: vidDateController,
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.message),
                              hintText: 'Video Name',
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
                                  _db.uploadVideo(urlController.text,
                                      vidDateController.text);
                                  urlController.clear();
                                  vidDateController.clear();
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context)=> MessageDialog("Video has been added"));

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
  