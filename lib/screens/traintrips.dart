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
                                children: snapshot.data!.docs.map((doc) {
                               

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: doc['date'].length,
                                            itemBuilder:
                                                (BuildContext context, idx) {
                                              return Text(doc['date'][idx]
                                                  .toDate()
                                                  .toString());
                                            }),
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
                                        Divider(
                                          thickness: 0.8,
                                          color: Colors.blueGrey,
                                        ),
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
                                                onPressed: () {
                                                 
                                                },
                                                child: Text("Book")))
                                      ],
                                    ),
                                  );
                                }).toList())
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
