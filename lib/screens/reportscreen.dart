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

  final repname = TextEditingController();
  final repmail = TextEditingController();
  final tripid = TextEditingController();
  final recipient = TextEditingController();
  final pgcontrol = PageController();
  var options = ["Health", "Lost Item", "General"];
  String? initialval;

  @override
  void initState() {
    super.initState();
    initialval = options[0];
  }

  void changed(String? value) {
    setState(() {
      initialval = value;
    });
    if (value == options[0]) {
      pgcontrol.animateToPage(0,
          duration: Duration(milliseconds: 50), curve: Curves.easeIn);
    }
    if (value == options[1]) {
      pgcontrol.animateToPage(1,
          duration: Duration(milliseconds: 50), curve: Curves.easeIn);
    }
    if (value == options[2]) {
      pgcontrol.animateToPage(2,
          duration: Duration(milliseconds: 50), curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Report",
        ),
      ),
      body: Consumer<UserState>(
        builder: (context, value, child) => Scaffold(
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Make a report",
                          style: TextStyle(fontFamily: "serif", fontSize: 30))),
                  OptionButton(
                      options: options,
                      onchange: changed,
                      dropdownValue: initialval!),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InputFields("trip id", tripid, Icons.password,
                      TextInputType.visiblePassword),
                  InputFields("receipient", recipient, Icons.password,
                      TextInputType.visiblePassword),
                  Container(
                    height: 200,
                    child: PageView(
                      controller: pgcontrol,
                      children: [
                        ListView(
                          shrinkWrap: true,
                          children: [
                            InputFields("Description", tripid, Icons.password,
                                TextInputType.multiline),
                            InputFields("Other", recipient, Icons.password,
                                TextInputType.text),
                          ],
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            InputFields("Item image", tripid, Icons.password,
                                TextInputType.number),
                            InputFields("Description", recipient,
                                Icons.password, TextInputType.multiline),
                          ],
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            InputFields("Describe condition", tripid,
                                Icons.password, TextInputType.multiline),
                            InputFields("How severe?", recipient,
                                Icons.password, TextInputType.text),
                          ],
                        ),
                      ],
                    ),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
