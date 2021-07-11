import 'package:flutter/material.dart';
import 'package:myapp/providersPool/agentStateProvider.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providersPool/userStateProvider.dart';

//text widget
class TextWidgets extends StatelessWidget {
  final String text;
  final TextStyle mystyle;
  final Icon icon;
  const TextWidgets(this.text, this.mystyle, this.icon);
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(text, style: mystyle),
      ),
    );
  }
}

//input field
class InputFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintext;
  final IconData iconData;
  final TextInputType inputtype;
  const InputFields(
      this.hintext, this.controller, this.iconData, this.inputtype);
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: TextFormField(
        style: TextStyle(color: Colors.black),
        keyboardType: inputtype,
        decoration: new InputDecoration(
          border: new OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          hintStyle: new TextStyle(color: Colors.black),
          hintText: hintext,
          labelText: hintext,
          helperText: "Fill these correctly for Us",
        ),
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $hintext';
          }
          return null;
        },
      ),
    );
  }
}

Widget niceChips(
  IconData icondata,
  String text,
) {
  return InputChip(
    backgroundColor: Colors.lightBlue,
    selected: false,
    selectedColor: Colors.amber,
    label: Text(text),
    avatar: Icon(icondata),
    labelPadding: EdgeInsets.all(8),
    onPressed: () {},
  );
}

class menuButton extends StatefulWidget {
  const menuButton({Key? key, required this.regioncontroller})
      : super(key: key);

  final TextEditingController? regioncontroller;

  @override
  State<menuButton> createState() => _menuButtonState(regioncontroller);
}

/// This is the private State class that goes with MyStatefulWidget.
class _menuButtonState extends State<menuButton> {
  final TextEditingController? regioncontroller;
  _menuButtonState(this.regioncontroller);
  void initState() {
    super.initState();
  }

  String? dropdownValue = 'ASHANTI';

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Consumer<UserState>(
        builder: (context, value, child) => Row(
          children: [
            // InputFields("Region", widget.regioncontroller!, Icons.place,
            //     TextInputType.text),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 34,
              elevation: 16,
              style: const TextStyle(color: Colors.lightBlue),
              underline: Container(
                height: 1,
              ),
              onChanged: (String? newValue) {
                // widget.regioncontroller!.text = newValue!;
                setState(() {
                  dropdownValue = newValue;
                });
                value.selectregion = dropdownValue;
                print(value.selectregion);
                regioncontroller!.text = dropdownValue!;
              },
              items: regions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
                child: TextField(
              controller: regioncontroller,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

TripClass onetrip =
    TripClass("Obuasi", "Obuasi", "10:00", "20 10 2021", "normal");

class SearchLocs extends StatefulWidget {
  SearchLocs(this.direction);
  String direction;

  @override
  SearchLocsState createState() => SearchLocsState();
}

class SearchLocsState extends State<SearchLocs> {
  late OverlayEntry myoverlay;
  late bool hideoverlay;
  var mytripobj = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formcontrol.addListener(() {
      suggestions = [];
      var query = formcontrol.text;
      hideoverlay = false;
      if (query.isNotEmpty) {
        for (var i in places) {
          if (i.toLowerCase().contains(query.toLowerCase()) ||
              i.toLowerCase().startsWith(query)) {
            suggestions.add(i);

            this.myoverlay = this.createOverlay();
            Overlay.of(context)!.insert(this.myoverlay);

            // myoverlay.addListener(() {
            //   print("overlaay");
            // });
          }
        }

        setState(() {
          suggestions.toList();
          hideoverlay = false;
        });
      } else {
        print(formcontrol.text);
        setState(() {
          hideoverlay = true;
        });
      }
    });
  }

  OverlayEntry createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
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
                          this.myoverlay.mounted ? myoverlay.remove() : null;

                          print(index);
                          mytripobj[widget.direction] = suggestions[index];
                          formcontrol.text = suggestions[index];
                          widget.direction == "From"
                              ? onetrip.fromLoc = formcontrol.text
                              : onetrip.toLoc = formcontrol.text;
                          suggestions = [];
                          print(mytripobj);
                          setState(() {
                            hideoverlay = true;
                          });
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

  List<String> places = ["Kumasi", "Obuasi", "Accra", "Kasoa", "Mankessim"];
  List<String> suggestions = [];

  TextEditingController formcontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.search),
      title: TextFormField(
        decoration: InputDecoration(
            labelText: "Travel From",
            fillColor: Colors.pink,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
        controller: formcontrol,
      ),
    );
  }
}
