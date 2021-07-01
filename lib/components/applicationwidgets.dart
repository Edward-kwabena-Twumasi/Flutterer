import 'package:flutter/material.dart';

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
    return new TextFormField(
      style: TextStyle(color: Colors.black),
      keyboardType: inputtype,
      decoration: new InputDecoration(
        icon: Icon(
          iconData,
          color: Colors.black,
          size: 33,
        ),
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
        filled: true,
        hintStyle: new TextStyle(color: Colors.grey),
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
    );
  }
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

Widget useractions(IconData icondata, String text) {
  return Card(
    elevation: 4.0,
    color: Colors.transparent,
    child: Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.amberAccent),
      child: IconButton(
        enableFeedback: true,
        tooltip: "do this",
        icon: Icon(
          icondata,
          color: Colors.white,
        ),
        iconSize: 35,
        color: Colors.deepPurple,
        onPressed: () {},
      ),
    ),
  );
}

Widget niceChips(
  IconData icondata,
  String text,
) {
  return ActionChip(
    label: Text(text),
    avatar: Icon(icondata),
    onPressed: () {},
  );
}

class menuButton extends StatefulWidget {
  const menuButton({Key? key, this.regioncontroller}) : super(key: key);

  final TextEditingController? regioncontroller;

  @override
  State<menuButton> createState() => _menuButtonState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _menuButtonState extends State<menuButton> {
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
      child: Row(
        children: [
          InputFields("Region", widget.regioncontroller!, Icons.place,
              TextInputType.text),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 34,
            elevation: 16,
            style: const TextStyle(color: Colors.lightBlue),
            underline: Container(
              height: 2,
              color: Colors.red,
            ),
            onChanged: (String? newValue) {
              widget.regioncontroller!.text = newValue!;
              setState(() {
                dropdownValue = newValue;
              });
              print(dropdownValue);
            },
            items: regions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
