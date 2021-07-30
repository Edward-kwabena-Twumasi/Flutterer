import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

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
  Seat seat;
  Book({required this.seat});
  BookState createState() => BookState();
}

class BookState extends State<Book> {
  var publicKey = 'pk_test_918f2ec666a735ac0d794543140aa9b13ce604d8';
  final plugin = PaystackPlugin();

  int? unitprice;
  int? chosen;
  int? total;
  Color? seatcolor;
  @override
  void initState() {
    seatcolor = Colors.grey;
    unitprice = widget.seat.unitprice;
    chosen = 0;
    total = chosen! * unitprice!;
    plugin.initialize(publicKey: publicKey);
    super.initState();
  }

  get gridDelegate => null;
  Color color = Colors.grey;
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          floatingActionButton: ListTile(
            tileColor: Colors.white,
            leading: Text(widget.seat.from),
            trailing: Text(widget.seat.to),
            title: Text("Fare  : " + unitprice.toString()),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Text("Chosen : " + chosen.toString()),
                    Text(" Total : " + total.toString()),
                  ],
                ),
                Center(
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50))),
                            context: context,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.95,
                                child: Column(
                                  children: [
                                    Text("Ticket Details"),
                                    FloatingActionButton.extended(
                                        onPressed: () async {
                                          Charge charge = Charge()
                                            ..amount = 10000
                                            ..reference =
                                                Timestamp.now().toString()
                                            // or ..accessCode = _getAccessCodeFrmInitialization()
                                            ..email = FirebaseAuth
                                                .instance.currentUser!.email
                                            ..accessCode = FirebaseAuth
                                                .instance.currentUser!.uid
                                                .substring(1, 2);
                                          CheckoutResponse response =
                                              await plugin
                                                  .checkout(
                                            context,
                                            method: CheckoutMethod
                                                .selectable, // Defaults to CheckoutMethod.selectable
                                            charge: charge,
                                          )
                                                  .catchError((e) {
                                            print(e);
                                          });
                                        },
                                        label: Text("Pay now"))
                                  ],
                                ),
                              );
                            });
                      },
                      label: Text("Get Ticket")),
                )
              ],
            ),
          ),
          appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text("Complete booking"),
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
                    key: Key(index.toString()),
                    backgroundColor: seatcolor,
                    onPressed: () {},
                    label: Text(index.toString()),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    icon: Icon(
                      Icons.chair,
                      size: 30,
                    ),
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
            Text("Routes"),
          ]),
        ));
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
