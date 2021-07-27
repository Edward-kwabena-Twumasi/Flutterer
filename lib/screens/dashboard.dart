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
  final String companytype;
  const DashApp({required this.companytype});
  DashAppState createState() => DashAppState();
}

class DashAppState extends State<DashApp> {
  List<TextEditingController> controls = [];
  List<bool> stopstate = [];
  List<bool> pickstate = [];
  Widget interroutes(int howmany) {
    for (var i = 0; i < howmany; i++) {
      controls
          .add(new TextEditingController(text: "enter route " + (i+1).toString()));
      pickstate.add(false);
      stopstate.add(false);
    }
    bool value = false;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: howmany,
        itemBuilder: (BuildContext, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 18,
              child: Column(
                children: [
                  TextFormField(
                    controller: controls[index],
                  ),
                  SwitchListTile(
                      title: Text("PIck up point"),
                      subtitle: Text("switch on if a pickup point"),
                      activeColor: Colors.lightBlue,
                      value: pickstate[index],
                      onChanged: (bool val) {
                        setState(() {
                          pickstate[index] = val;
                          pickstate = pickstate;
                        });
                      }),
                  SwitchListTile(
                      title: Text("Stop point"),
                      subtitle: Text("switch on if a stop point"),
                      value: stopstate[index],
                      onChanged: (bool val) {
                        print(val);
                        setState(() {
                          stopstate[index] = val;
                          stopstate = stopstate;
                        });
                      }),
                  Divider(height: 4, indent: 3, color: Colors.lightBlue)
                ],
              ),
            ),
          );
        });
  }

  List<String> places = [];

  final namecontroller = TextEditingController(),
      idcontroller = TextEditingController(),
      regioncontroller = TextEditingController(),
      citycontroller = TextEditingController(),
      destcontroller = TextEditingController(),
      seatcontroller = TextEditingController(),
      distcontroller = TextEditingController(),
      ttimecontroller = TextEditingController(),
      phonecontroller = TextEditingController(),
      drivername = TextEditingController(),
      driverphone = TextEditingController(),
      busname = TextEditingController(),
      busnumber = TextEditingController(),
      routecontroller = TextEditingController();
  TextEditingController searchfrom = TextEditingController();
  TextEditingController searchto = TextEditingController();

  final form1 = GlobalKey<FormState>();
  final form2 = GlobalKey<FormState>();
  var selectregions = [];
  var interoutes = [];
  String showregions = '';
  int? routenum;
  @override
  void initState() {
    routenum = 1;
    routecontroller.text = routenum.toString();
    routecontroller.addListener(() {
      if (routecontroller.text.isNotEmpty) {
        setState(() {
          routenum = int.parse(routecontroller.text);
        });
      }
    });
    driverphone.addListener(() {
      setState(() {});
    });

    busnumber.addListener(() {
      setState(() {});
    });
    List<String> getplaces = [
      "Kumasi",
      "Obuasi",
      "Accra",
      "Kasoa",
      "Mankessim",
      "Wa"
    ];
    places = getplaces;
    super.initState();
  }

  String? foldername, imagename, imageurl = "";

  void pressed() {
    selectregions.add("REGION");
    return null;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              title: Text(companyname + "  Dashboard"),
              actions: [
                IconButton(onPressed: _openDrawer, icon: Icon(Icons.menu))
              ],
            ),
            drawer: Drawer(
              elevation: 30,
              semanticLabel: "drawer",
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  IconButton(
                      onPressed: _closeDrawer,
                      icon: Icon(Icons.arrow_back_ios)),
                  // DrawerHeader(
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue,
                  //   ),
                  //   child: Text('Menu'),
                  // ),
                  TextButton(
                    child: Text("register bus"),
                    onPressed: () {
                      setState(() {
                        foldername = "Bus";
                      });
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                              heightFactor: 0.95,
                              child: SingleChildScrollView(
                                  child: Form(
                                child: Column(children: [
                                  Text("Provide Bus details"),
                                  InputFields("name", busname, Icons.person_add,
                                      TextInputType.name),
                                  InputFields("number/id", busnumber,
                                      Icons.phone, TextInputType.number),
                                  InputFields("number of seats", seatcontroller,
                                      Icons.phone, TextInputType.number),
                                  UploadPic(
                                      foldername: foldername!,
                                      imagename: busnumber.text,
                                      imgUrl: imageurl!),
                                  FloatingActionButton.extended(
                                      label: Text("Add bus"),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('companies')
                                            .doc(widget.companytype)
                                            .collection('Registered Companies')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          "drivers": FieldValue.arrayUnion([
                                            {
                                              "name": busname.text,
                                              "number": busnumber.text,
                                              "seats": busnumber.text,
                                              "image": imageurl
                                            }
                                          ])
                                        }).then((value) =>
                                                print("Bus registered"));
                                      },
                                      icon: Icon(Icons.add)),
                                ]),
                              )),
                            );
                          });
                    },
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    child: Text("register driver"),
                    onPressed: () {
                      setState(() {
                        foldername = "Driver";
                      });
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                                heightFactor: 0.95,
                                child: SingleChildScrollView(
                                  child: Form(
                                      child: Column(children: [
                                    Text("Provide driver details"),
                                    InputFields("name", drivername,
                                        Icons.person_add, TextInputType.name),
                                    InputFields("phone", driverphone,
                                        Icons.phone, TextInputType.number),
                                    UploadPic(
                                        foldername: foldername!,
                                        imagename: driverphone.text,
                                        imgUrl: imageurl!),
                                    FloatingActionButton.extended(
                                        label: Text("Add bus"),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('companies')
                                              .doc(widget.companytype)
                                              .collection(
                                                  'Registered Companies')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "buses": FieldValue.arrayUnion([
                                              {
                                                "name": drivername.text,
                                                "phone": driverphone.text,
                                                "image": imageurl
                                              }
                                            ])
                                          }).then((value) => print("Hello"));
                                        },
                                        icon: Icon(Icons.add)),
                                    Row(
                                      children: List.unmodifiable(() sync* {
                                        for (var i = 0; i < 5; i++) {
                                          yield Expanded(
                                            child: IconButton(
                                              iconSize: 30,
                                              icon: Icon(Icons.ac_unit),
                                              color: Colors.green,
                                              onPressed: () {},
                                            ),
                                          );
                                        }
                                      }()),
                                    )
                                  ])),
                                ));
                          });
                    },
                  ),
                ],
              ),
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
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50))),
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
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50))),
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
                                      InputFields(
                                          "Region/capitalise",
                                          regioncontroller,
                                          Icons.input,
                                          TextInputType.text),
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
                                                    "region": regioncontroller
                                                        .text
                                                        .toUpperCase(),
                                                    "city": citycontroller.text,
                                                    "id": idcontroller.text,
                                                    "destinations":
                                                        destcontroller.text
                                                            .toLowerCase()
                                                            .split(",")
                                                  }
                                                ])
                                              }).then((value) =>
                                                      print("Station added"));
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
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50))),
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
                                          searchcontrol: searchfrom),
                                      SearchLocs(
                                        direction: 'to',
                                        locations: places,
                                        searchcontrol: searchto,
                                      ),
                                      Container(
                                        width: 500,
                                        height: 100,
                                        child: Row(children: [
                                          Expanded(
                                            child: InputFields(
                                                "how many inter routes?",
                                                routecontroller,
                                                Icons.input,
                                                TextInputType.text),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                int num = int.parse(
                                                    routecontroller.text);
                                                setState(() {
                                                  routenum = num;
                                                });
                                              },
                                              child: Text("add them"))
                                        ]),
                                      ),
                                      interroutes(routenum!),
                                      InputFields("Bus id", idcontroller,
                                          Icons.input, TextInputType.text),
                                      Text("SELECT IMAGE"),
                                      InputFields("Seats", seatcontroller,
                                          Icons.input, TextInputType.number),
                                      InputFields("distance/km", distcontroller,
                                          Icons.input, TextInputType.number),
                                      InputFields("duration", ttimecontroller,
                                          Icons.input, TextInputType.datetime),
                                      InputFields(
                                          "Driver Contact",
                                          phonecontroller,
                                          Icons.input,
                                          TextInputType.phone),
                                      Text("SELECT IMAGE"),
                                      FloatingActionButton.extended(
                                          onPressed: () {
                                            for (int i = 0;
                                                i < controls.length;
                                                i++) {
                                              interoutes.add([
                                                {
                                                  "routename": controls[i].text,
                                                  "stop":
                                                      stopstate[i].toString(),
                                                  "pickup":
                                                      pickstate[i].toString()
                                                }
                                              ]);
                                            }
                                            FirebaseFirestore.instance
                                                .collection("trips")
                                                .add({
                                              "from": searchfrom.text,
                                              "to": searchto.text,
                                              "interoutes": interoutes,
                                              "distance": int.parse(
                                                  distcontroller.text),
                                              "duration": int.parse(
                                                  ttimecontroller.text),
                                              "seats": int.parse(
                                                  seatcontroller.text),
                                              "company": companyname,
                                              "busid": idcontroller.text,
                                              "driverphone":
                                                  phonecontroller.text,
                                            });
                                          },
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
                                    Text("Not verified",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
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
                                              children:
                                                  List.unmodifiable(() sync* {
                                                for (var i = 0;
                                                    i < doc['stations'].length;
                                                    i++) {
                                                  if (doc['stations'][i]
                                                          ['region'] ==
                                                      doc['regions'][index]) {
                                                    yield ListTile(
                                                      title: Text(
                                                          doc['stations'][i]
                                                              ['name']),
                                                    );
                                                  }
                                                }
                                              }())
                                              // [
                                              //   Text("Stations",
                                              //       style: TextStyle(
                                              //           fontWeight:
                                              //               FontWeight.bold)),
                                              //   ListView.builder(
                                              //       shrinkWrap: true,
                                              //       itemCount:
                                              //           doc['stations'].length,
                                              //       itemBuilder:
                                              //           (context, indx) {
                                              //         return ListTile(
                                              //           title: Text(
                                              //               doc['stations']
                                              //                   [indx]['name']),
                                              //           subtitle: Text(
                                              //               doc['stations']
                                              //                           [indx]
                                              //                       ['region'] +
                                              //                   "  " +
                                              //                   doc['stations']
                                              //                           [indx]
                                              //                       ['city']),
                                              //         );
                                              //       })
                                              // ]
                                              );
                                        }),
                                  ],
                                ),
                              ))
                          .toList());
                })));
  }
}
