import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/agentStateProvider.dart';
import 'package:myapp/screens/agentlogin.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:geocoding/geocoding.dart';

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
    TripClass("Obuasi", "Obuasi", DateTime.now(), DateTime.now(), "normal");
String companyname = "";
List<String> drivers = ["Driver id"];
List<String> vehivles = ["Vehicle id"];

class DashApp extends StatefulWidget {
  final String companytype;
  const DashApp({required this.companytype});
  DashAppState createState() => DashAppState();
}

class DashAppState extends State<DashApp> {
  List<TextEditingController> controls = [];
  List<bool> stopstate = [];
  List<bool> pickstate = [];
  String initialval = vehivles[0];
  String initialval1 = drivers[0];
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

  Widget interroutes(int howmany) {
    print(howmany);
    controls = [];
    stopstate = [];
    pickstate = [];
    for (var i = 0; i < howmany; i++) {
      controls.add(
          new TextEditingController(text: "enter route " + (i + 1).toString()));
      pickstate.add(false);
      stopstate.add(false);
    }
    bool value = false;
    return Container(
      height: 400,
      child: ListView.builder(
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
          }),
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
    routecontroller.text = routenum.toString();
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
              child: Center(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    IconButton(
                        onPressed: _closeDrawer,
                        icon: Icon(Icons.arrow_back_ios)),
                    FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pushNamed(context, "/schedules");
                      },
                      label: Text(
                        "See shedules",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
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
                                                  "seats": seatcontroller,
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
                    ),
                  ],
                ),
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
                                          "Region/capitalise",
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
                                                          namecontroller.text +
                                                              "," +
                                                              citycontroller
                                                                  .text)
                                                      .then((value) {
                                                    setState(() {
                                                      latitude.text =
                                                          value.first.latitude.toString();
                                                           longitude.text =
                                                          value.first.longitude.toString();

                                                    });

                                                    print(value);
                                                  }).catchError((e) {
                                                    print(e);
                                                  });
                                                },
                                                child: Text("GET COORDINATES",
                                                    style: TextStyle(
                                                        color: Colors.green))),
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
                                                    "cordinates":GeoPoint(double.parse(latitude.text),
                                                     double.parse(longitude.text)),
                                                   
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
                                          searchcontrol: searchfrom),
                                      SearchLocs(
                                        direction: 'to',
                                        locations: places,
                                        searchcontrol: searchto,
                                      ),
                                      Container(
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        width: 500,
                                        height: 60,
                                        child: Row(children: [
                                          Expanded(
                                            child: InputFields(
                                                "how many inter routes?",
                                                routecontroller,
                                                Icons.input,
                                                TextInputType.text),
                                          ),
                                          TextButton(
                                              style: ButtonStyle(),
                                              onPressed: () {
                                                print(routenum);
                                                int num = int.parse(
                                                    routecontroller.text);
                                                setState(() {
                                                  routenum = num;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "add them",
                                                  style: TextStyle(
                                                      backgroundColor:
                                                          Colors.amber,
                                                      color: Colors.black),
                                                ),
                                              ))
                                        ]),
                                      ),
                                      interroutes(routenum!),
                                      OptionButton(
                                          options: vehivles,
                                          onchange: changed,
                                          dropdownValue: initialval),
                                      // InputFields("Bus id", idcontroller,
                                      //     Icons.input, TextInputType.text),
                                      InputFields("Seats", seatcontroller,
                                          Icons.input, TextInputType.number),
                                      InputFields("distance/km", distcontroller,
                                          Icons.input, TextInputType.number),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InputFields(
                                                "Date : YYYY-MM-DD",
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

                                      OptionButton(
                                          options: drivers,
                                          onchange: changed1,
                                          dropdownValue: initialval1),

                                      FloatingActionButton.extended(
                                          onPressed: () {
                                            for (int i = 0;
                                                i < controls.length;
                                                i++) {
                                              interoutes.add([
                                                {
                                                  "routename": controls[i].text,
                                                  "stop": stopstate[i],
                                                  "pickup": pickstate[i]
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
                                              "datetime": DateTime.parse(
                                                  datecontroller.text +
                                                      " " +
                                                      timecontroller.text),
                                              "seats": int.parse(
                                                  seatcontroller.text),
                                              "company": companyname,
                                              "vehid": idcontroller.text,
                                              "driverid": phonecontroller.text,
                                              "triptype": companytype
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
            body: PageView(
                controller: pgcontrol,
                physics: ScrollPhysics(),
                children: [
                  Dashboard(companytype: widget.companytype),
                  ShedulesInfo(),
                  Container(
                      child: Center(
                    child: Text("Statistics"),
                  ))
                ])));
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
                                Text("Loading data...")
                              ],
                            )));
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.size > 0) {
                      companyname =
                          snapshot.data!.docs[0].get('registered_name');
                      triptype = widget.companytype;
                    }

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
                                              children: doc['stations'].length <
                                                      1
                                                  ? [Text("Add stations")]
                                                  : List.unmodifiable(() sync* {
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
                                  ],
                                ),
                              ))
                          .toList());
                })));
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
              title: Text("Sheduled Trips"),
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

                return new ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((data) {
                    return new ListTile(
                      title: new Text(data.id),
                      subtitle: ListView(
                        shrinkWrap: true,
                        children: [
                          new Text(data['from'] + " ===> " + data['to']),
                          new Text("Bus id : " + data['busnumber'].toString()),
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
