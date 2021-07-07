import 'package:flutter/material.dart';

void main() {
  runApp(Booking());
}

class Booking extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Book(),
    );
  }
}

class Book extends StatefulWidget {
  BookState createState() => BookState();
}

class BookState extends State<Book> {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset("images/bus1")),
              Positioned(top: 30, left: 2, child: Text("Obuasi")),
              Positioned(top: 30, right: 2, child: Text("Kumasi"))
            ],
          ),
        ),
        TabBar(tabs: [
          Tab(
            child: Text("Seating"),
          ),
          Tab(
            child: Text("Pick Up points"),
          ),
          Tab(
            child: Text("Routes and Stops"),
          )
        ])
      ],
    );
  }
}
