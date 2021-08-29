import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/components/notifications.dart';

import 'package:myapp/screens/googlemap.dart';
import 'package:myapp/screens/reportscreen.dart';

List reviewtokens = [
  "nice",
  "good",
  "great",
  "bad",
  "enjoyed",
  "like",
  "dislike",
  "not",
  "worse",
  "awesome",
  "very",
  "soo"
];
List tokenweights = [2, 2, 3, -3, 4, 2, -2, -3, -4, 5, 2, 3];
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Features());
}

class Features extends StatefulWidget {
  const Features({Key? key}) : super(key: key);

  @override
  _FeaturesState createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  var starred = [];
  int starindex = 0;
  int stars = 5;
  TextEditingController reviewtext = TextEditingController();
  String dropval = "Travel mates";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Card(
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  heroTag: "1",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.amber[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                              heightFactor: 0.9, child: Paymenu());
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Pay",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Mybooks()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Bookings",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  heroTag: "2",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (buildContext) {
                          return
                             SingleChildScrollView(
                               child: Column(
                                children: [
                                  OptionButton(
                                      options: ["Travel mates"],
                                      onchange: (val) {
                                        print(val);
                                        setState(() {
                                          dropval = val!;
                                        });
                                      },
                                      dropdownValue: dropval),
                                  ListTile(
                                      leading: Text("3 stars"),
                                      trailing: IconButton(
                                          onPressed: () {
                                            print(
                                                "You rated $dropval $starindex stars");
                                          },
                                          icon: Icon(Icons.one_k)),
                                      subtitle: Container(
                                          height: 80,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: stars,
                                              itemBuilder: (context, index) {
                                                print(index);
                                                return StatefulBuilder(
                                                  builder: (context, setstate) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              starindex = index;
                                                            });
                                                            print(
                                                                "You choose $starindex stars");
                                                            print(starindex);
                                                            starred = [];
                                                            for (var i = 0;
                                                                i < (index+1);
                                                                i++) {
                                                              setState(() {
                                                                starred.add(i);
                                                              });
                                                            }
                                                          },
                                                          icon: Icon(Icons.star,
                                                              size: 30,
                                                              color: starred
                                                                      .contains(
                                                                          index)
                                                                  ? Colors.red
                                                                  : Colors.grey)),
                                                    );
                                                  },
                                                );
                                              }))),
                                ],
                                                         
                                                       ),
                             );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Rate",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (buildcontext) {
                          return Column(children: [
                            OptionButton(
                                options: ["Travel mates"],
                                onchange: (val) {
                                  print(val);
                                  setState(() {
                                    dropval = val!;
                                  });
                                },
                                dropdownValue: dropval),
                            TextField(
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.reviews),
                                  hintText: "Write review here"),
                            )
                          ]);
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Review",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Reports()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Report",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Mymap()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.location_on,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifies()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.watch_later,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
