import 'dart:html';

import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:provider/provider.dart';

//MyForm
class SignupForm extends StatefulWidget {
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String tonext = "";
  String errors = "";
  int page = 0;
  TextEditingController email = TextEditingController();
  TextEditingController passwd = TextEditingController();
  TextEditingController passwd1 = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController house = TextEditingController();
  TextEditingController city = TextEditingController();
  PageController pgecontroller = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: PageView(
        controller: pgecontroller,
        children: [
          Consumer<UserState>(
            builder: (context, value, child) => Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Verdana"),
                    ),
                    InputFields("Registeration Email", email, Icons.email,
                        TextInputType.emailAddress),
                    SizedBox(
                      height: 4,
                    ),
                    InputFields(
                        "Password", passwd, Icons.password, TextInputType.text),
                    SizedBox(
                      height: 4,
                    ),
                    InputFields("Password confirmation", passwd1,
                        Icons.password, TextInputType.text),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RawMaterialButton(
                        fillColor: Colors.green,
                        shape: StadiumBorder(),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate() &&
                              passwd.text == passwd1.text) {
                            // Process data.
                            // Navigator.pop(context);
                            value
                                .registerwithMPass(email.text, passwd.text)
                                .then((rvalue) {
                              if (rvalue == userStates.successful) {
                                setState(() {
                                  tonext = "Fill personal info";
                                });

                                value.registedmail = email.text;
                                //Navigator.pushNamed(context, '/home');
                              } else {
                                print(value);
                                setState(() {
                                  errors = value.toString();
                                });
                              }
                            });
                          } else {
                            print("Two passwords must match");
                            setState(() {
                              errors = "Two passwords must match";
                            });
                          }
                        },
                        child: Text('Register'),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (pgecontroller.hasClients) {
                          pgecontroller.animateToPage(1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        }
                      },
                      child: Text(tonext),
                    ),
                    Text(errors)
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Consumer<UserState>(
                  builder: (context, value, child) => Form(
                    key: _formKey2,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Please fill your personal Info",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(
                            height: 7,
                          ),
                          InputFields("Full Name", name, Icons.input,
                              TextInputType.name),
                          SizedBox(
                            height: 3,
                          ),
                          InputFields("Phone ", phone, Icons.phone,
                              TextInputType.phone),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text("Your Location Address",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Region..."),
                                  menuButton(),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  InputFields("City... ", city, Icons.phone,
                                      TextInputType.streetAddress),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  InputFields("House Address... ", house,
                                      Icons.phone, TextInputType.streetAddress),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey2.currentState!.validate()) {
                                  // Proceed with registration process.

                                  value.addUser(
                                      name.text,
                                      value.registedmail.toString(),
                                      phone.text,
                                      city.text,
                                      house.text);
                                }
                              },
                              child: Text('Complete signup'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
