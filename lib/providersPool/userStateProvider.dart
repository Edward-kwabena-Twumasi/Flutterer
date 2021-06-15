import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  userStates? signinstate;
  userStates? registedstate;
  String? loggedInAs;
  String? loggedinmail;
  String? registedmail;
  userStates userState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentuser;

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        signinstate = userStates.signedOut;

        print('User is currently signed out!');
      } else {
        signinstate = userStates.successful;
        loggedinmail = currentuser!.email;
        //currentuser.getIdToken();
        print('User is signed in!');
      }
    });

    notifyListeners();
    return signinstate!;
  }

  Future<userStates?> signInWithMPass(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      signinstate = userStates.successful;

      print("we done");
      loggedinmail = email;
      print(loggedinmail);
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

  Future<userStates?> registerwithMPass(String email, String password) async {
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

  Future<void> addUser(
      String fullname, String email, String phone, String city, String house) {
    //FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user

    return users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'full_name': fullname,
          'email': email, // John Doe
          'phone': phone, // Stokes and Sons
          'city': city,
          'house': house // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  } //adduser
} //end class
