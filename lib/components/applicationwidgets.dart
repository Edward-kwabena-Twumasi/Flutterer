import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providersPool/userStateProvider.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
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
  return InputChip(
    side: BorderSide.none,
    backgroundColor: Colors.grey,
    selected: false,
    selectedColor: Colors.green[100],
    label: Text(text),
    avatar: Icon(icondata),
    labelPadding: EdgeInsets.all(8),
    onPressed: pressed,
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
    TripClass("Obuasi", "Obuasi", DateTime.now(), DateTime.now(), "normal");
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
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? myoverlay;
  bool hideoverlay = false;
  bool foundinlist = false;
  var mytripobj = {};
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this.myoverlay = createOverlay();
        Overlay.of(context)!.insert(this.myoverlay!);
        widget.searchcontrol.addListener(() {
          for (var i in places) {
            if ((i.contains(widget.searchcontrol.text) || i.startsWith(widget.searchcontrol.text))&
                !suggestions.contains(i)) {
              suggestions.add(i);
            }
          }
        });
      } else if(hideoverlay ||!_focusNode.hasFocus){
        this.myoverlay!.remove();
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
                           setState(() {
                           hideoverlay = true;
                          });

                          print(index);
                          mytripobj[widget.direction] = suggestions[index];
                          widget.searchcontrol.text = suggestions[index];

                          widget.direction == "From"
                              ? onetrip.fromLoc = widget.searchcontrol.text
                              : onetrip.toLoc = widget.searchcontrol.text;
                          suggestions = [];
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
    // TODO: implement dispose

    super.dispose();
  }

  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        decoration: InputDecoration(
            labelText: "Travel $widget.direction",
            fillColor: Colors.pink,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none)),
        controller: widget.searchcontrol,
        focusNode: this._focusNode,
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

class payment extends StatefulWidget {
  const payment({Key? key}) : super(key: key);

  @override
  _paymentState createState() => _paymentState();
}

class _paymentState extends State<payment> {
  var publicKey = '[YOUR_PAYSTACK_PUBLIC_KEY]';
  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
