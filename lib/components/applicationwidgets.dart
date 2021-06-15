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
        fillColor: Colors.pink[50],
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

Widget primaryactions() {
  return Stack(children: [
    Container(
        decoration: BoxDecoration(boxShadow: [
          //   BoxShadow(
          //       color: Colors.grey, blurRadius: 3.0, offset: Offset(1.0, 1.0))
        ]),
        child: Center(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            children: <Widget>[
              nicebuttons(Icons.ev_station, "station"),
              nicebuttons(Icons.chair, " seat"),
              nicebuttons(Icons.find_in_page, "Where am i"),
              nicebuttons(Icons.message, "message"),
            ],
          ),
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(5)),
    Positioned(
      left: 150.0,
      top: 15.0,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(
          "Help and Find",
          style: TextStyle(
            backgroundColor: Colors.black87,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ]);
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

Widget nicebuttons(IconData icondata, String text) {
  return RawMaterialButton(
    onPressed: () {},
    fillColor: Colors.yellow[200],
    splashColor: Colors.yellow[100],
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: Icon(icondata)),
        Text(text)
      ],
    ),
    shape: StadiumBorder(),
  );
}

class menuButton extends StatefulWidget {
  const menuButton({Key? key}) : super(key: key);

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
      child: DropdownButton<String>(
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
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: regions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
