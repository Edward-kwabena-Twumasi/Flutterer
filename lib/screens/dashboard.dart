import 'dart:html';

import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/agentStateProvider.dart';
import 'package:myapp/screens/agentlogin.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:myapp/screens/signup.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => CompanyState(), builder: (context, _) => DashApp()));
}

class DashApp extends StatefulWidget {
  DashAppState createState() => DashAppState();
}

class DashAppState extends State<DashApp> {
  final namecontroller = TextEditingController(),
      idcontroller = TextEditingController(),
      regioncontroller = TextEditingController();

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            floatingActionButton: Stack(
              children: [
                Positioned(
                  right: 40,
                  bottom: 2,
                  child: FloatingActionButton.extended(
                      heroTag: "addregion",
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: Container(
                                    child: GridView.count(
                                  crossAxisCount: 3,
                                  children: [
                                    niceChips(Icons.select_all, "ASHANTI"),
                                    niceChips(Icons.select_all, "OTI"),
                                    niceChips(Icons.select_all, "AHAFO"),
                                    niceChips(Icons.select_all, "CENTRAL"),
                                    niceChips(Icons.select_all, "EASTERN"),
                                    niceChips(Icons.select_all, "WESTERN"),
                                    niceChips(
                                        Icons.select_all, "GREATER ACCRA"),
                                    niceChips(Icons.select_all, "ASHANTI"),
                                    niceChips(Icons.select_all, "ASHANTI"),
                                    niceChips(Icons.select_all, "ASHANTI"),
                                    niceChips(Icons.select_all, "ASHANTI"),
                                    niceChips(Icons.select_all, "ASHANTI"),
                                  ],
                                )),
                              );
                            });
                      },
                      label: Text("Add region")),
                ),
                Positioned(
                  right: 20,
                  bottom: 30,
                  child: FloatingActionButton.extended(
                      heroTag: "addstation",
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: Form(
                                  child: Column(children: [
                                    InputFields("name", namecontroller,
                                        Icons.input, TextInputType.text),
                                    Text("Region"),
                                    menuButton(
                                        regioncontroller: regioncontroller),
                                    Text("city"),
                                    SearchLocs("City"),
                                    InputFields("id", idcontroller, Icons.input,
                                        TextInputType.text),
                                    InputFields("Destinations", idcontroller,
                                        Icons.input, TextInputType.text),
                                  ]),
                                ),
                              );
                            });
                      },
                      label: Text("Add Station")),
                ),
                Positioned(
                  right: 5,
                  bottom: 60,
                  child: FloatingActionButton.extended(
                      heroTag: "schedule",
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: Form(
                                  child: Column(children: [
                                    SearchLocs("From"),
                                    SearchLocs("To"),
                                    InputFields("Trip id", idcontroller,
                                        Icons.input, TextInputType.text),
                                    InputFields("Bus id", idcontroller,
                                        Icons.input, TextInputType.text),
                                    InputFields("distance/km", idcontroller,
                                        Icons.input, TextInputType.number),
                                    InputFields("Seats", idcontroller,
                                        Icons.input, TextInputType.number),
                                    InputFields("duration", idcontroller,
                                        Icons.input, TextInputType.datetime),
                                    InputFields("Driver Contact", idcontroller,
                                        Icons.input, TextInputType.phone),
                                  ]),
                                ),
                              );
                            });
                      },
                      label: Text("Schedule Trip")),
                )
              ],
            ),
            body: Dashboard()));
  }
}

class Dashboard extends StatefulWidget {
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('companies')
                    .doc('Bus')
                    .collection('Registered Companies')
                    .where('id',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData &&
                      !(snapshot.connectionState == ConnectionState.done)) {
                    return Center(
                        child: Card(
                            elevation: 8,
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Loading ...")
                              ],
                            )));
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                  }

                  return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs
                          .map((doc) => ListView.builder(
                              shrinkWrap: true,
                              itemCount: doc['regions'].length,
                              itemBuilder: (context, index) {
                                return Text("Hello");
                                //Text(doc['stations'][index]
                                //     .city()
                                //     .toString());
                              }))
                          .toList());
                })));
  }
}

Widget stations(int howmany) {
  List<TextEditingController> controls = [];
  for (var i = 0; i < howmany; i++) {
    controls.add("stcontrols" + i.toString() as TextEditingController);
  }
  return Center(
    child: ListView.builder(
        itemCount: howmany,
        itemBuilder: (BuildContext, index) {
          return Form(
              child: Column(
            children: [menuButton(regioncontroller: controls[index])],
          ));
        }),
  );
}
