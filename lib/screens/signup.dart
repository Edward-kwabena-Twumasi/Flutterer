import 'package:flutter/material.dart';
import 'package:myapp/components/text_inputwidgets.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:provider/provider.dart';

//MyForm
class SignupForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  int page = 0;
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Register with email and password"),
                  Text("1/2"),
                  InputFields("Enter email", controller1, Icon(Icons.email)),
                  SizedBox(
                    height: 4,
                  ),
                  InputFields(
                      "Set password", controller3, Icon(Icons.password)),
                  SizedBox(
                    height: 4,
                  ),
                  InputFields(
                      "Confirm password", controller4, Icon(Icons.password)),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          // Process data.
                          // Navigator.pop(context);
                          value
                              .registerwithMPass(
                                  controller1.text, controller2.text)
                              .then((value) {
                            if (value == userStates.successful) {
                              Navigator.pushNamed(context, '/home');
                            } else
                              print(value);
                          });
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("This section takes details to help us serve you better"),
              Text("2/2"),
              SizedBox(height: 5),
              Consumer<UserState>(
                builder: (context, value, child) => Form(
                  key: _formKey2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InputFields(
                          "Enter Full Name", controller, Icon(Icons.input)),
                      SizedBox(
                        height: 10,
                      ),
                      InputFields(
                          "Enter phone ", controller2, Icon(Icons.phone)),
                      SizedBox(
                        height: 3,
                      ),
                      InputFields("Select Location", controller5,
                          Icon(Icons.location_city)),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey2.currentState.validate()) {
                              // Proceed with registration process.

                              value.addUser(controller.text, controller2.text,
                                  controller5.text);
                            }
                          },
                          child: Text('Complete signup'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
