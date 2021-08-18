import 'package:flutter/material.dart';

class Ticket extends StatefulWidget {
  const Ticket({ Key? key }) : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(10)
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children:[
            Center(child: Text("Ticket details"),),
            Divider(),
            ListTile(
              title: Text("Ticket id"),
              subtitle: Text("hg76678gd6t7t6"),
             
            ),
            Divider(),
            ListTile(
              title: Text("Name  "  ),
              subtitle: Text("Iddrisu Huttel"),
             
            ),
             Divider(),
             ListTile(
              title: Text("Company"),
              subtitle: Text("MMT"),
             
            ),

          ]
        ),
      ),
    );
  }
}