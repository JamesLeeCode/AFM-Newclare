import 'package:afmnewclareapp/layouts/home_layout.dart';
import 'package:afmnewclareapp/layouts/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

String firebaseError = '';
class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future resetPassword(String email)  async{
    try{
      await _auth.sendPasswordResetEmail(email: email);

      return true;
    }
    catch(e){
      firebaseError = e.toString();
      return false;
    }
  }
  Future registerWithEmailAndPassword(String email, String password)  async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return true;
    }
    catch(e){
      firebaseError = e.toString();
      return false;
    }
  }

  Future signInWithEmailAndPassword(String email, String password)  async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      superUser = true;
      loggedIn = true;
      return true;
    }
    catch(e){
      firebaseError = e.toString();
      return false;
    }
  }
}


class User{
  final String uid ;
  User({this.uid});
}