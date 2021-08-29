import 'package:flutter/material.dart';
import 'package:myapp/screens/completebook.dart';
import 'package:myapp/screens/homepage.dart';

class Ticket extends StatefulWidget {
  const Ticket({Key? key,required this.ticketinfo}) : super(key: key);
 final Ticketinfo ticketinfo;
  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation:6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Center(
              child: Text("Ticket details",style:TextStyle(color:Colors.lightBlue ) , ),
            ),
            Divider(
              color:Colors.lightBlue
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: ListTile(
                    title:Text(widget.ticketinfo.company),
                    subtitle:Text("Company")
                  )),
                  Expanded(child: ListTile(
                    title:Text(widget.ticketinfo.tripid),
                    subtitle: Text("Tripid"),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: ListTile(
                    title:Text(widget.ticketinfo.vehid),
                    subtitle:Text("Vehicle id")
                  )),
                  Expanded(child: ListTile(
                    title:Text(widget.ticketinfo.booker),
                    subtitle: Text("Booker id"),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: ListTile(
                    title:Text(widget.ticketinfo.from),
                    subtitle:Text("From")
                  )),
                  Expanded(child: ListTile(
                    title:Text(widget.ticketinfo.to),
                    subtitle: Text("To"),
                  )),
                ],
              ),
            ),
            
           Center(
             child: TextButton(onPressed: (){
Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfoClass()),
                  );

             }, child: Text("See profile")),
           )
          ]),
        ),
      ),
    );
  }
}
