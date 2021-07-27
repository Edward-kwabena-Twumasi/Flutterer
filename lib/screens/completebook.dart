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
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Card(
                  elevation: 20,
                  child: ListTile(
                    leading: Text(widget.seat.to,
                        style: TextStyle(color: Colors.black)),
                    trailing: Text(widget.seat.to,
                        style: TextStyle(color: Colors.black)),
                    title: Image.asset(
                      "images/bus1.png",
                      fit: BoxFit.cover,
                    ),
                    subtitle: Row(
                      children: [
                        Text("Bus number" + widget.seat.busnumber),
                        Text(" Trip id" + widget.seat.tripid),
                        Text(" Unit price" + widget.seat.unitprice.toString())
                      ],
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
            body: 
                TabBarView(children: [
                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10),
                      itemCount: widget.seat.seats,
                      itemBuilder: (BuildContext ctx, index) {
                        return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          leading: Text(index.toString()),
                          title: Icon(
                            Icons.chair,
                            size: 30,
                          ),
                        );
                      }),
                  Text("Pickup "),
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
