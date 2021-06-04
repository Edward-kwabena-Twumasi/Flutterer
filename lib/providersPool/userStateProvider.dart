import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

enum userStates {
  signedIn,
  signedOut,
  isRegistered,
  registerNow,
  wrongPassword,
  weakpassword,
  successful
}

class UserState extends ChangeNotifier {
  userStates signinstate;
  userStates registedstate;

  Future<userStates> userState() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User user) {
      if (user == null) {
        signinstate = userStates.signedOut;
        print('User is currently signed out!');
      } else {
        signinstate = userStates.signedIn;

        print('User is signed in!');
      }
    });

    notifyListeners();
    return signinstate;
  }

  Future<userStates> signInWithMPass(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      signinstate = userStates.successful;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        signinstate = userStates.registerNow;
        print(registedstate);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        signinstate = userStates.wrongPassword;
      }
    }
    notifyListeners();
    return signinstate;
  }

  Future<userStates> registerwithMPass(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      registedstate = userStates.successful;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        registedstate = userStates.weakpassword;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        registedstate = userStates.isRegistered;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return registedstate;
  }

  Future<void> addUser(String fullname, String phone, String location) {
    //FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user

    return users
        .add({
          'full_name': fullname, // John Doe
          'phone': phone, // Stokes and Sons
          'address': location // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  } //adduser
} //end class
