import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screens/payweb.dart';

void main() {
  runApp(Booking());
}

List<Ticket> booking = [];

class Booking extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Book(
        seat: seat,
      ),
    );
  }
}

class Book extends StatefulWidget {
  final Seat seat;
  Book({required this.seat});
  BookState createState() => BookState();
}

class BookState extends State<Book> {
  String message = "";
  bool bookingsuccess = false;
  String transactor = FirebaseAuth.instance.currentUser!.uid;
  bool showlist = false;
  var accesscode;
  var publicKey = 'pk_test_918f2ec666a735ac0d794543140aa9b13ce604d8';
  final plugin = PaystackPlugin();
  var seatids = [];
  int unitprice = 10;
  int chosen = 0;
  int total = 0;
  Color? seatcolor;
  Color? chosencolor;
  @override
  void initState() {
    seatcolor = Colors.grey;
    unitprice = widget.seat.unitprice;
    chosen = 0;
    total = chosen * unitprice;
    plugin.initialize(publicKey: publicKey);
    super.initState();
  }

  get gridDelegate => null;
  Color color = Colors.grey;
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                backgroundColor: Colors.white,
                centerTitle: true,
                title: ListTile(
                  subtitle: Text(message,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  title: Text(
                    "Complete booking",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                bottom: TabBar(tabs: [
                  Tab(
                    child: Text(
                      "Seating",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text("Pickup points",
                        style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child: Text("Routes and stops",
                        style: TextStyle(color: Colors.black)),
                  ),
                ])),
            body: TabBarView(children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("trips")
                    .doc(widget.seat.tripid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshots) {
                  if (!snapshots.hasData) {
                    return Text("Loading seats");
                  } else if (snapshots.hasData) {
                    print(snapshots.data!["chosen"]);
                  }
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: widget.seat.seats,
                      itemBuilder: (BuildContext ctx, index) {
                        seatids = snapshots.data!["chosen"];
                        return SizedBox(
                          height: 110,
                          width: 110,
                          child: FloatingActionButton.extended(
                            label: Text((index + 1).toString()),
                            icon: Icon(
                              Icons.chair,
                            ),
                            heroTag: index.toString(),
                            key: Key("Seat numbers" + index.toString()),
                            backgroundColor:
                                snapshots.data!["chosen"].contains(index)
                                    ? Colors.green[300]
                                    : seatcolor,
                            onPressed: () {

//verify transactors
// if (!snapshots.data!["chosen"].contains({index,transactor})) {
                               
//                                 }


                              if (!snapshots.data!["chosen"].contains(index)) {
                                setState(() {
                                  chosen += 1;
                                  total = (chosen * unitprice);
                                });

                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshap = await transaction
                                      .get(snapshots.data!.reference);
                                  transaction.update(freshap.reference, {
                                    "seats": (freshap["seats"] - 1),
                                    "chosen": FieldValue.arrayUnion([index])
                                  });
                                }).then((value) {
                                  setState(() {
                                    showlist = true;
                                  });
                                });
                              } else {
                                print("seat already chosen");
                                setState(() {
                                  chosen -= 1;
                                  total = (chosen * unitprice);
                                });
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshap = await transaction
                                      .get(snapshots.data!.reference);
                                  transaction.update(freshap.reference, {
                                    "seats": (freshap["seats"] + 1),
                                    "chosen": FieldValue.arrayRemove([index])
                                  });
                                }).then((value) {
                                  setState(() {
                                    showlist = true;
                                  });
                                });
                              }
                              showlist
                                  ? showModalBottomSheet(
                                      backgroundColor: Colors.indigo[100],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(50))),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.99,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Ticket Details",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(),
                                                    elevation: 10,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              "Number of seats : " +
                                                                  chosen
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white)),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: ListTile(
                                                              title:
                                                                  Text("Seats"),
                                                              subtitle:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: snapshots.data!["chosen"].length,
                                                                        itemBuilder: (BuildContext context, indx) {
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3.0),
                                                                            child:
                                                                                ListTile(
                                                                              tileColor: Colors.grey[200],
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                              title: Text((snapshots.data!["chosen"][indx] + 1).toString()),
                                                                              trailing: IconButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      snapshots.data!["chosen"].remove((indx));
                                                                                    });
                                                                                    print("cancel");
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons.cancel,
                                                                                    size: 30,
                                                                                    color: Colors.red,
                                                                                  )),
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: ButtonBar(children: [
                                                              FloatingActionButton
                                                                  .extended(
                                                                      onPressed:
                                                                          () {
                                                                        _getAccessCodeFrmInitialization(
                                                                                double.parse(total
                                                                                    .toString()),
                                                                                "sk_test_0846b828ca9fc48ec400aafbb07665d0be878d76",
                                                                                "createdliving1000@gmail.com")
                                                                            .then(
                                                                                (value) {
                                                                          setState(
                                                                              () {
                                 accesscode =value.data["authorization_url"].toString()+ "/" +value.data["access_code"].toString();
                                                                                
                                                                                
                                                                             
                                                                          });
                                                                           Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WebViewpg(pageurl: accesscode))
                      );
                                                                          print(accesscode +
                                                                              " " +
                                                                              value.data["authorization_url"].toString());
                                                                        }).catchError(
                                                                                (e) {
                                                                          print(e
                                                                              .toString());
                                                                        });
                                                                      },
                                                                      label: Text(
                                                                          "Momo")),
                                                              FloatingActionButton
                                                                  .extended(
                                                                      heroTag:
                                                                          "pay",
                                                                      onPressed:
                                                                          () async {
                                                                        Charge charge = Charge()
                                                                          ..amount = (total * 100)
                                                                          ..reference = Timestamp.now().toString()

                                                                          // or ..accessCode = _getAccessCodeFrmInitialization()
                                                                          ..email = FirebaseAuth.instance.currentUser!.email!
                                                                          ..putMetaData("payment by", "You");
                                                                        // CheckoutResponse
                                                                        //     response =
                                                                            await plugin
                                                                                .checkout(
                                                                          context,
                                                                          method:
                                                                              CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
                                                                          charge:
                                                                              charge,
                                                                        )
                                                                                .then((value) {
                                                                          setState(
                                                                              () {
                                                                            message =
                                                                                value.message;
                                                                          });
                                                                          return value;
                                                                        }).catchError((e) {
                                                                          setState(
                                                                              () {
                                                                            message =
                                                                                e.toString();
                                                                          });
                                                                          print(e +
                                                                              " Error occcured during payment");
                                                                        });

                                                                       
                                                                       

                                                                        setState(
                                                                            () {
                                                                          bookingsuccess =
                                                                              true;
                                                                        });
                                                                      },
                                                                      label: Text(
                                                                          "Card")),
                                                            ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : print("Waiting for new list");
                            },
                          ),
                        );
                      });
                },
              ),
              Column(
                children: [
                  Text("Pickup points"),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.seat.routes.length,
                      itemBuilder: (BuildContext context, index) {
                        return Text(widget.seat.routes[index].name);
                      })
                ],
              ),
              Column(
                children: [
                  Text("Routes and stops"),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.seat.routes.length,
                      itemBuilder: (BuildContext context, index) {
                        return Text(widget.seat.routes[index].name);
                      })
                ],
              )
            ])));
  }

  Widget itemBuilder(BuildContext context, int index) {
    return IconButton(
        color: color,
        onPressed: () {
          print(index);
          setState(() {
            color = Colors.green;
          });
        },
        icon: Icon(Icons.chair));
  }
}

