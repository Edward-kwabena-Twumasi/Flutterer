import 'dart:async';

//import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:myapp/providersPool/agentStateProvider.dart';
import 'package:myapp/screens/admin.dart';
import 'package:myapp/screens/agentlogin.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:myapp/screens/signup.dart';

//irebase

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
// import 'package:myapp/screens/websocket.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserState(),
    ),
    ChangeNotifierProvider(
      create: (context) => CompanyState(),
    ),
  ], child: App()));
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
//firebase acheamponghuttel95@gmail.com

// void main() {
//   runApp(MyApp());
// }
bool retry = true;

class MyApp extends StatelessWidget {
  final style = TextStyle(
    color: Colors.blueAccent,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    backgroundColor: Colors.white,
    fontSize: 30,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/home": (context) => ButtomNav(),
          "/admin": (context) => Admin(),
          "/agentlogin": (context) => MyCompApp()
        },
        title: 'Great Travelling App',
        home: AppHome());
  }
}

class AppHome extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: ListTile(
          leading: Icon(Icons.star, color: Colors.amber),
          trailing: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              child: Text("Admin")),
          title: Center(
            child: Text(
              "Travel Mates",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 900,
          child: Column(children: [
            ListTile(
              title: Center(
                child: Text(
                  "Love to travel?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3),
              child: MyForm(),
            ),
            ListTile(
              tileColor: Colors.grey[200],
              title: Center(child: Text("For companies")),
              subtitle: RawMaterialButton(
                fillColor: Colors.amber,
                onPressed: () {
                  Navigator.pushNamed(context, '/agentlogin');
                },
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Text("Companies",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                shape: StadiumBorder(),
              ),
            ),
          ]),
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
  bool isuser = true;
  bool verified = true;
  var correctLogin = "";
  bool request = false;
  final username = TextEditingController();
  final usermail = TextEditingController();
  final userpass = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        setState(() {
          verified = true;
        });
      } else {
        setState(() {
          verified = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    userpass.dispose();
    super.dispose();
  }

  // void _printLatestValue() {
  //   print('Second text field: ${myController.text}');
  // }

  bool checkStatus(userStates? state) {
    if (state == userStates.registerNow) {
      setState(() {
        retry = false;
        correctLogin = "You are not a registered user!";
      });
    } else if (state == userStates.wrongPassword) {
      setState(() {
        correctLogin = "You entered wrong password for this account";
      });
    } else if (state == userStates.successful) {
      setState(() {
        allowlogin = true;
      });
    }
    return allowlogin;
  }

  @override
  Widget build(BuildContext context) {
    return retry
        ? Consumer<UserState>(
            builder: (context, value, child) => SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: verified
                              ? Text("Login ",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))
                              : FloatingActionButton.extended(
                                  onPressed: () {
                                    print("verify");
                                    FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification()
                                        .then((value) {
                                      print("email verification sent");
                                    });
                                  },
                                  label: Text("Verify mail"))),
                    ),
                    InputFields("Enter Username", username, Icons.input,
                        TextInputType.text),
                    SizedBox(
                      height: 5,
                    ),
                    InputFields("Enter Email", usermail, Icons.email,
                        TextInputType.emailAddress),
                    SizedBox(
                      height: 5,
                    ),
                    InputFields("Enter Password", userpass, Icons.password,
                        TextInputType.visiblePassword),
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RawMaterialButton(
                              shape: StadiumBorder(),
                              fillColor: Colors.white,
                              //padding:  EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.

                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    request = true;
                                  });
                                  print(value.signinstate);
                                  value
                                      .signInWithMPass(
                                          usermail.text, userpass.text)
                                      .then((registedstate) {
                                    checkStatus(registedstate);
                                  }).then((value) {
                                    if (allowlogin) {
                                      setState(() {
                                        request = false;
                                      });
                                      FirebaseAuth.instance.currentUser!
                                              .emailVerified
                                          ? Navigator.pushNamed(
                                              context, '/home')
                                          : setState(() {
                                              verified = false;
                                            });
                                    }
                                  });
                                }
                              },

                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 3, bottom: 3, right: 15),
                                  child: Text('Login',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                          ),
                          request == true
                              ? CircularProgressIndicator()
                              : Text(""),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text("No account?   ",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w100)),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                allowlogin = false;
                                retry = false;
                              });
                            },
                            child: Text(' Sign Up ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black))),
                        TextButton(
                            child: Text(
                              "go home",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            }),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(1),
                      child: Text(
                        correctLogin,
                        style: TextStyle(
                            backgroundColor: Colors.black,
                            color: Colors.red,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    FirebaseAuth.instance.currentUser == null
                        ? Text("")
                        : Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                              child: Text("Resume"),
                              style: ButtonStyle(),
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        : SignupForm();
  }
}
