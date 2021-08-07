import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Notify());
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

class Notify extends StatefulWidget {
  const Notify({Key? key}) : super(key: key);

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> note;
//user preferences to show them notice
  Future<bool> shownote() async {
    final SharedPreferences prefs = await _prefs;
    final bool notepref = (prefs.getBool('notepref') ?? false);

    return notepref;
  }

  @override
  void initState() {
    super.initState();
  }

  void timer() {}

  var height = 150.0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              height: height,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text("Note this"),
                ),
                Divider(color: Colors.lightBlue),
                Center(
                    child: Text(
                        "Welcome to travel mates.Please be sure to check out our privacy policy,special offers and check out notifications",
                        style: TextStyle(color: Colors.green))),
                Divider(color: Colors.lightBlue),
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                height = 0;
                              });
                            },
                            child: Text("Ok Got IT ")))
                  ],
                )
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: ListTile(
                leading: Icon(Icons.watch_later),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text("Set timers"),
                subtitle: Column(
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("SET TIMER")),
                    ListTile(
                      title: Text("Timer"),
                    )
                  ],
                )),
          ),
        )
      ]),
    ));
  }
}
