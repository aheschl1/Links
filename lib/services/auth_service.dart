

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:links/services/database_service.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges();
  }

  Future signOut() async{
    bool success = await FirebaseMessaging.instance.unsubscribeFromTopic(_firebaseAuth.currentUser.uid).then((value) => true).catchError((onError)=>false);
    if(success){
      try{
        return await _firebaseAuth.signOut();
      }catch(error){
        print(error.toString());
        return "Something went wrong";
      }
    }else{
      return "Something went wrong";
    }


  }

  Future registerEmailPass({String email, String password, String name})async{

    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      result.user.updateProfile(displayName: name);
      DatabaseService().createUserPage(email, name, result.user.uid);
      FirebaseMessaging.instance.subscribeToTopic(result.user.uid);
      return result.user;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email.';
      }else{
        return "Something went wrong";
      }
    }

  }

  Future signInEmailAndPass({String email, String password})async{

    try{
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseMessaging.instance.subscribeToTopic(result.user.uid);
      return result.user;
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }else{
        return 'Something went wrong.';
      }
    }

  }

}