import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:myapp/components/AgentsList.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/screens/completebook.dart';
import 'package:myapp/screens/reportscreen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/components/getlocation.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

enum companyFilters { VIP, STC, MMT }
enum queryFilters { isEqualTo }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => UserState(), builder: (context, _) => ButtomNav()));
}

// TripClass onetrip =
//     TripClass("Obuasi", "Obuasi", "10:00", "20 10 2021", "normal");
List<String> places = ["Kumasi", "Obuasi", "Accra", "Kasoa", "Mankessim", "Wa"];
Seat seat = Seat("busnumber", 30, 20, "from", "to", "tripid");

class ButtomNav extends StatefulWidget {
  @override
  ButtomNavState createState() => ButtomNavState();
}

class ButtomNavState extends State<ButtomNav> {
  static List<Widget> pages = [
    TabBarDemo(),
    HelpClass(),
    Center(
        child: Text("Notify",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
    UserInfoClass(),
  ];
  int currentindx = 0;

  void swithnav(int value) {
    setState(() {
      currentindx = value;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/matchingtrips": (context) => Trips(onetrip),
        "/location": (context) => GeolocatorWidget(),
        "/completebook": (context) => Booking(),
        "/reports": (context) => Reporter()
      },
      home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentindx,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              elevation: 8,
              onTap: swithnav,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
                BottomNavigationBarItem(icon: Icon(Icons.help), label: "help"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications), label: "Notify"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
              ]),
          body: Center(
            child: pages.elementAt(currentindx),
          )),
    );
  }
}

class TabBarDemo extends StatelessWidget {
  TextEditingController searchfrom = TextEditingController();
  TextEditingController searchto = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
            ],
            bottom: TabBar(
              indicatorColor: Colors.lightGreen,
              tabs: [
                Tab(icon: Icon(Icons.bus_alert_rounded, color: Colors.black)),
                Tab(icon: Icon(Icons.train, color: Colors.black)),
                Tab(icon: Icon(Icons.flight, color: Colors.black)),
              ],
            )),
        body: TabBarView(
          children: [
            SafeArea(
              child: Container(
                
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/bus1.png'), fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("Find and book for Buses",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Locations(),
                    // Stack(
                    //   overflow: Overflow.visible,
                    //   alignment: Alignment.bottomCenter,
                    //   children: [
                    //     Positioned(
                    //         left: 3,
                    //         bottom: 5,
                    //         child: FloatingActionButton(
                    //           heroTag: "availables",
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(6)),
                    //           onPressed: () {
                    //             print(
                    //                 "fetch available seats for defined locations");
                    //           },
                    //           child: Icon(Icons.chair),
                    //         )),
                    //     Positioned(
                    //         right: 3,
                    //         bottom: 5,
                    //         child: FloatingActionButton(
                    //           heroTag: "leaving",
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(6)),
                    //           onPressed: () {
                    //             print(
                    //                 "ready to leave trips for defined locations");
                    //           },
                    //           child: Icon(Icons.watch),
                    //         ))
                    //   ],
                    // )
                  ],
                ),
              ),
            ),

            //Block for Buses
            SafeArea(
              child: Container(
               
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/bus1.png'), fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("Find and book for trains",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Locations(),
                  ],
                ),
              ),
            ),
            //Block for trains
            SafeArea(
              child: Container(
               
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/train1.png'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("Find and book for flights",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Locations(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget region() {
  TextEditingController mycontroller = TextEditingController();
  return Container(
      child: Center(),
      height: 70,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(15));
}

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  LocationsState createState() => LocationsState();
}

class LocationsState extends State<Locations> {
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton.extended(
              onPressed: () async {
                var position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.best)
                    .then((value) async {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                          value.latitude, value.longitude)
                      .then((value2) {
                    print(value2);
                    return value2;
                  });
                });

                setState(
                  () {},
                );
              },
              label: Text("Current loc"),
              icon: Icon(Icons.location_on),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            SearchLocs(
                direction: 'from', locations: places, searchcontrol: from),
            SizedBox(height: 5),
            SearchLocs(
              direction: 'to',
              locations: places,
              searchcontrol: to,
            ),
            Expanded(
                child: Center(
                    child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //add time chooser
                SizedBox(
                  height: 10,
                  child: MyStatefulWidget(
                    restorationId: "main",
                  ),
                ), //proceed with boooking
                SizedBox(
                  height: 100,
                  child: FloatingActionButton(
                    splashColor: Colors.white,
                    shape: StadiumBorder(),
                    onPressed: () {
                      print("clicked");
                      print(onetrip.date);
                      Navigator.pushNamed(context, "/matchingtrips");
                    },
                    child: Text("Search"),
                  ),
                )
              ],
            ))),
          ],
        )),
        height: 300,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(8));

    // TODO: implement build
  }
}

//primary actions

/// This is the stateful widget that the main application instantiates.

//trips class to list trips serached for
class Trips extends StatefulWidget {
  TripClass _tripdata;
  Trips(this._tripdata);
  @override
  TripsState createState() => TripsState();
}

class TripsState extends State<Trips> {
  // String gttriptype ;
  companyFilters filter = companyFilters.VIP;
  bool isfound = true;
  List filterquery = ["VIP", "STC", "MMT"];
  void filterall() {
    setState(() {
      filterquery = ["VIP", "STC", "MMT"];
    });
  }

  void filtervip() {
    setState(() {
      filterquery = ["VIP"];
    });
  }

  void filterstc() {
    setState(() {
      filterquery = ["STC"];
    });
  }

