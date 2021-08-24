import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/components/notifications.dart';
import 'package:myapp/components/notify.dart';
import 'package:myapp/main.dart';
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
int results = 0;
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
    Column(
      children: [Expanded(child: TabBarDemo()), Primary()],
    ),
    HelpClass(),
    Notifies(),
    UserInfoClass(),
  ];
  int currentindx = 0;

  void swithnav(int value) {
    setState(() {
      currentindx = value;
    });
  }

  Future<void> getSavetoken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  @override
  void initState() {
    super.initState();

    getSavetoken();
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
        body: pages.elementAt(currentindx),
      ),
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
            centerTitle: true,
            title: Text(
              "Book your trip",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
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
  bool wait = false;
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SearchLocs(
                  direction: 'from', locations: places, searchcontrol: from),
              SearchLocs(
                direction: 'to',
                locations: places,
                searchcontrol: to,
              ),
              InputFields("Travel date", datecontroller, Icons.date_range,
                  TextInputType.datetime),
              Expanded(
                  child: Center(
                      child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    heroTag: "getpos",
                    onPressed: () async {
                      setState(
                        () {
                          wait = true;
                        },
                      );
                      await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.best)
                          .then((value) async {
                        await placemarkFromCoordinates(
                                value.latitude, value.longitude)
                            .then((value2) {
                          from.text = value2.first.locality! +
                              "," +
                              value2.first.subLocality!;
                          setState(
                            () {
                              wait = false;
                            },
                          );
                          return value2;
                        });
                      });

                      setState(
                        () {
                          stripcity = true;
                        },
                      );
                    },
                    label: wait
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(""),
                    icon: Icon(Icons.location_on),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                        onetrip.triptype = widget.typeoftrip;
                        setState(() {
                          // widget.typeoftrip;
                        });
                        print("clicked for : " + widget.typeoftrip);
                        print(onetrip.date);
                        print(widget.typeoftrip +
                            onetrip.fromLoc +
                            onetrip.toLoc);
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

    // ignore: todo
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
  bool isfound = true;
  String filter1 = '';
  String filter2 = '';
  String getday(int tripday, int searchday) {
    String particular = "Today  ";
    List days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
      "Tomorrow"
    ];
    if ((tripday - searchday) == 1) {
      particular = days[7];
    } else {
      particular = days[tripday % 7];
    }

    return particular;
  }

  List filterquery = [];

  void initState() {
    super.initState();
    setState(() {
      filter1 = widget._tripdata.triptype;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "All trips for this location",
      routes: {"/completebook": (context) => Booking()},
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
          centerTitle: true,
          title: Row(
            children: [
              Text(
                "Search Results for  ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.lightBlue),
              ),
              DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.red,
                          width: 2,
                          style: BorderStyle.solid)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      widget._tripdata.triptype,
                      style: TextStyle(color: Colors.red),
                    ),
                  ))
            ],
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 50,
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("appstrings")
                        .doc("companynamestrings")
                        .get(),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData &&
                          (snapshot.connectionState ==
                              ConnectionState.waiting)) {
                        return Center(
                            child: Card(
                                elevation: 8,
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                )));
                      } else if (snapshot.hasError) {
                        print(snapshot.error.toString());
                        return Text(snapshot.error.toString());
                      }
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              snapshot.data!["companynamestrings"].length,
                          itemBuilder: (lcontext, index) {
                            filterquery.add(snapshot.data!["companynamestrings"]
                                [index]["name"]);
                            return snapshot.data!["companynamestrings"][index]
                                        ["type"] ==
                                    filter1
                                ? Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: niceChips(
                                        Icons.filter,
                                        snapshot.data!["companynamestrings"]
                                            [index]["name"], () {
                                      setState(() {
                                        filterquery = [
                                          snapshot.data!["companynamestrings"]
                                              [index]["name"]
                                        ];
                                      });
                                    }),
                                  )
                                : Text("");
                          });
                    }),
              ),
              ListTile(
                title: Center(child: Text("compare")),
                subtitle: Row(
                  children: [
                    niceChips(Icons.bus_alert, "Bus", () {
                      setState(() {
                        filter1 = 'Bus';
                      });
                    }),
                    niceChips(Icons.bus_alert, "Fligth", () {
                      setState(() {
                        filter1 = 'Fligth';
                      });
                    }),
                    niceChips(Icons.bus_alert, "Train", () {
                      setState(() {
                        filter1 = 'Train';
                      });
                    })
                  ],
                ),
              ),
              SingleChildScrollView(
                  child: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.red,
                            width: 1,
                            style: BorderStyle.solid)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          widget._tripdata.triptype +
                              "s " +
                              " from " +
                              widget._tripdata.fromLoc +
                              " to " +
                              widget._tripdata.toLoc,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                          )),
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('trips')
                          .where("from", isEqualTo: widget._tripdata.fromLoc)
                          .where("to", isEqualTo: widget._tripdata.toLoc)
                          .where("triptype", isEqualTo: filter1)
                          //.where("company", whereIn: filterquery)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData &&
                            (snapshot.connectionState ==
                                ConnectionState.waiting)) {
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
                          return Text(
                              "Sorry an error occured.Probably may be due to internet issues.Try again later");
                        } else if ((snapshot.connectionState ==
                                ConnectionState.done) &&
                            snapshot.data!.size < 1) {
                          return Text(
                              "Couldnt find matching results .Please try another search or contact us on 0501658160");
                        } else if (snapshot.hasData) {
                          return ListView(
                              shrinkWrap: true,
                              children: snapshot.data!.docs.map((doc) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  elevation: 5,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Text(doc['date']
                                                    .toDate()
                                                    .toString()
                                                    .split(" ")[0] ==
                                                DateTime.now()
                                                    .toString()
                                                    .split(" ")[0]
                                            ? "Today"
                                            : doc['date']
                                                    .toDate()
                                                    .month
                                                    .toString() +
                                                "/" +
                                                doc['date']
                                                    .toDate()
                                                    .day
                                                    .toString()),
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                                    doc['company'].toString())),
                                            Expanded(
                                              child: Text(
                                                  "                 Leaving - " +
                                                      doc['date']
                                                          .toDate()
                                                          .toString()
                                                          .split(" ")[1]),
                                            ),
                                          ],
                                        ),
                                        title: DecoratedBox(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: Colors.green)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  doc['seats'].toString() +
                                                      "  seats remaining"),
                                            )),
                                        trailing: FloatingActionButton(
                                            heroTag: "book",
                                            onPressed: () {
                                              for (var i = 0;
                                                  i < doc["interoutes"].length;
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
                                              seat.seats = (doc["seats"] +
                                                  doc["chosen"].length);
                                              seat.unitprice = doc["fare"];
                                              seat.tripid = doc.id.toString();
                                              print('clicked');
                                              Navigator.pushNamed(
                                                  context, "/completebook");
                                            },
                                            child: Text("Book")),
                                      )
                                    ],
                                  ),
                                );
                              }).toList());
                        }

                        return Text(
                          "No data found for search",
                          style: TextStyle(color: Colors.red),
                        );
                      }),
                ],
              )),
              ButtonBar(
                children: [
                  TextButton(onPressed: () {}, child: Text(" Morning ")),
                  TextButton(onPressed: () {}, child: Text("Afternoon ")),
                  TextButton(onPressed: () {}, child: Text(" Evening "))
                ],
              )
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
  String triptype;
  TripClass(this.fromLoc, this.toLoc, this.time, this.date, this.tripclass,
      this.triptype);
}

