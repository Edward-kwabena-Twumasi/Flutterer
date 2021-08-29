import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/agentStateProvider.dart';
import 'package:myapp/screens/agentlogin.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:geocoding/geocoding.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => CompanyState(),
      builder: (context, _) => DashApp(companytype: "Bus")));
}

TripClass onetrip = TripClass(
    "Obuasi", "Obuasi", DateTime.now(), DateTime.now(), "normal", " ");
String companyname = "";
List<String> drivers = ["Driver id"];
List<String> vehivles = ["Vehicle id"];
List destinations = [];

class DashApp extends StatefulWidget {
  final String companytype;
  const DashApp({required this.companytype});
  DashAppState createState() => DashAppState();
}

class DashAppState extends State<DashApp> {
  List<TextEditingController> controls = [];
  String feedback = "";
  List route = [];
  String initialval = vehivles[0];
  String initialval1 = drivers[0];
  bool stop = false, pickup = false;
  void changed(String? value) {
    setState(() {
      initialval = value!;
    });
  }

  void changed1(String? value) {
    setState(() {
      initialval1 = value!;
    });
  }

  Widget interroutes() {
    //bool value = false;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 18,
        child: Column(
          children: [
            TextField(controller: routecontroller),
            SizedBox(),
            StatefulBuilder(builder: (BuildContext context, setstate) {
              return SwitchListTile(
                  title: Text("PIck up point"),
                  subtitle: Text("switch on if a pickup point"),
                  activeColor: Colors.lightBlue,
                  selectedTileColor: Colors.lightBlue,
                  value: pickup,
                  selected: pickup,
                  onChanged: (bool val) {
                    setState(() {
                      pickup = val;
                    });
                  });
            }),
            Divider(height: 4, indent: 3, color: Colors.lightBlue),
            StatefulBuilder(builder: (BuildContext context, setstate) {
              return SwitchListTile(
                  title: Text("Stop point"),
                  subtitle: Text("switch on if a stop point"),
                  activeColor: Colors.lightBlue,
                  selectedTileColor: Colors.lightBlue,
                  value: stop,
                  selected: stop,
                  onChanged: (bool val) {
                    print(val);
                    setState(() {
                      stop = val;
                    });
                  });
            }),
            ButtonBar(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        route.add({
                          "routename": routecontroller.text,
                          "stop": stop,
                          "pickup": pickup
                        });
                      });
                    },
                    child: Text("ADD ROUTE")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        routecontroller.text = "";
                        stop = false;
                        pickup = false;
                      });
                    },
                    child: Text("ADD ANOTHER ROUTE")),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<String> places = [];

  final namecontroller = TextEditingController(),
      idcontroller = TextEditingController(),
      regioncontroller = TextEditingController(),
      citycontroller = TextEditingController(),
      destcontroller = TextEditingController(),
      seatcontroller = TextEditingController(),
      about = TextEditingController(),
      distcontroller = TextEditingController(),
      timecontroller = TextEditingController(),
      datecontroller = TextEditingController(),
      phonecontroller = TextEditingController(),
      drivername = TextEditingController(),
      driverphone = TextEditingController(),
      busname = TextEditingController(),
      fare = TextEditingController(),
      latitude = TextEditingController(),
      longitude = TextEditingController(),
      busnumber = TextEditingController(),
      routecontroller = TextEditingController();
  TextEditingController searchfrom = TextEditingController();
  TextEditingController searchto = TextEditingController();

  final form1 = GlobalKey<FormState>();
  final form2 = GlobalKey<FormState>();
  var selectregions = [];
  var interoutes = [];
  String showregions = '';
  int? routenum = 1;
  PageController? pgcontrol;
  @override
  void initState() {
    latitude.text = "0.0";
    longitude.text = "0.0";
    datecontroller.text = DateTime.now().toString().split(" ")[0];
    driverphone.addListener(() {
      setState(() {});
    });

    busnumber.addListener(() {
      setState(() {});
    });
    timecontroller.addListener(() {
      if (timecontroller.text.isEmpty ||
          timecontroller.text.split(":")[1].isEmpty ||
          timecontroller.text.split(":")[1].length < 2) {
        print("invalid time format");
      }
    });
    datecontroller.addListener(() {
      if (datecontroller.text.isEmpty ||
          datecontroller.text.split("-")[2].isEmpty ||
          datecontroller.text.split("-")[2].length < 2) {
        print("invalid date format");
      }
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

  String? foldername = companytype, imagename, imageurl;

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
        routes: {
          "/schedules": (context) => ShedulesInfo(),
        },
        home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              centerTitle: true,
              title: Text(
                "DashBoard",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              actions: [
                FloatingActionButton.extended(
                    label: Text("More"),
                    onPressed: _openDrawer,
                    icon: Icon(Icons.menu))
              ],
            ),
            drawer: Drawer(
              elevation: 30,
              semanticLabel: "drawer",
              child: Center(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    IconButton(
                        onPressed: _closeDrawer,
                        icon: Icon(Icons.arrow_back_ios)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        child: Text("register " + companytype),
                        onPressed: () {
                          setState(() {
                            foldername = companytype;
                          });
                          showModalBottomSheet(
                              barrierColor: Colors.indigo[300],
                              backgroundColor: Colors.indigo[200],
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
                                      Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text("Provide  details of " +
                                              companytype)),
                                      InputFields("name", busname,
                                          Icons.person_add, TextInputType.name),
                                      InputFields("number/id", busnumber,
                                          Icons.phone, TextInputType.number),
                                      InputFields(
                                          "number of seats",
                                          seatcontroller,
                                          Icons.chair,
                                          TextInputType.number),
                                      InputFields("Describe vehicle", about,
                                          Icons.phone, TextInputType.multiline),
                                      UploadPic(
                                        foldername: foldername!,
                                        imagename: busnumber.text,
                                      ),
                                      FloatingActionButton.extended(
                                          label: Text("Add " + companytype),
                                          onPressed: () {
                                            imageurl = imgUrl;

                                            FirebaseFirestore.instance
                                                .collection('companies')
                                                .doc(widget.companytype)
                                                .collection(
                                                    'Registered Companies')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              "vehicles":
                                                  FieldValue.arrayUnion([
                                                {
                                                  "name": busname.text,
                                                  "number": busnumber.text,
                                                  "seats": int.parse(
                                                      seatcontroller.text),
                                                  "image": imageurl,
                                                  "about": about.text
                                                }
                                              ])
                                            }).then((value) => print(
                                                    "Vehicle registered"));
                                          },
                                          icon: Icon(Icons.add)),
                                    ]),
                                  )),
                                );
                              });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        child: Text(
                          "register driver",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        onPressed: () {
                          setState(() {
                            companytype == "Flight"
                                ? foldername = "Pilot"
                                : foldername = "Driver";
                          });
                          showModalBottomSheet(
                              barrierColor: Colors.indigo[300],
                              backgroundColor: Colors.indigo[200],
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Provide  details"),
                                        ),
                                        InputFields(
                                            "name",
                                            drivername,
                                            Icons.person_add,
                                            TextInputType.name),
                                        InputFields("phone", driverphone,
                                            Icons.phone, TextInputType.number),
                                        InputFields("About description", about,
                                            Icons.phone, TextInputType.number),
                                        UploadPic(
                                          foldername: foldername!,
                                          imagename: driverphone.text,
                                        ),
                                        FloatingActionButton.extended(
                                            label: Text("Add to system"),
                                            onPressed: () {
                                              imageurl = imgUrl;
                                              FirebaseFirestore.instance
                                                  .collection('companies')
                                                  .doc(widget.companytype)
                                                  .collection(
                                                      'Registered Companies')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .update({
                                                "drivers":
                                                    FieldValue.arrayUnion([
                                                  {
                                                    "name": drivername.text,
                                                    "phone": driverphone.text,
                                                    "image": imageurl,
                                                    "about": about.text
                                                  }
                                                ])
                                              }).then((value) =>
                                                      print("Hello"));
                                            },
                                            icon: Icon(Icons.add)),
                                      ])),
                                    ));
                              });
                        },
                      ),
                    ),
                    FloatingActionButton.extended(
                        heroTag: "addregion",
                        onPressed: () {
                          showModalBottomSheet(
                              barrierColor: Colors.indigo[300],
                              backgroundColor: Colors.indigo[200],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.5,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      MenuButton(
                                          regioncontroller: regioncontroller),
                                      Text(showregions),
                                      FloatingActionButton.extended(
                                          onPressed: () {
                                            selectregions
                                                .add(regioncontroller.text);
                                            showregions = '';
                                            for (var i in selectregions) {
                                              showregions +=
                                                  i.toString() + " ,";
                                            }
                                            setState(() {
                                              //showregions;
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
                    FloatingActionButton.extended(
                        heroTag: "addstation",
                        onPressed: () {
                          showModalBottomSheet(
                              barrierColor: Colors.indigo[300],
                              backgroundColor: Colors.indigo[200],
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
                                            "Region",
                                            regioncontroller,
                                            Icons.input,
                                            TextInputType.text),
                                        InputFields("id", idcontroller,
                                            Icons.input, TextInputType.text),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InputFields(
                                                  "City",
                                                  citycontroller,
                                                  Icons.input,
                                                  TextInputType.text),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                  onPressed: () async {
                                                    await GeocodingPlatform
                                                        .instance
                                                        .locationFromAddress(
                                                            namecontroller
                                                                    .text +
                                                                "," +
                                                                citycontroller
                                                                    .text)
                                                        .then((value) {
                                                      setState(() {
                                                        latitude.text = value
                                                            .first.latitude
                                                            .toString();
                                                        longitude.text = value
                                                            .first.longitude
                                                            .toString();
                                                      });

                                                      print(value);
                                                    }).catchError((e) {
                                                      print(e);
                                                    });
                                                  },
                                                  child: Text("GET COORDINATES",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.green))),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InputFields(
                                                  "Latitude",
                                                  latitude,
                                                  Icons.input,
                                                  TextInputType.text),
                                            ),
                                            Expanded(
                                              child: InputFields(
                                                  "Longitude",
                                                  longitude,
                                                  Icons.input,
                                                  TextInputType.text),
                                            ),
                                          ],
                                        ),
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
                                                      "name":
                                                          namecontroller.text,
                                                      "region": regioncontroller
                                                          .text
                                                          .toUpperCase(),
                                                      "city":
                                                          citycontroller.text,
                                                      "cordinates": [
                                                        double.parse(
                                                            latitude.text),
                                                        double.parse(
                                                            longitude.text)
                                                      ],
                                                      "id": idcontroller.text,
                                                      "destinations":
                                                          destcontroller.text
                                                              .toLowerCase()
                                                              .split(","),
                                                    }
                                                  ]),
                                                  "destinations":
                                                      FieldValue.arrayUnion(
                                                          [citycontroller.text])
                                                }).then((value) =>
                                                        print("Station added"));
                                                        //add this in appstrings
                                                FirebaseFirestore.instance
                                                    .collection("appstrings")
                                                    .doc("cordinates")
                                                    .collection("stations")
                                                    .add({
                                                  "city": citycontroller.text,
                                                  "cordinates": [
                                                    double.parse(latitude.text),
                                                    double.parse(longitude.text)
                                                  ]
                                                });

                                                print({
                                                  namecontroller.text,
                                                  regioncontroller.text,
                                                  idcontroller.text
                                                });
                                              }
                                            },
                                            label: Text("Add station"))
                                      ]),
                                    ),
                                  ),
                                );
                              });
                        },
                        label: Text("Add Station")),
                        SizedBox(),
                    FloatingActionButton.extended(
                        heroTag: "schedule",
                        onPressed: () {
                          showModalBottomSheet(
                              barrierColor: Colors.indigo[300],
                              backgroundColor: Colors.indigo[200],
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
                                            searchcontrol: searchfrom,
                                          
                                            ),
                                        SearchLocs(
                                          direction: 'to',
                                          locations: places,
                                          searchcontrol: searchto,
                                          
                                        ),
                                        SizedBox(),
                                        interroutes(),
                                        StatefulBuilder(builder:
                                            (BuildContext context, setstate) {
                                          return OptionButton(
                                              options: vehivles,
                                              onchange: changed,
                                              dropdownValue: initialval);
                                        }),
                                        InputFields("Seats", seatcontroller,
                                            Icons.input, TextInputType.number),
                                        InputFields("fare", fare, Icons.input,
                                            TextInputType.number),
                                        InputFields(
                                            "distance/km",
                                            distcontroller,
                                            Icons.input,
                                            TextInputType.number),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InputFields(
                                                  "Date : YYYY/MM/DD",
                                                  datecontroller,
                                                  Icons.input,
                                                  TextInputType.datetime),
                                            ),
                                            Expanded(
                                              child: InputFields(
                                                  "Time : 00:00",
                                                  timecontroller,
                                                  Icons.input,
                                                  TextInputType.datetime),
                                            )
                                          ],
                                        ),
                                        StatefulBuilder(builder:
                                            (BuildContext context, setstate) {
                                          return OptionButton(
                                              options: drivers,
                                              onchange: changed1,
                                              dropdownValue: initialval1);
                                        }),
                                        InputFields(
                                            "Please describe Trip to traveller",
                                            about,
                                            Icons.input,
                                            TextInputType.text),
                                        FloatingActionButton.extended(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("trips")
                                                  .add({
                                                "from": searchfrom.text,
                                                "to": searchto.text,
                                                "interoutes": route,
                                                "distance": int.parse(
                                                    distcontroller.text),
                                                "date": DateTime.parse(
                                                    datecontroller.text +
                                                        " " +
                                                        timecontroller.text),
                                                "seats": int.parse(
                                                    seatcontroller.text),
                                                "company": companyname,
                                                "vehid": initialval,
                                                "full": false,
                                                "chosen": [],
                                                "fare": int.parse(fare.text),
                                                "driverid": initialval1,
                                                "triptype": companytype,
                                                "abouttrip": about.text,

                                              }).then((value) {
                                                setState(() {
                                                  feedback =
                                                      "Trip added successfullly";
                                                });
                                                print(
                                                    "Trip added successfullly");
                                              });
                                            },
                                            label: Text("Add Trip")),
                                        Text(feedback,
                                            style:
                                                TextStyle(color: Colors.green))
                                      ]),
                                    ),
                                  ),
                                );
                              });
                        },
                        label: Text("Schedule Trip")),
                  ],
                ),
              ),
            ),
            body: PageView(
                controller: pgcontrol,
                physics: ScrollPhysics(),
                children: [
                  Dashboard(companytype: widget.companytype),
                  ShedulesInfo(),
                  Statistics()
                ])));
  }
}

