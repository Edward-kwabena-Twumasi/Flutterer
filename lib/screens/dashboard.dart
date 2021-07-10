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

TextEditingController? controller1, controller2, controller3;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => CompanyState(),
      builder: (context, _) =>
          DashApp(controller1!, controller2!, controller3!)));
}

class DashApp extends StatelessWidget {
  final TextEditingController namecontroller, idcontroller;
  final TextEditingController regioncontroller;
  const DashApp(this.idcontroller, this.namecontroller, this.regioncontroller);
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            floatingActionButton: Stack(
              children: [
                Positioned(
                  left: 5,
                  bottom: 5,
                  child: FloatingActionButton.extended(
                      heroTag: "addregion",
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: Column(children: [
                                  menuButton(regioncontroller: regioncontroller)
                                ]),
                              );
                            });
                      },
                      label: Text("Add region")),
                ),
                Positioned(
                  left: 5,
                  bottom: 65,
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
                                    menuButton(
                                        regioncontroller: regioncontroller),
                                    SearchLocs("City"),
                                    InputFields("id", idcontroller, Icons.input,
                                        TextInputType.text),
                                    TextFormField()
                                  ]),
                                ),
                              );
                            });
                      },
                      label: Text("Add Station")),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
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
                                    InputFields("name", namecontroller,
                                        Icons.input, TextInputType.text),
                                    menuButton(
                                        regioncontroller: regioncontroller),
                                    SearchLocs("City"),
                                    InputFields("id", idcontroller, Icons.input,
                                        TextInputType.text),
                                    TextFormField()
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
                          .map(
                            (doc) => ExpansionTile(
                                title: Text(doc['region']),
                                subtitle: Text("Stations in this region"),
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: doc['stations'].length,
                                      itemBuilder: (context, index) {
                                        return Text("Hello");
                                        //Text(doc['stations'][index]
                                        //     .city()
                                        //     .toString());
                                      })
                                ]),
                          )
                          .toList());
                })));
  }
}
