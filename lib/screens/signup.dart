import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:provider/provider.dart';

//MyForm
class SignupForm extends StatefulWidget {
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool tonext = false;
  bool ok = false;
  String errors = "";
  int currentindex = 0;
  TextEditingController email = TextEditingController();
  TextEditingController passwd = TextEditingController();
  TextEditingController passwd1 = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController house = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController regioncontroller = TextEditingController();
  PageController pgecontroller = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: currentindex,
        onStepContinue: () {
          setState(() {
            tonext ? currentindex += 1 : currentindex += 0;
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
              "Email & password",
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
                          fillColor: Colors.white,
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
                                    errors = "First step complete!";
                                    tonext = true;
                                    value.registedmail = email.text;
                                  });
                                } else {
                                  print(value);
                                  setState(() {
                                    errors = rvalue.toString();
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
                      Center(child: Text(errors))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Step(
            title: Text(
              "Personal info",
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            content: Consumer<UserState>(
              builder: (context, value, child) => Form(
                key: _formKey2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("! Please do well to verify your email after registration !",style:TextStyle(color:Colors.red ) ,),
                        ),
                      ),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(" Address ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Region..."),
                              MenuButton(regioncontroller: regioncontroller),
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
                                      house.text,
                                      regioncontroller.text)
                                  .then((rvalue) {
                                if (value.isadded == userAdded.successful) {
                                  // FirebaseAuth
                                  //         .instance.currentUser!.emailVerified
                                  //     ?
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ButtomNav()),
                                  );
                                 
                                      FirebaseAuth.instance.currentUser!
                                          .sendEmailVerification();
                                 
                                 
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
