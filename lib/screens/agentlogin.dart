import 'dart:html';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/agentStateProvider.dart';
import 'package:myapp/screens/dashboard.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:myapp/screens/companysignup.dart';

//irebase

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyCompApp());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.

//firebase

// void main() {
//   runApp(MyApp());
// }

class MyCompApp extends StatelessWidget {
  var style = TextStyle(
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
        "/companyinfo": (context) => DashApp()
      },
      title: 'Login as Agent',
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Travellers Mobile App'),
          centerTitle: true,
        ),
        body: Center(
          child: AgentForm(),
        ),
      ),
    );
  }
}

//MyForm
class AgentForm extends StatefulWidget {
  AgentFormState createState() => AgentFormState();
}

class AgentFormState extends State<AgentForm> {
  final _formKey = GlobalKey<FormState>();
  bool allowlogin = false;
  bool retry = true;
  var correctLogin = "";

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

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
    name.dispose();
    super.dispose();
  }

  // void _printLatestValue() {
  //   print('Second text field: ${myController.text}');
  // }

  void checkStatus(companyStates? state) {
    if (state == companyStates.registerNow) {
      setState(() {
        // retry = false;
        correctLogin = "You are not a registered user!";
      });
    } else if (state == companyStates.wrongPassword) {
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
        ? Consumer<CompanyState>(
            builder: (context, value, child) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              elevation: 8,
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text("Login here"),
                        SizedBox(height: 20),
                        InputFields("Company Email", email, Icons.email,
                            TextInputType.emailAddress),
                        SizedBox(
                          height: 7,
                        ),
                        InputFields("Enter Password", password, Icons.password,
                            TextInputType.text),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RawMaterialButton(
                              shape: StadiumBorder(),
                              fillColor: Colors.white,
                              //padding:  EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.

                                if (_formKey.currentState!.validate()) {
                                  // if (checkStatus(myController1.text)) {
                                  //   Navigator.push(context, MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return TabBarDemo();
                                  //     },
                                  //   ));
                                  // }
                                  value
                                      .signInWithMPass(
                                          email.text, password.text)
                                      .then((registedstate) {
                                    if (registedstate ==
                                        companyStates.successful) {
                                      Navigator.pushNamed(
                                          context, '/companyinfo');
                                    } else if (registedstate ==
                                        companyStates.registerNow) {
                                      setState(() {
                                        correctLogin = "You are not registered";
                                      });
                                    } else if (registedstate ==
                                        companyStates.wrongPassword) {
                                      setState(() {
                                        correctLogin =
                                            "You entered wrong password";
                                      });
                                    }
                                  });
                                }
                              },

                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Login ',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25))),
                            ),
                          ),
                        ),
                        Text(correctLogin),
                        Row(
                          children: [
                            Text("I am not registered!"),
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
                        //dsiplay any login errors here
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
                            child: Text("View dashboard"),
                            onPressed: () {
                              Navigator.pushNamed(context, '/companyinfo');
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : CompanySignupForm();
  }
}