class HelpClass extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          "Help",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
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
  bool fetch = true;
  var starred = [];
  var healthinfo = [];
  void getopts() async {
    await FirebaseFirestore.instance
        .collection("appstrings")
        .doc("companynamestrings")
        .get();
  }

  String setname = "Name";
  bool notdone = true;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => App()),
                  );
                });
              },
              icon: Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData &&
                  (snapshot.connectionState == ConnectionState.waiting)) {
                return Center(
                    child: Card(
                        elevation: 8,
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 5,
                            ),
                            Text("fetching info")
                          ],
                        )));
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }

              return Column(
                children: [
                  ElevatedButton(onPressed: (){}, child: Text("My bookings"),
                  style: ButtonStyle(
textStyle:MaterialStateProperty.all(TextStyle(color:Colors.black )),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                   side:MaterialStateProperty.all(BorderSide(
                     color:Colors.green,style: BorderStyle.solid
                   ))
                  ),
                  ),
                   Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Container(
                            color: Colors.amber,
                            height: 100,
                            width: 100,
                            child: Stack(children: [
                              Image.network("imgUrl!",
                                  cacheHeight: 120, cacheWidth: 120),
                              Positioned(
                                  right: 5,
                                  bottom: 2,
                                  child: DecoratedBox(
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconButton(
                                          onPressed: () async {
                                            final picker = ImagePicker();
                                            XFile? image;
                                            image = await picker.pickImage(
                                                source: ImageSource.gallery);

                                            var file = File(image!.path);

                                            // ignore: unnecessary_null_comparison
                                            if (file != null) {
                                              var snapshot =
                                                  await FirebaseStorage.instance
                                                      .ref(FirebaseAuth.instance
                                                              .currentUser!.uid
                                                              .substring(0, 5) +
                                                          "profile")
                                                      .child("profpic")
                                                      .putFile(file)
                                                      .whenComplete(() {
                                                setState(() {
                                                  notdone = false;
                                                });
                                                print("done");
                                              });
                                              var geturl = await snapshot.ref
                                                  .getDownloadURL();
                                              setState(() {
                                                imgUrl = geturl;
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.photo_camera)),
                                    ),
                                  ))
                            ])),
                      ),
                    ),
                  
                  Center(
                      child: ExpansionTile(title: Text("Health Information"))),
                  Padding(
                      padding: EdgeInsets.all(12),
                      child: ListView(shrinkWrap: true, children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 10,
                          child: ListTile(
                              title: Text("Name"),
                              subtitle: Text(snapshot.data["full_name"]),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit_attributes))),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 10,
                          child: ListTile(
                              title: Text("Email"),
                              subtitle: Text(snapshot.data["contact"]["email"]),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit_attributes))),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 10,
                          child: ListTile(
                              title: Text("Phone"),
                              subtitle: Text(snapshot.data["contact"]["phone"]),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit_attributes))),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 10,
                          child: ListTile(
                              title: Text("Address"),
                              subtitle: ExpansionTile(
                                  title: Text("Adress info"),
                                  children: [
                                    ListTile(
                                        title: Text("Region"),
                                        subtitle: Text(
                                            snapshot.data["address"]["region"]),
                                        trailing: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.edit_attributes))),
                                    ListTile(
                                        title: Text("City"),
                                        subtitle: Text(
                                            snapshot.data["address"]["city"]),
                                        trailing: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.edit_attributes))),
                                    ListTile(
                                        title: Text("House Address"),
                                        subtitle: Text(
                                            snapshot.data["address"]["house"]),
                                        trailing: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.edit_attributes))),
                                  ])),
                        ),
                      ])),
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
                                heightFactor: 0.9,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Rate",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35),
                                      ),
                                      FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection("appstrings")
                                              .doc("companynamestrings")
                                              .get(),
                                          builder: (context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            if (!snapshot.hasData &&
                                                (snapshot.connectionState ==
                                                    ConnectionState.waiting)) {
                                              return Center(
                                                  child: Card(
                                                      elevation: 8,
                                                      child: Column(
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(
                                                            height: 5,
                                                          )
                                                        ],
                                                      )));
                                            } else if (snapshot.hasError) {
                                              print(snapshot.error.toString());
                                              return Text(
                                                  snapshot.error.toString());
                                            }
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshot
                                                    .data["companynames"]
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext, ndx) {
                                                  return ListTile(
                                                      title: snapshot.data[
                                                              "companynames"]
                                                          [ndx]["name"],
                                                      subtitle: Expanded(
                                                          child: ListTile(
                                                              title: ListView
                                                                  .builder(
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemCount:
                                                                          stars,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return StatefulBuilder(
                                                                          builder:
                                                                              (context, setState) {
                                                                            return Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: IconButton(
                                                                                  onPressed: () {
                                                                                    if (!starred.contains(index)) {
                                                                                      setState(() {
                                                                                        starred.add(index);

                                                                                        // stars;
                                                                                      });

                                                                                      print(starred.length);
                                                                                      print(starredcolor);
                                                                                      print(index);
                                                                                    } else {
                                                                                      setState(() {
                                                                                        starred.remove(index);
                                                                                        print(starred.length);
                                                                                        // stars;
                                                                                        print(starredcolor);
                                                                                        print(index);
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  icon: Icon(Icons.star, size: 30, color: starred.contains(index) ? starredcolor : unstarredcolor)),
                                                                            );
                                                                          },
                                                                        );
                                                                      }))));
                                                });
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      label: Text("Rate",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
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
                                child: Column(
                                  children: [
                                    Text("Write review"),
                                    FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection("appstrings")
                                            .doc("companynamestrings")
                                            .get(),
                                        builder: (context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (!snapshot.hasData &&
                                              (snapshot.connectionState ==
                                                  ConnectionState.waiting)) {
                                            return Center(
                                                child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        CircularProgressIndicator(),
                                                        SizedBox(
                                                          height: 5,
                                                        )
                                                      ],
                                                    )));
                                          } else if (snapshot.hasError) {
                                            print(snapshot.error.toString());
                                            return Text(
                                                snapshot.error.toString());
                                          }
                                          return ListView.builder(
                                              itemBuilder: (buildcontext, ndx) {
                                            return ListTile(
                                               title: snapshot.data[
                                                              "companynames"]
                                                          [ndx]["name"],
                                                          subtitle:Text("Write review here")
                                            );
                                          });
                                        })
                                  ],
                                ),
                              );
                            });
                      },
                      label: Text("Rreview",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ))
                  ]),

                ],
              );
            }),
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

class User {
  String name;
  Map address;
  Map contact;

  Map healthinfo;
  User(this.name, this.address, this.contact, this.healthinfo);
}

class Primary extends StatefulWidget {
  const Primary({Key? key}) : super(key: key);

  @override
  _PrimaryState createState() => _PrimaryState();
}

class _PrimaryState extends State<Primary> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7, 0.8],
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        height: 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: FloatingActionButton.extended(
                      heroTag: "policy",
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
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
                                  heightFactor: 0.9, child: Policy());
                            });
                      },
                      label: Text("Policy",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)))),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: FloatingActionButton.extended(
                      heroTag: "offers",
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
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
                                  heightFactor: 0.9, child: Offers());
                            });
                      },
                      label: Text(" offers",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)))),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: FloatingActionButton.extended(
                    heroTag: "seemap",
                    onPressed: () {
                      Navigator.pushNamed(context, "/map");
                    },
                    label: Text("Map View"))),
          ],
        ));
  }
}
