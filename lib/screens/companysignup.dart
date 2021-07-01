import 'dart:html';

import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:provider/provider.dart';

//MyForm
class CompanySignupForm extends StatefulWidget {
  @override
  CompanySignupFormState createState() => CompanySignupFormState();
}

class CompanySignupFormState extends State<CompanySignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String companytype = "";
  String errormesg = "";
  int currentstep = 0;
  bool tonext = false;
  TextEditingController email = TextEditingController();
  TextEditingController passwd = TextEditingController();
  TextEditingController passwd1 = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController aptmnt = TextEditingController();
  TextEditingController city = TextEditingController();
  PageController pgecontroller = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: currentstep,
        onStepContinue: () {
          setState(() {
            currentstep < 1 ? currentstep++ : null;
            // tonext == true ? currentstep++ : null;
          });
        },
        onStepTapped: (int step) {
          currentstep = step;
        },
        steps: [
          Step(
            title: Text("Email and password"),
            content: Consumer<UserState>(
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
                      InputFields("Company Email", email, Icons.email,
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
                                  //Navigator.pushNamed(context, '/home');
                                  setState(() {
                                    tonext = true;
                                    errormesg = "Register successful";
                                  });
                                } else
                                  print(rvalue);
                              });
                            } else
                              print("Two passwords must match");
                          },
                          child: Text('Register'),
                        ),
                      ),
                      Text(errormesg),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Step(
            title: Text("Information about company"),
            content: SingleChildScrollView(
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
                            Text("Please fill company info below",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 7,
                            ),
                            Text("Company type..."),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InputChip(
                                  labelPadding: EdgeInsets.all(5),
                                  selectedColor: Colors.green,
                                  onPressed: () {
                                    setState(() {
                                      companytype = "Bus";
                                      print(companytype);
                                    });
                                  },
                                  label: Text("Bus"),
                                  avatar: CircleAvatar(
                                    child: Text("B"),
                                  ),
                                ),
                                InputChip(
                                    labelPadding: EdgeInsets.all(5),
                                    selectedColor: Colors.green,
                                    onPressed: () {
                                      setState(() {
                                        companytype = "Flight";
                                      });
                                    },
                                    label: Text("Flight"),
                                    avatar: CircleAvatar(
                                      child: Text("F"),
                                    )),
                                InputChip(
                                    labelPadding: EdgeInsets.all(5),
                                    selectedColor: Colors.green,
                                    onPressed: () {
                                      setState(() {
                                        companytype = "Train";
                                      });
                                    },
                                    label: Text("Train"),
                                    avatar: CircleAvatar(
                                      child: Text("T"),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            InputFields("Registered Name", name, Icons.input,
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
                                    Text("HQ Location Address",
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
                                    InputFields(
                                        "Apt Address... ",
                                        aptmnt,
                                        Icons.phone,
                                        TextInputType.streetAddress),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate will return true if the form is valid, or false if
                                  // the form is invalid.
                                  if (_formKey2.currentState!.validate()) {
                                    // Proceed with registration process.

                                    value.addUser(name.text, email.text,
                                        phone.text, city.text, aptmnt.text);
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
          ),
        ],
      ),
    );
  }
}
