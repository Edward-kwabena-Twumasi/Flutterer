import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/components/AgentsList.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/screens/completebook.dart';
import 'package:myapp/screens/reportscreen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/components/getlocation.dart';

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
              tabs: [
                Container(
                    padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red[50]),
                    child: Tab(
                        icon: Icon(Icons.bus_alert_rounded,
                            color: Colors.black))),
                Container(
                    padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red[50]),
                    child: Tab(icon: Icon(Icons.train, color: Colors.black))),
                Container(
                    padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red[50],
                    ),
                    child: Tab(icon: Icon(Icons.flight, color: Colors.black))),
              ],
            )),
        body: TabBarView(
          children: [
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
                    locations(),
                    Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: EdgeInsets.all(5),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                FloatingActionButton.extended(
                                    heroTag: "5",
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.8,
                                              child: Column(children: [
                                                SearchLocs(
                                                  direction: 'from',
                                                  locations: places,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SearchLocs(
                                                  direction: 'to',
                                                  locations: places,
                                                )
                                              ]),
                                            );
                                          });
                                    },
                                    label: Text("Available Seats")),
                                FloatingActionButton.extended(
                                    heroTag: "4",
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.9,
                                              child: Column(children: [
                                                SearchLocs(
                                                  direction: 'from',
                                                  locations: places,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SearchLocs(
                                                  direction: 'to',
                                                  locations: places,
                                                )
                                              ]),
                                            );
                                          });
                                    },
                                    label: Text("Recent activity")),
                                FloatingActionButton.extended(
                                    heroTag: "3",
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.9,
                                              child: Column(children: [
                                                SearchLocs(
                                                  direction: 'from',
                                                  locations: places,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SearchLocs(
                                                  direction: 'to',
                                                  locations: places,
                                                )
                                              ]),
                                            );
                                          });
                                    },
                                    label: Text("Departures")),
                              ],
                            ),
                          ),
                          Container(
                              height: 60,
                              padding: EdgeInsets.all(5),
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  FloatingActionButton.extended(
                                      heroTag: "1",
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Column(children: [
                                                SearchLocs(
                                                  direction: 'from',
                                                  locations: places,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SearchLocs(
                                                  direction: 'to',
                                                  locations: places,
                                                )
                                              ]);
                                            });
                                      },
                                      label: Text("Find company")),
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bus1.png'), fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  locations(),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              FloatingActionButton.extended(
                                  heroTag: "avs2",
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: [
                                            SearchLocs(
                                              direction: 'from',
                                              locations: places,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SearchLocs(
                                              direction: 'to',
                                              locations: places,
                                            )
                                          ]);
                                        });
                                  },
                                  label: Text("Available Seats")),
                              FloatingActionButton.extended(
                                  heroTag: "recact2",
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: [
                                            SearchLocs(
                                              direction: 'to',
                                              locations: places,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SearchLocs(
                                              direction: 'to',
                                              locations: places,
                                            )
                                          ]);
                                        });
                                  },
                                  label: Text("Recent activity")),
                              FloatingActionButton.extended(
                                  heroTag: "dep2",
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: []);
                                        });
                                  },
                                  label: Text("Departures")),
                            ],
                          ),
                        ),
                        Container(
                            height: 60,
                            padding: EdgeInsets.all(5),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                FloatingActionButton.extended(
                                    heroTag: "fc2",
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(children: []);
                                          });
                                    },
                                    label: Text("Find company")),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/train1.png'), fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  locations(),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              FloatingActionButton.extended(
                                  heroTag: "avs3",
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: []);
                                        });
                                  },
                                  label: Text("Available Seats")),
                              FloatingActionButton.extended(
                                  heroTag: "recact3",
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: []);
                                        });
                                  },
                                  label: Text("Recent activity")),
                              FloatingActionButton.extended(
                                  heroTag: "dep3",
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: []);
                                        });
                                  },
                                  label: Text("Departures")),
                            ],
                          ),
                        ),
                        Container(
                            height: 60,
                            padding: EdgeInsets.all(5),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                FloatingActionButton.extended(
                                    heroTag: "fc3",
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(children: []);
                                          });
                                    },
                                    label: Text("Find company")),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
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

class locations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SearchLocs(
              direction: 'from',
              locations: places,
            ),
            SizedBox(height: 5),
            SearchLocs(
              direction: 'to',
              locations: places,
            ),
            Expanded(
                child: Center(
                    child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //add time chooser
                MyStatefulWidget(
                  restorationId: "main",
                ), //proceed with boooking
                RawMaterialButton(
                  fillColor: Colors.lightBlue,
                  splashColor: Colors.white,
                  shape: StadiumBorder(),
                  onPressed: () {
                    print("clicked");
                    Navigator.pushNamed(context, "/matchingtrips");
                  },
                  child: Text("Search"),
                )
              ],
            ))),
          ],
        )),
        height: 180,
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
      body: Column(
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
    return Consumer<UserState>(
      builder: (context, value, child) => Column(
        children: [
          Text("Welcome !",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          Container(
            margin: EdgeInsets.all(30),
            child: CircleAvatar(
              child: Image.asset(
                "images/bus2.png",
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