class Statistics extends StatelessWidget {
  const Statistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Text("Statistics"),
          ),
          SizedBox(),
          Card(
              child: Column(children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Daily active users"),
            )),
            Text("20"),
            Divider(),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Trips in session"),
            )),
            Text("20"),
            Divider(),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Completed trips"),
            )),
            Text("10"),
          ]))
        ],
      ),
    ));
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.companytype}) : super(key: key);
  final String companytype;
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                color: Colors.lightBlue[50]!.withOpacity(0.5),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('companies')
                            .doc(widget.companytype)
                            .collection('Registered Companies')
                            .where('id',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData &&
                              !(snapshot.connectionState ==
                                  ConnectionState.done)) {
                            return Center(
                                child: Card(
                                    elevation: 8,
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Loading data...")
                                      ],
                                    )));
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.size > 0) {
                              companyname =
                                  snapshot.data!.docs[0].get('registered_name');
                            }

                            print(companyname);
                          }

                          return SingleChildScrollView(
                            child: Column(
                                children: snapshot.data!.docs.map((doc) {
                              // destinations = doc["destinations"];
                              // print(destinations);
                              return Center(
                                child: SingleChildScrollView(
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
                                                children: doc['stations']
                                                            .length <
                                                        1
                                                    ? [Text("Add stations")]
                                                    : List.unmodifiable(
                                                        () sync* {
                                                        for (var i = 0;
                                                            i <
                                                                doc['stations']
                                                                    .length;
                                                            i++) {
                                                          if (doc['stations'][i]
                                                                  ['region'] ==
                                                              doc['regions']
                                                                  [index]) {
                                                            yield ListTile(
                                                              title: Text(
                                                                  doc['stations']
                                                                          [i]
                                                                      ['name']),
                                                            );
                                                          }
                                                        }
                                                      }()));
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Card(
                                          color:
                                              Colors.pink[50]!.withOpacity(0.5),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  doc['drivers'].length > 0
                                                      ? doc['drivers'].length
                                                      : 0,
                                              itemBuilder:
                                                  (BuildContext context, idx) {
                                                if (!drivers.contains(
                                                    doc['drivers'][idx]
                                                        ["phone"])) {
                                                  drivers.add(doc['drivers']
                                                      [idx]["phone"]);
                                                }

                                                return ListTile(
                                                    title: Text(doc['drivers']
                                                        [idx]["name"]),
                                                    subtitle: Text(
                                                      doc['drivers'][idx]
                                                          ["phone"],
                                                    ));
                                              }),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Card(
                                          color: Colors.grey.withOpacity(0.4),
                                          elevation: 5,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  doc['vehicles'].length > 0
                                                      ? doc['vehicles'].length
                                                      : 0,
                                              itemBuilder:
                                                  (BuildContext context, idx) {
                                                if (!vehivles.contains(
                                                    doc['vehicles'][idx]
                                                        ["number"])) {
                                                  vehivles.add(doc['vehicles']
                                                      [idx]["number"]);
                                                }

                                                return ListTile(
                                                    title: Text(doc['vehicles']
                                                        [idx]["name"]),
                                                    subtitle: Text(
                                                      doc['vehicles'][idx]
                                                          ["number"],
                                                    ));
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList()),
                          );
                        })),
              )),
        ],
      ),
    );
  }
}

