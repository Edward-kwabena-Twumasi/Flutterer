import 'package:flutter/material.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Reporter());
}

class Reports extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Reporter(),
    );
  }
}

class Reporter extends StatefulWidget {
  ReporterState createState() => ReporterState();
}

class ReporterState extends State<Reporter> {
  final _formKey = GlobalKey<FormState>();
  bool allowlogin = false;
  bool retry = true;
  var correctLogin = "";

  final repname = TextEditingController();
  final repmail = TextEditingController();
  final tripid = TextEditingController();
  final recipient = TextEditingController();
  final pgcontrol = PageController();

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
    return Consumer<UserState>(
      builder: (context, value, child) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Login  ", style: TextStyle(fontFamily: "serif")),
              InputFields(
                  "Enter Username", repname, Icons.input, TextInputType.text),
              SizedBox(
                height: 5,
              ),
              InputFields("Enter Email", repmail, Icons.email,
                  TextInputType.emailAddress),
              SizedBox(
                height: 5,
              ),
              InputFields("trip id", tripid, Icons.password,
                  TextInputType.visiblePassword),
              InputFields("receipient", recipient, Icons.password,
                  TextInputType.visiblePassword),
              PageView(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      InputFields("Description", tripid, Icons.password,
                          TextInputType.number),
                      InputFields("Other", recipient, Icons.password,
                          TextInputType.text),
                    ],
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      InputFields("Item image", tripid, Icons.password,
                          TextInputType.number),
                      InputFields("Description", recipient, Icons.password,
                          TextInputType.text),
                    ],
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      InputFields("Describe condition", tripid, Icons.password,
                          TextInputType.number),
                      InputFields("How severe?", recipient, Icons.password,
                          TextInputType.text),
                    ],
                  ),
                ],
              ),
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

                      if (_formKey.currentState!.validate()) {}
                    },

                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('Submit',
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.normal,
                                fontSize: 25,
                                fontStyle: FontStyle.italic))),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Dont have an account? ",
                        style: TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.w100)),
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
                                color: Colors.white))),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child: Text(
                  correctLogin,
                  style: TextStyle(
                      backgroundColor: Colors.white,
                      color: Colors.red,
                      fontWeight: FontWeight.w300),
                ),
              ),
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
        ),
      ),
    );
  }
}
