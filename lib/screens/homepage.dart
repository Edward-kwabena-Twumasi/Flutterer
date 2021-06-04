import 'package:flutter/material.dart';
import 'package:myapp/components/AgentsList.dart';
import 'package:myapp/components/text_inputwidgets.dart';

void main() {
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        //'/search': (context) => MyFormApp(),
      },
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.lightGreen,
              unselectedItemColor: Colors.grey,
              elevation: 5,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit_outlined), label: "home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit_outlined), label: "history"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit_outlined), label: "help"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit_outlined), label: "Me"),
              ]),
          appBar: AppBar(
            leading: Icon(Icons.menu),
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
                iconSize: 34,
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.bus_alert_rounded)),
                Tab(icon: Icon(Icons.train)),
                Tab(icon: Icon(Icons.flight)),
              ],
            ),
            title: Text('Ready to travel'),
          ),
          body: TabBarView(
            children: [
              SafeArea(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      region(),
                      locations(),
                      Expanded(child: primaryactions()),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    region(),
                    locations(),
                    Expanded(child: primaryactions()),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    region(),
                    locations(),
                    Expanded(child: primaryactions()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget region() {
  TextEditingController mycontroller = TextEditingController();
  return Card(
    elevation: 3,
    child: Container(
        child: Center(
          child: menuButton(),
        ),
        height: 81,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(15)),
  );
}

Widget locations() {
  return Card(
    elevation: 3,
    child: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SearchLocs("From"),
            SizedBox(height: 5),
            SearchLocs("To"),
            Expanded(
                child: Center(
                    child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //add time chooser
                TextButton(onPressed: () {}, child: Text("CHOOSE TIME")),
                //add date chooser
                TextButton(onPressed: () {}, child: Text("SELECT DATE")),
                //proceed with boooking
                ElevatedButton(onPressed: () {}, child: Text("Proceed"))
              ],
            ))),
          ],
        )),
        height: 160,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5)),
  );
}

//primary actions
Widget primaryactions() {
  return Card(
    elevation: 3,
    child: Stack(children: [
      Container(
          child: Center(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: <Widget>[
                useractions(Icons.ev_station, "station"),
                useractions(Icons.chair, " seat"),
                useractions(Icons.find_in_page, "Where am i"),
                useractions(Icons.message, "message"),
                useractions(Icons.lock_clock, "time matches"),
              ],
            ),
          ),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(5)),
      Positioned(
        left: 50.0,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Help and Find",
            style: TextStyle(
              backgroundColor: Colors.black87,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ]),
  );
}

Widget buttonactions() {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(30),
      color: Colors.transparent,
    ),
    height: 20,
    padding: EdgeInsets.all(20),
  );
}

/// This is the stateful widget that the main application instantiates.
class menuButton extends StatefulWidget {
  const menuButton({Key key}) : super(key: key);

  @override
  State<menuButton> createState() => _menuButtonState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _menuButtonState extends State<menuButton> {
  void initState() {
    super.initState();
    searchcontrol.addListener(() {
      searchcontrol.text = searchcontrol.text.toUpperCase();
    });
  }

  String dropdownValue = 'ASHANTI';

  var regions = [
    'ASHANTI',
    'CENTRAL',
    'AHAFO',
    'UPPER WEST',
    'UPPER EAST',
    'NORTHERN',
    'WESTERN',
    'OTI',
    'VOLTA',
    'EASTERN',
    'GREATER ACCRA'
  ];

  TextEditingController searchcontrol = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: Colors.white, width: 3.0, style: BorderStyle.solid)),
      child: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "AT WHICH REGION?",
                    contentPadding: EdgeInsets.all(1)),
                autocorrect: true,
                controller: searchcontrol,
              ),
            ),
          ),
          SizedBox(
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  searchcontrol.text = dropdownValue;
                });
              },
              items: regions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchLocs extends StatefulWidget {
  SearchLocs(this.direction);
  String direction;
  @override
  SearchLocsState createState() => SearchLocsState();
}

class SearchLocsState extends State<SearchLocs> {
  OverlayEntry myoverlay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formcontrol.addListener(() {
      suggestions = [];
      var query = formcontrol.text;
      if (query.isNotEmpty) {
        for (var i in places) {
          if (i.toLowerCase().contains(query.toLowerCase()) ||
              i.toLowerCase().startsWith(query)) {
            suggestions.add(i);
            this.myoverlay = this.createOverlay();
            Overlay.of(context).insert(this.myoverlay);
          }
        }

        setState(() {
          suggestions.toList();
          height = 35.0;
          height = height * suggestions.length;
        });
      } else {
        print(formcontrol.text);
        setState(() {
          suggestions = [];
          height = 35.0;
        });
      }
    });
  }

  OverlayEntry createOverlay() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5.0,
              width: size.width,
              child: Material(
                elevation: 4.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        key: Key(index.toString()),
                        onTap: () {
                          print(suggestions[index]);
                        },
                        title: Text(
                          suggestions[index],
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w300),
                        ));
                  },
                ),
              ),
            ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<String> places = ["kumasi", "obuasi", "accra", "Accra", "place5"];
  List<String> suggestions = [];
  var height = 35.0;
  TextEditingController formcontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        children: [
          SizedBox(width: 40, child: Text(widget.direction)),
          Expanded(
              child: TextFormField(
            controller: formcontrol,
          )),
          DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white,
                      blurRadius: 0.0,
                      offset: Offset(3.0, 3.0)),
                ]),
            child: IconButton(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                onPressed: () {},
                icon: Icon(
                  Icons.location_city,
                  color: Colors.red,
                )),
          )
        ],
      ),
    ]);
  }
}

Widget useractions(IconData icondata, String text) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: IconButton(
      constraints: BoxConstraints(maxHeight: 40.0, maxWidth: 40.0),
      enableFeedback: true,
      tooltip: "do this",
      icon: Icon(icondata),
      iconSize: 35,
      color: Colors.deepPurple,
      onPressed: () {},
    ),
  );
}
