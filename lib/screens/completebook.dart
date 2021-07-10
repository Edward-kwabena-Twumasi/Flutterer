import 'package:flutter/material.dart';

void main() {
  runApp(Booking());
}

class Booking extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Book(),
    );
  }
}

class Book extends StatefulWidget {
  BookState createState() => BookState();
}

class BookState extends State<Book> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 80,
            child: Stack(
              children: [
                Positioned.fill(child: Image.asset("images/bus1.png")),
                Positioned(top: 30, left: 2, child: Text("Obuasi")),
                Positioned(top: 30, right: 2, child: Text("Kumasi"))
              ],
            ),
          ),
          DefaultTabController(
              length: 3,
              child: TabBar(
                tabs: [
                  Tab(
                    child:
                        Text("seating", style: TextStyle(color: Colors.blue)),
                  ),
                  Tab(
                    child: Text("pickup points",
                        style: TextStyle(color: Colors.blue)),
                  ),
                  Tab(
                      child: Text("routes and stops",
                          style: TextStyle(color: Colors.blue))),
                ],
              ))
        ],
      ),
    );
  }
}
