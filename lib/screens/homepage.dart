import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/screens/chatscreen.dart';

import 'package:myapp/screens/completebook.dart';
import 'package:myapp/screens/reportscreen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providersPool/userStateProvider.dart';

import 'package:myapp/components/getlocation.dart';

import 'package:geocoding/geocoding.dart';

import 'googlemap.dart';

enum companyFilters { VIP, STC, MMT }
enum queryFilters { isEqualTo }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => UserState(), builder: (context, _) => ButtomNav()));
}

// TripClass onetrip =
//     TripClass("Obuasi", "Obuasi", "10:00", "20 10 2021", "normal");
List triptype = ["Bus", "Flight", "Train"];
List<String> places = ["Kumasi", "Obuasi", "Accra", "Kasoa", "Mankessim", "Wa"];
List<Interoutes> routes = [];
Seat seat = Seat("busnumber", 30, 20, "from", "to", "tripid", routes);

Timestamp now = Timestamp.now();
DateTime time =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
TextEditingController datecontroller = TextEditingController();

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
        "/matchingtrips": (context) => Trips(onetrip, triptype[1]),
        "/location": (context) => GeolocatorWidget(),
        "/completebook": (context) => Booking(),
        "/reports": (context) => Reporter(),
        "/map": (context) => Mymap(),
        "/chat": (context) => ChatApp()
      },
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
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

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  TabBarDemoState createState() => TabBarDemoState();
}

class TabBarDemoState extends State<TabBarDemo> {
  List<String> typelist = ["Local", "International"];
  List<String> returnlist = ["Retrun trip", "One Time"];
  void initState() {
    initialreturn = returnlist[0];
    initialtype = typelist[0];
    super.initState();
  }

  String? initialreturn;
  String? initialtype;

  void typeaction(String? choice) {
    setState(() {
      initialtype = choice;
    });
  }

  void returnaction(String? choice) {
    setState(() {
      initialreturn = choice;
    });
  }

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
            Container(
              height: 900,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bus1.png'), fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Locations(typeoftrip: triptype[0]),
                  ],
                ),
              ),
            ),

            //Block for Buses
            Container(
              height: 900,
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bus1.png'), fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Locations(typeoftrip: triptype[2]),
                  ],
                ),
              ),
            ),

            //Block for trains

            Container(
              height: 900,
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/train1.png'), fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 5, right: 5, bottom: 3),
                      child: Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Expanded(
                                child: OptionButton(
                                    options: typelist,
                                    onchange: typeaction,
                                    dropdownValue: initialtype!)),
                            Expanded(
                                child: OptionButton(
                                    options: returnlist,
                                    onchange: returnaction,
                                    dropdownValue: initialreturn!))
                          ],
                        ),
                      ),
                    ),
                    Locations(typeoftrip: triptype[1]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Locations extends StatefulWidget {
  const Locations({Key? key, required this.typeoftrip}) : super(key: key);

  final String typeoftrip;
  @override
  LocationsState createState() => LocationsState();
}

class LocationsState extends State<Locations> {
  bool stripcity = false;
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();

  void initState() {
    super.initState();
    datecontroller.text = time.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "getpos",
                        onPressed: () async {
                          var position = await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.best)
                              .then((value) async {
                            var address = await placemarkFromCoordinates(
                                    value.latitude, value.longitude)
                                .then((value2) {
                              from.text = value2.first.locality! +
                                  "," +
                                  value2.first.subLocality!;
                              return value2;
                            });
                          });

                          setState(
                            () {
                              stripcity = true;
                            },
                          );
                        },
                        label: Text("Current loc"),
                        icon: Icon(Icons.location_on),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Expanded(
                          child: FloatingActionButton.extended(
                              heroTag: "seemap",
                              onPressed: () {
                                Navigator.pushNamed(context, "/map");
                              },
                              label: Text("view  map")))
                    ],
                  ),
                ),
              ),
              SearchLocs(
                  direction: 'from', locations: places, searchcontrol: from),
              SizedBox(height: 5),
              SearchLocs(
                direction: 'to',
                locations: places,
                searchcontrol: to,
              ),
              SizedBox(height: 5),
              InputFields("Travel date", datecontroller, Icons.date_range,
                  TextInputType.datetime),
              Expanded(
                  child: Center(
                      child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //add time chooser
                  SizedBox(
                    height: 40,
                    child: MyStatefulWidget(
                      restorationId: "main",
                    ),
                  ), //proceed with boooking
                  SizedBox(
                    height: 40,
                    child: FloatingActionButton(
                      heroTag: "dosearch",
                      splashColor: Colors.white,
                      shape: StadiumBorder(),
                      onPressed: () {
                        stripcity
                            ? onetrip.fromLoc = from.text.split(",")[0].trim()
                            : onetrip.fromLoc = from.text.trim();
                        onetrip.toLoc = to.text;
                        setState(() {
                          widget.typeoftrip;
                        });
                        print("clicked for : " + widget.typeoftrip);
                        print(onetrip.date);
                        print(widget.typeoftrip +onetrip.fromLoc+onetrip.toLoc);
                        Navigator.pushNamed(context, "/matchingtrips");
                      },
                      child: Text("Search"),
                    ),
                  )
                ],
              ))),
            ],
          ),
        )),
        height: 400,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(3));

    // TODO: implement build
  }
}

