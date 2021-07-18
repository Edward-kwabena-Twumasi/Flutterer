import 'package:flutter/material.dart';
import 'package:myapp/screens/homepage.dart';

void main() {
  runApp(Booking());
}

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
  get gridDelegate => null;
  Color color = Colors.grey;
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(250.0),
              child: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Container(
                    height: 50,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.asset(
                          "images/bus1.png",
                          fit: BoxFit.cover,
                        )),
                        Positioned(
                            top: 3,
                            left: 2,
                            child: Text(widget.seat.from,
                                style: TextStyle(color: Colors.black))),
                        Positioned(
                            top: 3,
                            right: 2,
                            child: Text(widget.seat.to,
                                style: TextStyle(color: Colors.black))),
                        Positioned(
                            bottom: 5,
                            right: 300,
                            child: Row(
                              children: [
                                Text(widget.seat.busnumber),
                                Text(widget.seat.tripid),
                                Text(widget.seat.unitprice.toString())
                              ],
                            )),
                      ],
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
            ),
            body: TabBarView(children: [
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: widget.seat.seats,
                  itemBuilder: (BuildContext ctx, index) {
                    return IconButton(
                        onPressed: () {}, icon: Icon(Icons.chair));
                  }),
              Text("Pickup "),
              Text("Routes"),
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
