import 'package:afmnewclareapp/layouts/home_layout.dart';
import 'package:afmnewclareapp/services/database_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Suggestions extends StatefulWidget {
  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  final DatabaseServices _db= DatabaseServices();
  final  _suggestionController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    final suggestionField =  TextField( controller: _suggestionController,
      style: TextStyle(fontSize: 17, color: Colors.black54),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.wb_sunny),
          hintText: 'Your Suggestion',
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
      ) ,);
    return SafeArea(
      child: Scaffold(
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
                onPressed: (){  Navigator.pop(context);},
                onLongPress: () {},),
            )
          ],
        ),
        body: superUser? Column(children: <Widget>[
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(' Suggestion Box',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, ),),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row (
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.delete ,color: Colors.indigo,size: 43,),onPressed:(){
                          Navigator.pop(context);
                        },),
                        IconButton(icon: Icon(Icons.home ,color: Colors.indigo,size: 43,),onPressed:(){
                          Navigator.pop(context);
                        },),

                      ]
                  )
              )
            ],)
          ,
          StreamBuilder(
            stream:  Firestore.instance.collection(
                'suggestions').snapshots(),
            builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Center(child: Column ( children : <Widget>[
      CircularProgressIndicator(),
      Text('Loading...')
    ], ));
    }
    else {
      return Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (ctx, i) {
            DocumentSnapshot ds = snapshot.data
                .documents[i];
          return  ListTile(title: AutoSizeText(ds["suggestion"]), trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.grey,),
                onPressed: () {}),);

          } ),
      );
    }
            }
          ),
        ],):
        Container(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Center(
                
                  child: Card(
                    color: Colors.white,
                    elevation: 6,
                    borderOnForeground: true,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(children: <Widget>[
                        Image.asset('images/logo.png',
                          height: 165.0,
                          fit: BoxFit.cover,
                        ),
                        AutoSizeText('Please give us your suggestions, anonymously', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(height: 10,),
                        suggestionField,
                        SizedBox(height: 10,),
                       Row(children: <Widget>[
                         FlatButton(
                             child: AutoSizeText('Cancel',style: TextStyle( ),),
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
                             child: AutoSizeText('Send',style: TextStyle( ),),
                             shape: OutlineInputBorder(borderSide:BorderSide(color: Colors.blue, width: 2),
                               borderRadius: BorderRadius.circular(5),
                             ),
                             padding: const EdgeInsets.all(15),
                             textColor: Colors.blue,
                             onPressed: () async {
                               try {
                                 _db.addSuggestions(_suggestionController.text);
                                 setState(() {
                                   _suggestionController.clear();

                                 });
                                 Navigator.pop(context);
                                 showDialog(
                                     context: context,
                                     builder: (BuildContext context)=> MessageDialog("Thank you for your suggestion, we will act on it accordingly"));
                               }
                               catch (e) {
                                 final snakeBar = SnackBar(elevation: 2,
                                   content: AutoSizeText(
                                       "Error: " + e.toString()),);
                                 Scaffold.of(context).showSnackBar(snakeBar);
                               }

                             }
                         ),

                       ],)
                      ],),
                    ),
                  ),
                ),
             
      ]
            ),
          ),
        )

      ),
    );
  }
}
