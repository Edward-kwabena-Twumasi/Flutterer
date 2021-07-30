import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Defines the main theme color.
// final MaterialColor themeMaterialColor =
//     BaseflowPluginExample.createMaterialColor(
//         const Color.fromRGBO(48, 49, 60, 1));

void main() {
  runApp(GeolocatorWidget());
}

/// Example [Widget] showing the functionalities of the geolocator plugin
class GeolocatorWidget extends StatefulWidget {
  /// Utility method to create a page with the Baseflow templating.

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _locationServiceStatusSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get location details")),
      body:Text("Position"),
      floatingActionButton: Stack(
        children: <Widget>[
       Positioned(
        child: Center(
          child: ListView.builder(
            itemCount: _positionItems.length,
            itemBuilder: (context, index) {
              final positionItem = _positionItems[index];
                return Card(
                  child: ListTile(
                    tileColor: Colors.lightBlue,
                    subtitle: Text(positionItem.placename,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    title: Text(
                      positionItem.displayValue,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
             
            },
          ),
        ),
      ),
      
          Positioned(
            bottom: 50.0,
            right: 50.0,
            child: FloatingActionButton.extended(
                onPressed: () async {
                  var position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.best)
                      .then((value) async {
                   var address = await GeocodingPlatform.instance.placemarkFromCoordinates(
                            value.latitude, value.longitude)
                        .then((value2) {
                      _positionItems.add(_PositionItem(
                          _PositionItemType.position,
                          value2.first.locality.toString(),
                          value2.first.name.toString()));
                      return value2;
                    });
                  });

                  setState(
                    () {},
                  );
                },
                label: Text("Current Position")),
          ),
         
        ],
      ),
    );
  }

 
 

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }
}

enum _PositionItemType {
  permission,
  position,
  locationServiceStatus,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue, this.placename);

  final _PositionItemType type;
  final String displayValue;
  final String placename;
}
