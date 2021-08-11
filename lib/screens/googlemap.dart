import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geocoding/geocoding.dart';

void main() => runApp(Mymap());

class Mymap extends StatefulWidget {
  @override
  _MymapState createState() => _MymapState();
}

class _MymapState extends State<Mymap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Map View",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            backgroundColor: Colors.transparent,
          ),
          body: Showmap()),
    );
  }
}

class Showmap extends StatefulWidget {
  const Showmap({Key? key}) : super(key: key);

  @override
  _ShowmapState createState() => _ShowmapState();
}

class _ShowmapState extends State<Showmap> {
  Set<Marker> markers = {};

  Future<Position> getposition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<List<Placemark>> getplacmark(double lat, double long) async {
    return await GeocodingPlatform.instance.placemarkFromCoordinates(lat, long);
  }
  
  String city = "";
  double lat = 0.0, long = 0.0;
  bool loading = true;
  LatLng _center = LatLng(50, 50);
  @override
  void initState() {
    getposition().then((value) {
      setState(() {
        _center = LatLng(value.latitude, value.longitude);
        lat = value.latitude;
        long = value.longitude;

        
      });
      getplacmark(value.latitude, value.longitude).then((val) {
        setState(() {
          city = val.first.name! +" , "+val.first.locality!;
          loading = false;
        });
      });
    });
    // print(_center);
    super.initState();
  }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long),
        zoom: 18
        ),
        
      )
    
    );
    setState((){
   
    Marker destinationMarker = Marker(
      markerId: MarkerId("Current loc"),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(
        title: city,
        snippet: "you are currently here",
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    markers.add(destinationMarker);
     });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            markers: Set<Marker>.from(markers),
          );
  }
}