  void filtermmt() {
    setState(() {
      filterquery = ["MMT"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "All trips for this location",
      routes: {"/completebook": (context) => Booking()},
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text("All trips for this location"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 150,
                margin: EdgeInsets.all(20),
                child: Center(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(6, 1, 6, 1),
                          child: niceChips(Icons.all_out, "All", filterall)),
                      Container(
                          margin: EdgeInsets.fromLTRB(6, 1, 6, 1),
                          child: niceChips(Icons.all_out, "VIP", filtervip)),
                      Container(
                          margin: EdgeInsets.fromLTRB(6, 1, 6, 1),
                          child: niceChips(Icons.all_out, "STC", filterstc)),
                      Container(
                          margin: EdgeInsets.fromLTRB(6, 1, 6, 1),
                          child: niceChips(
                              Icons.all_out, "Metro Mass", filtermmt)),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('trips')
                          .where("from", isEqualTo: widget._tripdata.fromLoc)
                          .where("to", isEqualTo: widget._tripdata.toLoc)
                          .where("company", whereIn: filterquery)
                          //.where("seats", isGreaterThan: 0)
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
                                      Text("Loading ...")
                                    ],
                                  )));
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                        } else if (snapshot.hasData) {
                          // ignore: unnecessary_statements
                          isfound = true;
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            !snapshot.hasData) {
                          isfound = false;
                        }
                        return isfound
                            ? ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((doc) => Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          elevation: 5,
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: doc['date'].length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          idx) {
                                                    return Text(
                                                        doc['date'][idx].toString());
                                                  }),
                                              ListTile(
                                                  title: Row(
                                                    children: [
                                                      Text(doc['from'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              backgroundColor:
                                                                  Colors.amber,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text("  to   "),
                                                      Text(doc['to'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueGrey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                  subtitle:
                                                      Text(doc['company'])),
                                              Divider(
                                                thickness: 0.8,
                                                color: Colors.blueGrey,
                                              ),
                                              ListTile(
                                                  trailing: Text(
                                                      doc['fare'].toString() +
                                                          ' Cdz',
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          color: Colors
                                                              .lightBlue)),
                                                  leading: Icon(
                                                    Icons.chair,
                                                    size: 40,
                                                  ),
                                                  title: Text(
                                                      doc['seats'].toString() +
                                                          " Available"),
                                                  subtitle:
                                                      FloatingActionButton(
                                                          onPressed: () {
                                                            seat.busnumber =
                                                                doc["busnumber"];
                                                            seat.from =
                                                                doc["from"];
                                                            seat.to = doc["to"];
                                                            seat.seats =
                                                                doc["seats"];
                                                            seat.unitprice =
                                                                doc["fare"];
                                                            seat.tripid = doc.id
                                                                .toString();
                                                            print('clicked');
                                                            Navigator.pushNamed(
                                                                context,
                                                                "/completebook");
                                                          },
                                                          child: Text("Book")))
                                            ],
                                          ),
                                        ))
                                    .toList())
                            : Text("Couldnt find matching search");
                      })),
            ]),
          ),
        ),
      ),
    );
  }
}

class TripClass {
  String fromLoc;
  String toLoc;
  String time;
  String date;
  String tripclass;

  TripClass(this.fromLoc, this.toLoc, this.time, this.date, this.tripclass);
}

class HelpClass extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text("Find help"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              FloatingActionButton.extended(
                heroTag: "cheap",
                onPressed: () {},
                label: Text("Make a cheap travel"),
                icon: Icon(Icons.money),
              ),
              SizedBox(height: 40),
              FloatingActionButton.extended(
                  heroTag: "where",
                  onPressed: () {
                    Navigator.pushNamed(context, '/location');
                  },
                  label: Text("Where am i?"),
                  icon: Icon(Icons.location_on)),
              SizedBox(height: 40),
              FloatingActionButton.extended(
                heroTag: "report",
                onPressed: () {
                  Navigator.pushNamed(context, "/reports");
                },
                label: Text("Report a matter"),
                icon: Icon(Icons.report_problem),
              ),
              SizedBox(height: 40),
              FloatingActionButton.extended(
                heroTag: "health",
                onPressed: () {},
                label: Text("My Health"),
                icon: Icon(Icons.health_and_safety),
              ),
            ]),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime(2021));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2022, 1, 1),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        onetrip.date =
            ' ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FloatingActionButton.extended(
      heroTag: "date",
      onPressed: () {
        _restorableDatePickerRouteFuture.present();
      },
      label: const Text('Travel date'),
      icon: Icon(Icons.calendar_today),
    ));
  }
}

class UserInfoClass extends StatefulWidget {
  @override
  UserInfoClassState createState() => UserInfoClassState();
}

class UserInfoClassState extends State<UserInfoClass> {
  String? setemail = "sign in";
  String? setname = "yes sign in";
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Consumer<UserState>(
        builder: (context, value, child) => Column(
          children: [
            Text("Welcome !",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
            Container(
              margin: EdgeInsets.all(30),
              child: CircleAvatar(
                child: Image.asset(
                  "images/bus2.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: ListTile(
                title: Text("Name"),
                subtitle: Text(value.loggedInAs.toString()),
                leading: CircleAvatar(
                  child: Image.asset("images/bus1.png"),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: ListTile(
                title: Text("Phone"),
                subtitle: Text("0552489602"),
                leading: CircleAvatar(
                  child: Image.asset("images/bus1.png"),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: ListTile(
                title: Text("Email"),
                subtitle: Text(value.loggedinmail.toString()),
                leading: CircleAvatar(
                  child: Image.asset("images/bus1.png"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Seat {
  String busnumber;
  int seats;
  int unitprice;
  String from;
  String to;
  String tripid;
  Seat(this.busnumber, this.seats, this.unitprice, this.from, this.to,
      this.tripid);
}
