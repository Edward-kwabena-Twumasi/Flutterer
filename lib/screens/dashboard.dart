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
      create: (context) => CompanyState(),
      builder: (context, _) => DashApp(companytype: "Bus")));
}

TripClass onetrip =
    TripClass("Obuasi", "Obuasi", "10:00", "20 10 2021", "normal");
String companyname = "";

class DashApp extends StatefulWidget {
  String companytype;
  DashApp({required this.companytype});
  DashAppState createState() => DashAppState();
}

class DashAppState extends State<DashApp> {
  Widget interroutes(int howmany) {
    List<TextEditingController> controls = [];
    List<bool> valstate = [];
    for (var i = 0; i < howmany; i++) {
      controls
          .add(new TextEditingController(text: "enter route " + i.toString()));
      valstate.add(true);
    }
    bool value = false;
    return Center(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: howmany,
          itemBuilder: (BuildContext, index) {
            return Form(
                child: Column(
              children: [
                TextFormField(
                  controller: controls[index],
                ),
                SwitchListTile(
                    title: Text("PIck up point"),
                    // selected: valstate[index],
                    value: valstate[index],
                    onChanged: (bool val) {
                      print(val);
                      setState(() {
                        valstate[index] = val;
                        valstate;
                      });
                    }),
                SwitchListTile(
                    title: Text("Stop point"),
                    // selected: valstate[index],
                    value: valstate[index],
                    onChanged: (bool val) {
                      print(val);
                      setState(() {
                        valstate[index] = val;
                        valstate;
                      });
                    }),
                Divider(height: 4, indent: 3, color: Colors.lightBlue)
              ],
            ));
          }),
    );
  }

  List<String> places = [];

  @override
  void initState() {
    super.initState();

    List<String> getplaces = [
      "Kumasi",
      "Obuasi",
      "Accra",
      "Kasoa",
      "Mankessim",
      "Wa"
    ];
    places = getplaces;
  }

  final namecontroller = TextEditingController(),
      idcontroller = TextEditingController(),
      regioncontroller = TextEditingController(),
      citycontroller = TextEditingController(),
      destcontroller = TextEditingController(),
      routecontroller = TextEditingController();
  final form1 = GlobalKey<FormState>();
  final form2 = GlobalKey<FormState>();
  var selectregions = [];
  String showregions = '';

  void pressed() {
    selectregions.add("REGION");
    return null;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            drawer: Drawer(
              semanticLabel: "drawer",
              child: Column(
                children: [
                  IconButton(
                      tooltip: "register driver",
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.95,
                                child: SingleChildScrollView(
                                    child: Form(
                                  child: Column(children: [
                                    Text("Provide driver details"),
                                    InputFields("name", namecontroller,
                                        Icons.person_add, TextInputType.name),
                                    InputFields("phone", namecontroller,
                                        Icons.phone, TextInputType.number),
                                    InputFields("photo", namecontroller,
                                        Icons.photo, TextInputType.url),
                                    FloatingActionButton.extended(
                                        label: Text("Add driver"),
                                        onPressed: () {},
                                        icon: Icon(Icons.add)),
                                  ]),
                                )),
                              );
                            });
                      },
                      icon: Icon(Icons.app_registration)),
                  IconButton(
                      tooltip: "register bus",
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                  heightFactor: 0.95,
                                  child: SingleChildScrollView(
                                    child: Form(
                                        child: Column(children: [
                                      Text("Provide driver details"),
                                      InputFields("name", namecontroller,
                                          Icons.person_add, TextInputType.name),
                                      InputFields("phone", namecontroller,
                                          Icons.phone, TextInputType.number),
                                      InputFields("photo", namecontroller,
                                          Icons.photo, TextInputType.url),
                                      FloatingActionButton.extended(
                                          label: Text("Add bus"),
                                          onPressed: () {},
                                          icon: Icon(Icons.add)),
                                    ])),
                                  ));
                            });
                      },
                      icon: Icon(Icons.app_registration)),
                ],
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              title: Text(companyname),
              actions: [],
            ),
            floatingActionButton: Stack(
              children: [
                Positioned(
                  right: 25,
                  bottom: 5,
                  child: FloatingActionButton.extended(
                      heroTag: "addregion",
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.95,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    menuButton(
                                        regioncontroller: regioncontroller),
                                    Text(showregions),
                                    FloatingActionButton.extended(
                                        onPressed: () {
                                          selectregions
                                              .add(regioncontroller.text);
                                          showregions = '';
                                          for (var i in selectregions) {
                                            showregions += i.toString() + " ,";
                                          }
                                          setState(() {
                                            showregions;
                                          });

                                          print(showregions);
                                        },
                                        label: Icon(Icons.add)),
                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('companies')
                                              .doc(widget.companytype)
                                              .collection(
                                                  'Registered Companies')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "regions": FieldValue.arrayUnion(
                                                selectregions)
                                          }).then((value) => print("Hello"));
                                        },
                                        child: Text("Submit"))
                                  ],
                                )),
                              );
                            });
                      },
                      label: Text("Add region")),
                ),
                Positioned(
                  right: 15,
                  bottom: 55,
                  child: FloatingActionButton.extended(
                      heroTag: "addstation",
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.95,
                                child: Form(
                                  key: form1,
                                  child: SingleChildScrollView(
                                    child: Column(children: [
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("Station Details",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      InputFields("name", namecontroller,
                                          Icons.input, TextInputType.text),
                                      Text("Station Location"),
                                      Text("Region"),
                                      InputFields("Region", regioncontroller,
                                          Icons.input, TextInputType.text),
                                      InputFields("City", citycontroller,
                                          Icons.input, TextInputType.text),
                                      InputFields("id", idcontroller,
                                          Icons.input, TextInputType.text),
                                      InputFields(
                                          "List all destinations",
                                          destcontroller,
                                          Icons.input,
                                          TextInputType.text),
                                      FloatingActionButton.extended(
                                          onPressed: () {
                                            if (form1.currentState!
                                                .validate()) {
                                              FirebaseFirestore.instance
                                                  .collection('companies')
                                                  .doc(widget.companytype)
                                                  .collection(
                                                      'Registered Companies')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .update({
                                                "stations":
                                                    FieldValue.arrayUnion([
                                                  {
                                                    "name": namecontroller.text,
                                                    "region":
                                                        regioncontroller.text,
                                                    "city": citycontroller.text,
                                                    "id": idcontroller.text,
                                                    "destinations":
                                                        destcontroller.text,
                                                  }
                                                ])
                                              }).then((value) =>
                                                      print("Hello"));
                                              print({
                                                namecontroller.text,
                                                regioncontroller.text,
                                                idcontroller.text
                                              });
                                            }
                                          },
                                          label: Text("Submit"))
                                    ]),
                                  ),
                                ),
                              );
                            });
                      },
                      label: Text("Add Station")),
                ),
                Positioned(
                  right: 5,
                  bottom: 105,
                  child: FloatingActionButton.extended(
                      heroTag: "schedule",
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.95,
                                child: Form(
                                  key: form2,
                                  child: SingleChildScrollView(
                                    child: Column(children: [
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("Trip Details",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      SearchLocs(
                                        direction: 'from',
                                        locations: places,
                                      ),
                                      SearchLocs(
                                        direction: 'to',
                                        locations: places,
                                      ),
                                      interroutes(4),
                                      InputFields("Bus id", idcontroller,
                                          Icons.input, TextInputType.text),
                                      Text("SELECT IMAGE"),
                                      InputFields("Seats", idcontroller,
                                          Icons.input, TextInputType.number),
                                      InputFields("distance/km", idcontroller,
                                          Icons.input, TextInputType.number),
                                      InputFields("duration", idcontroller,
                                          Icons.input, TextInputType.datetime),
                                      InputFields(
                                          "Driver Contact",
                                          idcontroller,
                                          Icons.input,
                                          TextInputType.phone),
                                      Text("SELECT IMAGE"),
                                      FloatingActionButton.extended(
                                          onPressed: () {},
                                          label: Text("Add Trip"))
                                    ]),
                                  ),
                                ),
                              );
                            });
                      },
                      label: Text("Schedule Trip")),
                )
              ],
            ),
            body: Dashboard(companytype: widget.companytype)));
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.companytype}) : super(key: key);
  final String companytype;
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('companies')
                    .doc(widget.companytype)
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
                  } else if (snapshot.hasData) {
                    companyname = snapshot.data!.docs[0].get('registered_name');

                    print(companyname);
                  }

                  return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs
                          .map((doc) => Center(
                                child: Column(
                                  children: [
                                    Text(doc['registered_name'],
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: doc['regions'].length,
                                        itemBuilder: (context, index) {
                                          return ExpansionTile(
                                              title:
                                                  Text(doc['regions'][index]),
                                              children: [
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        doc['regions'].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        title: Text(
                                                            doc['regions']
                                                                [index]),
                                                      );
                                                    })
                                              ]);
                                        }),
                                  ],
                                ),
                              ))
                          .toList());
                })));
  }
}

// Widget interroutes(int howmany) {
//   List<TextEditingController> controls = [];
//   for (var i = 0; i < howmany; i++) {
//     controls
//         .add(new TextEditingController(text: "enter route " + i.toString()));
//   }
//   bool value = false;
//   return Center(
//     child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: howmany,
//         itemBuilder: (BuildContext, index) {
//           return Form(
//               child: Column(
//             children: [
//               TextFormField(
//                 controller: controls[index],
//               ),
//               SwitchListTile(
//                   title: Text("PIck up"),
//                   value: value,
//                   onChanged: (bool val) {
//                     value = val;
//                   }),
//               Divider()
//             ],
//           ));
//         }),
//   );
// }
