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
      body: Center(
        child: ListView.builder(
          itemCount: _positionItems.length,
          itemBuilder: (context, index) {
            final positionItem = _positionItems[index];

            if (positionItem.type == _PositionItemType.permission) {
              return ListTile(
                title: Text(positionItem.displayValue,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              );
            } else {
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
            }
          },
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 150.0,
            right: 50.0,
            child: FloatingActionButton.extended(
                onPressed: () async {
                  var position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.best)
                      .then((value) async {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                            value.latitude, value.longitude)
                        .then((value2) {
                      _positionItems.add(_PositionItem(
                          _PositionItemType.position,
                          value2.toString(),
                          value2.toString()));
                      return value2;
                    });
                  });

                  setState(
                    () {},
                  );
                },
                label: Text("Current Position")),
          ),
          Positioned(
            bottom: 100.0,
            right: 50.0,
            child: FloatingActionButton.extended(
              onPressed: _toggleListening,
              label: Text(() {
                if (_positionStreamSubscription == null) {
                  return "Start position updates stream";
                } else {
                  final buttonText = _positionStreamSubscription!.isPaused
                      ? "Resume"
                      : "Pause";

                  return "$buttonText position updates stream";
                }
              }()),
            ),
          ),
          Positioned(
              bottom: 50.0,
              right: 50.0,
              child: FloatingActionButton.extended(
                onPressed: _toggleLocationServiceListener,
                label: Text(() {
                  if (_locationServiceStatusSubscription == null) {
                    return "Start location service stream";
                  } else {
                    final buttonText =
                        _locationServiceStatusSubscription!.isPaused
                            ? "Resume"
                            : "Pause";
                    return "$buttonText location service stream";
                  }
                }()),
              )),
        ],
      ),
    );
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  bool _isLocationServiceListening() =>
      !(_locationServiceStatusSubscription == null ||
          _locationServiceStatusSubscription!.isPaused);

  void _toggleLocationServiceListener() {
    if (_locationServiceStatusSubscription == null) {
      final serviceStatusStream = Geolocator.getServiceStatusStream();
      _locationServiceStatusSubscription = serviceStatusStream.handleError(
          (error) {
        _locationServiceStatusSubscription?.cancel();
        _locationServiceStatusSubscription = null;
      }).listen((status) => setState(() => _positionItems.add(_PositionItem(
          _PositionItemType.locationServiceStatus, status.toString(), ""))));
      _locationServiceStatusSubscription?.pause();
    }

    setState(() {
      if (_locationServiceStatusSubscription == null) {
        return;
      }
      if (_locationServiceStatusSubscription!.isPaused) {
        _locationServiceStatusSubscription!.resume();
      } else {
        _locationServiceStatusSubscription!.pause();
      }
    });
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = Geolocator.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => setState(() => _positionItems.add(
          _PositionItem(_PositionItemType.position, position.toString(), ""))));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
      } else {
        _positionStreamSubscription!.pause();
      }
    });
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