class Ticket {
  Ticket(this.from, this.to, this.seatnumber, this.nofseats, this.time,
      this.total);
  int seatnumber;
  int nofseats;
  String from;
  String to;
  int time;
  int total;
}

class Initresponse {
  String message;
  Map<String, dynamic> data;
  bool status;
  Initresponse(
      {required this.message, required this.data, required this.status});

  factory Initresponse.fromJson(Map<String, dynamic> json) {
    return Initresponse(
        message: json["message"], data: json["data"], status: json["status"]);
  }
}

Future<Initresponse> _getAccessCodeFrmInitialization(
    double amount, String key, String email) async {
  final response = await http.post(
    Uri.parse("https://api.paystack.co/transaction/initialize"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $key',
    },
    body: jsonEncode(<String, dynamic>{'amount': amount, "email": email}),
  );

  if (response.statusCode == 200) {
// If the server did return a 200 ok response,
// then parse the JSON.
    return Initresponse.fromJson(jsonDecode(response.body));
  } else {
// If the server did not return a 201 CREATED response,
// then throw an exception.
    throw Exception('Failed to initialise transaction.');
  }
}



Future<Initresponse> verifytransaction(
    double amount, String key, String email) async {
  final response = await http.post(
    Uri.parse("https://api.paystack.co/transaction/initialize"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $key',
    },
    body: jsonEncode(<String, dynamic>{'amount': amount, "email": email}),
  );

  if (response.statusCode == 200) {
// If the server did return a 201 CREATED response,
// then parse the JSON.
    return Initresponse.fromJson(jsonDecode(response.body));
  } else {
// If the server did not return a 201 CREATED response,
// then throw an exception.
    throw Exception('Failed to create album.');
  }
}
