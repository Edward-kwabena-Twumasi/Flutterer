import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/AgentsList.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => UserState(), builder: (context, _) => ButtomNav()));
}

class ButtomNav extends StatefulWidget {
  @override
  ButtomNavState createState() => ButtomNavState();
}

class ButtomNavState extends State<ButtomNav> {
  static List<Widget> pages = [
    TabBarDemo(),
    HelpClass(),
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
      routes: {"/matchingtrips": (context) => Trips("Bus")},
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
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
              ]),
          appBar: AppBar(
            title: Text("TravellersApp"),
          ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    locations(),
                    Expanded(
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
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: [
                                            SearchLocs("from"),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SearchLocs("to")
                                          ]);
                                        });
                                  },
                                  label: Text("Available Seats")),
                              FloatingActionButton.extended(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: [
                                            SearchLocs("from"),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SearchLocs("to")
                                          ]);
                                        });
                                  },
                                  label: Text("Recent activity")),
                              FloatingActionButton.extended(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(children: [
                                            SearchLocs("from"),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SearchLocs("to")
                                          ]);
                                        });
                                  },
                                  label: Text("Change")),
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
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(children: [
                                              SearchLocs("from"),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SearchLocs("to")
                                            ]);
                                          });
                                    },
                                    label: Text("Find company")),
                                FloatingActionButton.extended(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(children: [
                                              SearchLocs("from"),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SearchLocs("to")
                                            ]);
                                          });
                                    },
                                    label: Text("Contact")),
                              ],
                            )),
                        Container(
                            height: 60,
                            padding: EdgeInsets.all(5),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                FloatingActionButton.extended(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(children: [
                                              SearchLocs("from"),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SearchLocs("to")
                                            ]);
                                          });
                                    },
                                    label: Text("Get advice")),
                              ],
                            )),
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  locations(),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  locations(),
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
            SearchLocs("From"),
            SizedBox(height: 5),
            SearchLocs("To"),
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

class SearchLocs extends StatefulWidget {
  SearchLocs(this.direction);
  String direction;
  @override
  SearchLocsState createState() => SearchLocsState();
}

class SearchLocsState extends State<SearchLocs> {
  late OverlayEntry myoverlay;
  late bool hideoverlay;
  var mytripobj = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formcontrol.addListener(() {
      suggestions = [];
      var query = formcontrol.text;
      hideoverlay = false;
      if (query.isNotEmpty) {
        for (var i in places) {
          if (i.toLowerCase().contains(query.toLowerCase()) ||
              i.toLowerCase().startsWith(query)) {
            suggestions.add(i);

            this.myoverlay = this.createOverlay();
            Overlay.of(context)!.insert(this.myoverlay);
          }
        }

        setState(() {
          suggestions.toList();
          hideoverlay = false;
        });
      } else {
        print(formcontrol.text);
        setState(() {
          hideoverlay = true;
        });
      }
    });
  }

  OverlayEntry createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5.0,
              width: size.width,
              child: Material(
                elevation: 4.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        key: Key(index.toString()),
                        onTap: () {
                          if (myoverlay.mounted) {
                            createOverlay().remove();
                          }

                          print(suggestions[index]);
                          mytripobj[widget.direction] = suggestions[index];
                          formcontrol.text = suggestions[index];
                          print(mytripobj);
                          setState(() {
                            hideoverlay = true;
                          });
                        },
                        title: Text(
                          suggestions[index],
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w300),
                        ));
                  },
                ),
              ),
            ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<String> places = [
    "kumasi",
    "obuasi",
    "accra",
    "Accra",
    "Kasoa",
    "Mankessim"
  ];
  List<String> suggestions = [];

  TextEditingController formcontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Ink(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.pink[300]),
                child: Icon(Icons.arrow_right)),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Travel From",
                    fillColor: Colors.pink,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))),
                controller: formcontrol,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

//trips class to list trips serached for
class Trips extends StatefulWidget {
  String triptype;
  Trips(this.triptype);
  @override
  TripsState createState() => TripsState();
}

