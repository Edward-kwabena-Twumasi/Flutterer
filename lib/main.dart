import 'dart:html';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:myapp/components/text_inputwidgets.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:myapp/screens/signup.dart';

//irebase

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => UserState(), builder: (context, _) => App()));
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
              home: Container(
                  child: Text(snapshot.error.toString() +
                      "App encountering some network errors.Please call 0552489602 for assistance")));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(width: 10.0, height: 10.0);
      },
    );
  }
}
//firebase

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  var style = TextStyle(
    color: Colors.blueAccent,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    backgroundColor: Colors.white,
    fontSize: 30,
  );

  // var input =
  // final controller = TextEditingController();
  // final controller1 = TextEditingController();
  // final controller2 = TextEditingController();
  // @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {"/home": (context) => TabBarDemo()},
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Travellers Mobile App'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            height: 920,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30)),
            width: 500,
            child: Card(
              elevation: 3.6,
              color: Colors.white,
              child: Consumer<UserState>(
                builder: (context, value, child) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidgets("Login", style, Icon(Icons.login)),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: MyForm(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//MyForm
class MyForm extends StatefulWidget {
  MyFormState createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  bool allowlogin = false;
  bool retry = true;
  var correctLogin = "";

  // final String hint, hint1, hint2;
  // final TextEditingController controller;
  // final TextEditingController controller1;
  // final TextEditingController controller2;
  // MyFormState(this.hint, this.hint1, this.hint2, this.controller,
  //     this.controller1, this.controller2);

  final myController = TextEditingController();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    // myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  // void _printLatestValue() {
  //   print('Second text field: ${myController.text}');
  // }

  void checkStatus(userStates state) {
    if (state == userStates.registerNow) {
      setState(() {
        // retry = false;
        correctLogin = "You are not a registered user!";
      });
    } else if (state == userStates.wrongPassword) {
      setState(() {
        correctLogin = "You entered wrong password for this account";
      });
    } else {
      setState(() {
        allowlogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return retry
        ? Consumer<UserState>(
            builder: (context, value, child) => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputFields(
                      "Enter Username", myController, Icon(Icons.input)),
                  SizedBox(
                    height: 5,
                  ),
                  InputFields("Enter Email", myController1, Icon(Icons.email)),
                  SizedBox(
                    height: 5,
                  ),
                  InputFields(
                      "Enter Password", myController2, Icon(Icons.password)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        //padding:  EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.

                          if (_formKey.currentState.validate()) {
                            // if (checkStatus(myController1.text)) {
                            //   Navigator.push(context, MaterialPageRoute(
                            //     builder: (context) {
                            //       return TabBarDemo();
                            //     },
                            //   ));
                            // }
                            value
                                .signInWithMPass(
                                    myController1.text, myController2.text)
                                .then((registedstate) {
                              checkStatus(registedstate);
                              if (allowlogin) {
                                Navigator.pushNamed(context, '/home');
                              }
                            });
                          }
                        },

                        child: Text('Submit'),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text("Dont have an account?"),
                      TextButton(
                        onPressed: () {
                          // value.setaction("Signup");
                          setState(() {
                            allowlogin = false;
                            retry = false;
                          });
                        },
                        child: Text('Sign Up Instead'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      correctLogin,
                      style: TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.red,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  TextButton(
                      child: Text("go home"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      }),
                ],
              ),
            ),
          )
        : SignupForm();
  }
}