class ShedulesInfo extends StatefulWidget {
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
              title: Text("Sheduled Trips",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('trips').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      new ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((data) {
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              height: 150,
                              child: new ListTile(
                                title: new Text(data.id),
                                subtitle: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    new Text(data['from'] + " > " + data['to']),
                                    new Text("Vehicle id : " +
                                        data['vehid'].toString()),
                                    new Text("Total seats : " +
                                        data['seats'].toString()),
                                    new Text("Booked : " +
                                        data['chosen'].length.toString()),
                                    new Text("Remaining : " +
                                        data['seats'].toString()),
                                    new Text("Take off : " +
                                        data['date']
                                            .toDate()
                                            .toString()
                                            .split(" ")[1]),
                                    ButtonBar(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text("Reschedule")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text("Cancel")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text("Hold")),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class SimpleCardPaint extends CustomPaint {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var radius = 24.0;
//     var paint = Paint();
//     paint.shader=Gradient.linear(from, to, colors)

//   }
// }

class FlightCompany extends StatefulWidget {
  const FlightCompany({Key? key}) : super(key: key);

  @override
  _FlightCompanyState createState() => _FlightCompanyState();
}

class _FlightCompanyState extends State<FlightCompany> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Driver {
  Driver(this.id);
  String id;
}

class Bus {
  Bus(this.id);
  String id;
}

class Route {
  String name;
  bool stop;
  bool pickup;
  Route(this.name, this.stop, this.pickup);
}

class RegPayment extends StatefulWidget {
  // RegPayment({required this.pageurl});
  // final String pageurl;
  @override
  RegPaymentState createState() => RegPaymentState();
}

class RegPaymentState extends State<RegPayment> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text("Make payment"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 5,
            child: WebView(
              debuggingEnabled: true,
              initialUrl:
                  'https://dashboard.paystack.com/#/signup?_id=8a190335-9d74-4014-87db-198e37e1c9a5R',
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (navigation) {
                if (navigation.url == '') {}
                return NavigationDecision.navigate;
              },
            ),
          ),
        ),
      ),
    );
  }
}
