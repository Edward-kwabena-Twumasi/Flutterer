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
  bool tonext = false;
  String errors = "";
  int currentindex = 0;
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
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: currentindex,
        onStepContinue: () {
          setState(() {
            currentindex < 1 ? currentindex += 1 : null;
            //tonext ? currentindex += 1 : null;
          });
        },
        onStepTapped: (int step) {
          setState(() {
            currentindex = step;
          });
        },
        physics: ScrollPhysics(),
        steps: [
          Step(
            title: Text(
              "Email and password",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Verdana"),
            ),
            content: Consumer<UserState>(
              builder: (context, value, child) => Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      InputFields("Registeration Email", email, Icons.email,
                          TextInputType.emailAddress),
                      SizedBox(
                        height: 4,
                      ),
                      InputFields("Password", passwd, Icons.password,
                          TextInputType.text),
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
                                  setState(() {});
                                  tonext = true;
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
                          child: Text(' Submit '),
                        ),
                      ),
                      // OutlinedButton(
                      //   onPressed: () {
                      //     if (pgecontroller.hasClients) {
                      //       pgecontroller.animateToPage(1,
                      //           duration: const Duration(milliseconds: 400),
                      //           curve: Curves.easeInOut);
                      //     }
                      //   },
                      //   child: Text(tonext),
                      // ),
                      Center(child: Text(errors))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Step(
            title: Text("Personal information"),
            content: Consumer<UserState>(
              builder: (context, value, child) => Form(
                key: _formKey2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 7,
                      ),
                      InputFields(
                          "Full Name", name, Icons.input, TextInputType.name),
                      SizedBox(
                        height: 3,
                      ),
                      InputFields(
                          "Phone ", phone, Icons.phone, TextInputType.phone),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(" Address ",
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
                              InputFields("City... ", city, Icons.location_city,
                                  TextInputType.streetAddress),
                              SizedBox(
                                height: 3,
                              ),
                              InputFields(
                                  "House Address... ",
                                  house,
                                  Icons.home_filled,
                                  TextInputType.streetAddress),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey2.currentState!.validate()) {
                              // Proceed with registration process.

                              value
                                  .addUser(
                                      name.text,
                                      value.registedmail.toString(),
                                      phone.text,
                                      city.text,
                                      house.text)
                                  .then((rvalue) {
                                if (value.isadded == userAdded.successful) {
                                  Navigator.pushNamed(context, '/home');
                                }
                              });
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
          ),
        ],
      ),
    );
  }
}
