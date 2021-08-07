import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/homepage.dart';
//import 'package:flutter_paystack/flutter_paystack.dart';

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
  var publicKey = 'pk_test_918f2ec666a735ac0d794543140aa9b13ce604d8';
  //final plugin = PaystackPlugin();
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
   // plugin.initialize(publicKey: publicKey);
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
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10),
                  itemCount: widget.seat.seats,
                  itemBuilder: (BuildContext ctx, index) {
                    return FloatingActionButton.extended(
                      label: Text((index + 1).toString()),
                      icon: Icon(
                        Icons.chair,
                      ),
                      heroTag: index.toString(),
                      key: Key("Seat numbers" + index.toString()),
                      backgroundColor: seatids.contains(index)
                          ? Colors.green[300]
                          : seatcolor,
                      onPressed: () {
                        print(index);
                        if (!seatids.contains(index)) {
                          setState(() {
                            seatids.add(index);
                            chosen += 1;
                            total = (chosen * unitprice);
                            chosencolor;
                            seatcolor;
                          });
                          FirebaseFirestore.instance
                              .collection("trips")
                              .doc(widget.seat.tripid)
                              .update({"seats": (widget.seat.seats - chosen)});
                        } else {
                          print("seat already chosen");
                          setState(() {
                            seatids.remove(index);
                            chosen -= 1;
                            total = (chosen * unitprice);
                          });
                          FirebaseFirestore.instance
                              .collection("trips")
                              .doc(widget.seat.tripid)
                              .update({"seats": (widget.seat.seats + chosen)});
                        }
                        showModalBottomSheet(
                            barrierColor: Colors.indigo[100],
                            backgroundColor: Colors.indigo[200],
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Ticket Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white  ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SingleChildScrollView(
                                          child: Card(
                                            shape: RoundedRectangleBorder(),
                                            elevation: 10,
                                            child: SingleChildScrollView(
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  Text(
                                                      "Number of seats : " +
                                                          chosen.toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: Colors.white)),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ListTile(
                                                      title: Text("Seats"),
                                                      subtitle:
                                                          SingleChildScrollView(
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                seatids.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    indx) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: ListTile(
                                                                  tileColor:
                                                                      Colors.grey[
                                                                          200],
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  title: Text(
                                                                      (seatids[indx] +
                                                                              1)
                                                                          .toString()),
                                                                  trailing:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              seatids.remove((indx));
                                                                            });
                                                                            print("cancel");
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.cancel,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Colors.red,
                                                                          )),
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(),
                                      FloatingActionButton.extended(
                                          heroTag: "pay",
                                          onPressed: () async {
                                            // Charge charge = Charge()
                                            //   ..amount = (total * 100)
                                            //   // ..bearer=Bearer.Account
                                              
                                            //   ..reference =
                                            //       Timestamp.now().toString()
                                                  
                                            //   // or ..accessCode = _getAccessCodeFrmInitialization()
                                            //   ..email = FirebaseAuth
                                            //       .instance.currentUser!.email
                                            //   ..accessCode = FirebaseAuth
                                            //       .instance.currentUser!.uid
                                            //       .substring(1, 2)
                                            //       ..putMetaData("payment by", "You")
                                               
                                            //       ;
                                            // CheckoutResponse response =
                                            //     await plugin
                                            //         .checkout(
                                            //   context,
                                            //   method: CheckoutMethod
                                            //       .selectable, // Defaults to CheckoutMethod.selectable
                                            //   charge: charge,
                                            // )
                                            //         .then((value) {
                                            //   setState(() {
                                            //     message = value.message;
                                            //   });
                                            //   return value;
                                            // }).catchError((e) {
                                            //   setState(() {
                                            //     message = e.toString();
                                            //   });
                                            //   print(e +
                                            //       " Error occcured during payment");
                                            // });

                                            // print(response.message);
                                            // print(response.reference);
                                            // print(response.status);

                                            // showDialog(
                                            //     context: context,
                                            //     builder:
                                            //         (BuildContext context) {
                                            //       return Material(
                                            //         child: ListTile(
                                            //             title: Text(
                                            //                 "Payment Successful!")),
                                            //       );
                                            //     });

                                            setState(() {
                                              bookingsuccess = true;
                                            });
                                          },
                                          label: Text("Pay now"))
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  }),
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