//primary actions

/// This is the stateful widget that the main application instantiates.

//trips class to list trips serached for
class Trips extends StatefulWidget {
  final String triptype;
  final TripClass _tripdata;
  const Trips(this._tripdata, this.triptype);
  @override
  TripsState createState() => TripsState();
}

class TripsState extends State<Trips> {
  // String gttriptype ;
  companyFilters filter = companyFilters.VIP;
  bool isfound = true;
  int results = 0;
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
          title: Text("Trips Search Results "),
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
                  child: Column(
                children: [
                  Text(
                      widget.triptype +
                          "s " +
                          " from " +
                          widget._tripdata.fromLoc +
                          " to " +
                          widget._tripdata.toLoc +
                          " . " +
                          results.toString() +
                          " found",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('trips')
                          .where("from", isEqualTo: widget._tripdata.fromLoc)
                          .where("to", isEqualTo: widget._tripdata.toLoc)
                          //  .where("company", whereIn: filterquery)
                           .where("triptype", isEqualTo: widget.triptype)
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
                          print(snapshot.data!.size);
                          // ignore: unnecessary_statements
                          results = snapshot.data!.size;
                          isfound = true;
                        } else if (snapshot.data!.size < 1) {
                          isfound = false;
                        }
                        return isfound
                            ? ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs.map((doc) {
                                  results += 1;
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        // ListView.builder(
                                        //     shrinkWrap: true,
                                        //     itemCount: doc['date'].length,
                                        //     itemBuilder:
                                        //         (BuildContext context, idx) {
                                        //       return Text(doc['date'][idx]
                                        //           .toDate()
                                        //           .toString());
                                        //     }),
                                        ListTile(
                                            title: Row(
                                              children: [
                                                Text(doc['from'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        backgroundColor:
                                                            Colors.amber,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text("  to   "),
                                                Text(doc['to'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        backgroundColor:
                                                            Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            subtitle: Text(doc['company'])),
                                        ListTile(
                                            trailing: Text(
                                                doc['fare'].toString() + ' Cdz',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.lightBlue)),
                                            leading: Icon(
                                              Icons.chair,
                                              size: 40,
                                            ),
                                            title: Text(
                                                doc['seats'].toString() +
                                                    " Available"),
                                            subtitle: FloatingActionButton(
                                                heroTag: "book",
                                                onPressed: () {
                                                  for (var i = 0;
                                                      i <
                                                          doc["interoutes"]
                                                              .length;
                                                      i++) {
                                                    routes.add(Interoutes(
                                                        doc["interoutes"][i]
                                                            ['routename'],
                                                        doc['interoutes'][i]
                                                            ['pickup'],
                                                        doc['interoutes'][i]
                                                            ['stop']));
                                                  }
                                                  seat.vehid = doc["vehid"];
                                                  seat.from = doc["from"];
                                                  seat.to = doc["to"];
                                                  seat.seats = doc["seats"];
                                                  seat.unitprice = doc["fare"];
                                                  seat.tripid =
                                                      doc.id.toString();
                                                  print('clicked');
                                                  Navigator.pushNamed(
                                                      context, "/completebook");
                                                },
                                                child: Text("Book")))
                                      ],
                                    ),
                                  );
                                }).toList())
                            : Text("Couldnt find matching search");
                      }),
                ],
              )),
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
  DateTime time;
  DateTime date;
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
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FloatingActionButton.extended(
                heroTag: "cheap",
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                label: Text("Booking assistant"),
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
        time = DateTime(_selectedDate.value.year, _selectedDate.value.month,
            _selectedDate.value.day);
        datecontroller.text = time.toString();
        onetrip.date = DateTime(_selectedDate.value.year,
            _selectedDate.value.month, _selectedDate.value.day);
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
  Color starredcolor = Colors.red;
  Color unstarredcolor = Colors.grey;
  int stars = 5;
  var starred = [];
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
        builder: (context, value, child) => SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Container(
                      color: Colors.amber,
                      height: 100,
                      width: 100,
                      child: Stack(children: [
                        Positioned.fill(child: Text("Hi")),
                        Positioned(
                            right: 5,
                            bottom: 2,
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.photo_camera)))
                      ])),
                ),
              ),
              Center(
                  child: FloatingActionButton.extended(
                onPressed: () {},
                label: Text("Health info"),
                icon: Icon(Icons.local_hospital),
              )),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 10,
                child: ListTile(
                  title: Text("Email"),
                  subtitle: Text(value.loggedinmail.toString()),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 10,
                child: ListTile(
                  title: Text("Phone"),
                  subtitle: Text(value.loggedinmail.toString()),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 10,
                child: ListTile(
                    title: Text("Address"),
                    subtitle:
                        ExpansionTile(title: Text("Adress info"), children: [
                      ListTile(
                        title: Text("Region"),
                        subtitle: Text(value.loggedinmail.toString()),
                      ),
                      ListTile(
                        title: Text("City"),
                        subtitle: Text(value.loggedinmail.toString()),
                      ),
                      ListTile(
                        title: Text("House Address"),
                        subtitle: Text(value.loggedinmail.toString()),
                      ),
                    ])),
              ),
              Row(children: [
                Expanded(
                    child: FloatingActionButton.extended(
                  heroTag: "rate",
                  icon: Icon(Icons.star),
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.amber[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                            heightFactor: 0.5,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Rate",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35),
                                  ),
                                  Expanded(
                                      child: ListTile(
                                          title: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: stars,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          setState) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            if (!starred
                                                                .contains(
                                                                    index)) {
                                                              setState(() {
                                                                starred
                                                                    .add(index);

                                                                stars;
                                                              });

                                                              print(starred
                                                                  .length);
                                                              print(
                                                                  starredcolor);
                                                              print(index);
                                                            } else {
                                                              setState(() {
                                                                starred.remove(
                                                                    index);
                                                                print(starred
                                                                    .length);
                                                                stars;
                                                                print(
                                                                    starredcolor);
                                                                print(index);
                                                              });
                                                            }
                                                          },
                                                          icon: Icon(Icons.star,
                                                              size: 30,
                                                              color: starred
                                                                      .contains(
                                                                          index)
                                                                  ? starredcolor
                                                                  : unstarredcolor)),
                                                    );
                                                  },
                                                );
                                              })))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  label: Text("Rate",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )),
                Expanded(
                    child: FloatingActionButton.extended(
                  heroTag: "review",
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.amber[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                            child: Text("Write review"),
                          );
                        });
                  },
                  label: Text("Rreview",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ))
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class Seat {
  String vehid;
  int seats;
  int unitprice;
  String from;
  String to;
  String tripid;
  List<Interoutes> routes;
  Seat(this.vehid, this.seats, this.unitprice, this.from, this.to, this.tripid,
      this.routes);
}

class Interoutes {
  String name;
  bool stop;
  bool pickup;

  Interoutes(this.name, this.pickup, this.stop);
}