class TripsState extends State<Trips> {
  // String gttriptype ;
  List<TripClass> list = [
    TripClass("Kumasi", "Obuasi", "10:00", "20 10 2021", "normal"),
    TripClass("Kumasi", "Accra", "10:00", "20 10 2021", "normal"),
    TripClass("Kumasi", "Sunyani", "10:00", "20 10 2021", "normal"),
    TripClass("Accra", "Obuasi", "10:00", "20 10 2021", "normal"),
    TripClass("Mankessim", "Obuasi", "10:00", "20 10 2021", "normal"),
    TripClass("Ho", "Obuasi", "10:00", "20 10 2021", "normal"),
    TripClass("Kumasi", "Kasoa", "10:00", "20 10 2021", "normal"),
    TripClass("Kumasi", "Obuasi", "10:00", "20 10 2021", "normal"),
  ];

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "All trips for this location",
      home: Scaffold(
        appBar: AppBar(
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
                          child: niceChips(
                            Icons.all_out,
                            "All",
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(6, 1, 6, 1),
                          child: niceChips(
                            Icons.all_out,
                            "VVIP",
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(6, 1, 6, 1),
                          child: niceChips(
                            Icons.all_out,
                            "STC",
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(6, 1, 6, 1),
                          child: niceChips(
                            Icons.all_out,
                            "METRO MASS",
                          )),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('trips')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: Card(
                                  elevation: 8,
                                  child: CircularProgressIndicator()));
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                        } else {
                          print(snapshot.connectionState);
                          print(snapshot.data!.size);
                        }
                        return ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((doc) => Card(
                                      elevation: 5,
                                      child: ListTile(
                                        title: Text(
                                            doc['from'] + " -->" + doc['to']),
                                      ),
                                    ))
                                .toList());
                      })),
            ]),
          ),
        ),
      ),
    );
  }

//   Widget builder(BuildContext context, AsyncSnapshot snapshot) {

//     if (!snapshot.hasData) {
//       return Center(child: CircularProgressIndicator());
//     } else if (snapshot.hasError) {
//       print(snapshot.error);
//     }
//     return ListView(
//         children:snapshot.data
//             .map((doc) => Card(
//                   elevation: 5,
//                   child: ListTile(
//                     title: Text(doc['from'] + " -->" + doc['to']),
//                   ),
//                 ))
//             .toList());
//   }
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton.extended(
            onPressed: () {},
            label: Text("Make a cheap travel"),
            icon: Icon(Icons.money),
          ),
          SizedBox(height: 40),
          FloatingActionButton.extended(
              onPressed: () {},
              label: Text("Where am i?"),
              icon: Icon(Icons.location_on)),
          SizedBox(height: 40),
          FloatingActionButton.extended(
            onPressed: () {},
            label: Text("Report a matter"),
            icon: Icon(Icons.report_problem),
          ),
          SizedBox(height: 40),
          FloatingActionButton.extended(
            onPressed: () {},
            label: Text("My Health"),
            icon: Icon(Icons.health_and_safety),
          ),
        ]);
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// RestorationProperty objects can be used because of RestorationMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
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
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021, 1, 1),
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
  // if (UserState().userState() == userStates.successful) {
  //     setState(() {
  //       setemail = FirebaseAuth.instance.currentUser!.email;
  //       setname = FirebaseAuth.instance.currentUser!.displayName;
  //       print("you are logged in" + UserState().loddedInAs.toString());
  //     });
  //   } else
  //     print("you gotta login");

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, value, child) => Column(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
                elevation: 10,
                child: Image.asset(
                  "images/bus2.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            child: ListTile(
              title: Text("Name"),
              subtitle: Text(value.loggedInAs.toString()),
              leading: CircleAvatar(
                backgroundImage: NetworkImage("url"),
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
                backgroundImage: NetworkImage("url"),
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
                backgroundImage: NetworkImage("url"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
