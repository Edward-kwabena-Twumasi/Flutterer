import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:myapp/components/notifications.dart';
 
void main() => runApp(const Admin());

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const title = 'Admin';
    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Admin panel"),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
          body: AdminPage()),
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isverified = false;
  String pattern = "12859610";
  String key = "9IAMTHEADMIN81";
  String match = "";
  String msg = "";
  int track = 0;
  void handlelogin() {
    if (track == 7) {
      print(match);
      if (match == key) {
        setState(() {
          isverified = true;
        });
      } else {
        setState(() {
          msg = "Wrong admin password";
          match = "";
          track = 0;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isverified == false
        ? Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                    child: ListView(shrinkWrap: true, children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Login with pattern"),
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.5,
                    children: [
                      FloatingActionButton(
                          heroTag: "b1",
                          onPressed: () {
                            setState(() {
                              match += "9";
                              track += 1;
                              handlelogin();
                            });
                          }),
                      FloatingActionButton(
                          heroTag: "b2",
                          onPressed: () {
                            setState(() {
                              match += "I";
                              track += 1;
                              handlelogin();
                            });
                          }),
                      FloatingActionButton(heroTag: "b3", onPressed: () {}),
                      FloatingActionButton(heroTag: "b4", onPressed: () {}),
                      FloatingActionButton(
                          heroTag: "b5",
                          onPressed: () {
                            setState(() {
                              match += "THE";
                              track += 1;
                              handlelogin();
                            });
                          }),
                      FloatingActionButton(heroTag: "b6", onPressed: () {}),
                      FloatingActionButton(
                          heroTag: "b7",
                          onPressed: () {
                            setState(() {
                              match += "8";
                              track += 1;
                              handlelogin();
                            });
                          }),
                      FloatingActionButton(
                          heroTag: "b8",
                          onPressed: () {
                            setState(() {
                              match += "AM";
                              track += 1;
                              handlelogin();
                            });
                          }),
                      FloatingActionButton(
                          heroTag: "b9",
                          onPressed: () {
                            setState(() {
                              match += "ADMIN";
                              track += 1;
                              handlelogin();
                            });
                          }),
                      FloatingActionButton(
                          heroTag: "b10",
                          onPressed: () {
                            setState(() {
                              match += "1";
                              track += 1;
                              handlelogin();
                            });
                          }),
                    ],
                  ),
                  Center(
                    child: Text(msg),
                  )
                ])),
              ),
            ),
          )
        : PageView(children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                        heroTag: "verify",
                        onPressed: () {},
                        label: Text("Verify accounts")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                        heroTag: "notify",
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>Notifies()),
                      );
     
                        },
                        label: Text("Notifications")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                        heroTag: "deact",
                        onPressed: () {},
                        label: Text("Deactivate")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                        heroTag: "act",
                        onPressed: () {},
                        label: Text("Activate")),
                  ),
                ],
              ),
            ),
            ShedulesInfo(companytype: "Bus"),
            ShedulesInfo(companytype: "Flight"),
            ShedulesInfo(companytype: "Train")
          ]);
  }
}

class ShedulesInfo extends StatefulWidget {
  final String companytype;

  const ShedulesInfo({Key? key, required this.companytype}) : super(key: key);
  @override
  _ShedulesInfoState createState() => _ShedulesInfoState();
}

class _ShedulesInfoState extends State<ShedulesInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
                title: Text(
                    "Registered companies for " + widget.companytype + "s",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('companies')
                  .doc(widget.companytype)
                  .collection('Registered Companies')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading companies");
                }

                return new ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((data) {
                    return new ListTile(
                      title: new Text(data.id),
                      subtitle: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title:
                                    Text("Name : " + data['registered_name']),
                                subtitle: Text("Status : Not Verified"),
                                trailing: TextButton(
                                    onPressed: () {},
                                    child: Text("Authorize"))),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
