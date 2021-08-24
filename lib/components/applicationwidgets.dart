import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providersPool/userStateProvider.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

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
      title: TextFormField(
        autocorrect: true,
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

Widget niceChips(IconData icondata, String text, void Function() pressed) {
  bool selected = false;
  return InputChip(
    backgroundColor:Colors.red[50] ,
    side: BorderSide.none,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)),
    selected: selected,
    selectedColor: Colors.red[50],
    label: Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.red),
    ),
    avatar: Icon(icondata),
    labelPadding: EdgeInsets.all(8),
    onPressed: () {      
    },
  );
}

class MenuButton extends StatefulWidget {
  const MenuButton({Key? key, required this.regioncontroller})
      : super(key: key);

  final TextEditingController? regioncontroller;

  @override
  State<MenuButton> createState() => _MenuButtonState(regioncontroller);

}

/// This is the private State class that goes with MyStatefulWidget.
class _MenuButtonState extends State<MenuButton> {
  final TextEditingController? regioncontroller;
  _MenuButtonState(this.regioncontroller);
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
              icon: const Icon(Icons.pin_drop_outlined),
              iconSize: 34,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
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
    TripClass("Obuasi", "Obuasi", DateTime.now(), DateTime.now(), "normal", "");
List<String> places = ["Kumasi", "Obuasi", "Accra", "Kasoa", "Mankessim", "Wa"];

class SearchLocs extends StatefulWidget {
  SearchLocs(
      {required this.direction,
      required this.locations,
      required this.searchcontrol});
  final TextEditingController searchcontrol;

  final String direction;
  final List<String> locations;
  @override
  SearchLocsState createState() => SearchLocsState();
}

class SearchLocsState extends State<SearchLocs> {
  final FocusNode focusNode = FocusNode();
  OverlayEntry? myoverlay;
  bool hideoverlay = false;
  bool foundinlist = false;
  var mytripobj = {};
  @override
  void initState() {
    super.initState();

    widget.searchcontrol.addListener(() {
      // widget.searchcontrol.text = widget.searchcontrol.text.substring(0,).toUpperCase()+
      // widget.searchcontrol.text.substring(1);
      suggestions = [];
      for (var i in places) {
        if ((i.toLowerCase().startsWith(widget.searchcontrol.text.toLowerCase()) ||
            i.toLowerCase().contains( widget.searchcontrol.text.toLowerCase()))) {
          suggestions.add(i);
        }
      }
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        this.myoverlay = createOverlay();
        Overlay.of(context)!.insert(this.myoverlay!);
      } else {
        myoverlay!.remove();
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
              top: offset.dy + size.height,
              width: size.width,
              child: Material(
                elevation: 4.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        shape: RoundedRectangleBorder(),
                        key: Key(index.toString()),
                        onTap: () {
                          this.myoverlay!.remove();
                          print(index);
                          mytripobj[widget.direction] = suggestions[index];
                          widget.searchcontrol.text = suggestions[index];

                          widget.direction == "From"
                              ? onetrip.fromLoc = widget.searchcontrol.text
                              : onetrip.toLoc = widget.searchcontrol.text;
                          suggestions = [];
                          print(suggestions);
                          print(mytripobj);
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
    super.dispose();
    myoverlay?.remove();
  }

  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        decoration: InputDecoration(
            labelText: "Travel ${widget.direction}",
            fillColor: Colors.pink,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none)),
        controller: widget.searchcontrol,
        focusNode: this.focusNode,
      ),
    );
  }
}

//options menu
class OptionButton extends StatefulWidget {
  const OptionButton(
      {Key? key,
      required this.options,
      required this.onchange,
      required this.dropdownValue})
      : super(key: key);
  final List<String> options;
  final String dropdownValue;
  final void Function(String? change) onchange;
  @override
  State<OptionButton> createState() => _OptionButtonState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _OptionButtonState extends State<OptionButton> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Center(
        child: SizedBox(
          height: 40,
          child: Consumer<UserState>(
            builder: (context, value, child) => DropdownButton<String>(
              value: widget.dropdownValue,
              icon: const Icon(Icons.pin_drop_outlined),
              iconSize: 34,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
              ),
              onChanged: widget.onchange,
              items:
                  widget.options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

String? imgUrl;

class UploadPic extends StatefulWidget {
  const UploadPic({
    Key? key,
    required this.foldername,
    required this.imagename,
  }) : super(key: key);

  final String foldername, imagename;

  @override
  _UploadPicState createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPic> {
  bool notdone = false;
  void upLoadimg() async {
    print("starting upload");
    final picker = ImagePicker();
    XFile? image;
    image = await picker.pickImage(source: ImageSource.gallery);

    var file = File(image!.path);
    print(file);
    // ignore: unnecessary_null_comparison
    if (file != null) {
      print("file is not nul");
      var snapshot = await FirebaseStorage.instance
          .ref(FirebaseAuth.instance.currentUser!.uid.substring(0, 5))
          .child(widget.foldername + "/" + widget.imagename)
          .putFile(file)
          .whenComplete(() {
        setState(() {
          notdone = false;
        });
        print("done");
      });
      var geturl = await snapshot.ref.getDownloadURL();
      setState(() {
        imgUrl = geturl;
      });
    } else {
      print("no image chosen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return notdone
        ? CircularProgressIndicator()
        : Container(
            child: Center(
                child: Column(
            children: [
              (imgUrl != null)
                  ? Image.network(imgUrl!, cacheHeight: 120, cacheWidth: 120)
                  : Placeholder(
                      fallbackHeight: 120,
                      fallbackWidth: 120,
                    ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    notdone = true;
                  });
                  upLoadimg();
                },
                label: Text(
                  "Choose image",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 5)
            ],
          )));
  }
}

class Policy extends StatefulWidget {
  const Policy({Key? key}) : super(key: key);

  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                    title: Text("Usage policy"),
                    subtitle: Text(
                        "Respect all rules laid down on this app.Amy malicious ...")),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                    title: Text("Refund policy"),
                    subtitle: Text(
                        "Refunds will be done under the following conditions")),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                    title: Text("Transfer policy"),
                    subtitle: Text(
                        "Users who have bought tickets ,also called transactors can transfer their tickets to other accounts")),
              ),
            ]),
          ),
        ));
  }
}

class Compareprice extends StatefulWidget {
  const Compareprice({Key? key}) : super(key: key);

  @override
  _ComparepriceState createState() => _ComparepriceState();
}

class _ComparepriceState extends State<Compareprice> {
  TextEditingController origin = TextEditingController();
  TextEditingController destin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: InputFields("from", origin, Icons.location_city,
                        TextInputType.text)),
                Expanded(
                    child: InputFields(
                        "to", destin, Icons.location_city, TextInputType.text))
              ],
            ),
          ),
          ButtonBar(
            children: [
              TextButton(onPressed: () {}, child: Text("List comparisons"))
            ],
          ),
          Card(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("20 GHS"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("30 GHS"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("100 GHS"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FindateTrips extends StatefulWidget {
  const FindateTrips({Key? key}) : super(key: key);

  @override
  _FindateTripsState createState() => _FindateTripsState();
}

class _FindateTripsState extends State<FindateTrips> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
    );
  }
}

class Offers extends StatefulWidget {
  const Offers({ Key? key }) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Offers appear here")
        ],
      ),
    );
  }
}