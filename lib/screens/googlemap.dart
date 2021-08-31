import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'homepage.dart';
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfoClass()),
                  );
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
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

  Future<List<dynamic>> stationcity() async {
    var docs = await FirebaseFirestore.instance
        .collection("appstrings")
        .doc("cordinates")
        .collection("stations")
        .where("city", isEqualTo: "kumasi")
        .get();
    return docs.docs;
  }

  String city = "";
  double lat = 0.0, long = 0.0;
  bool loading = true;
  LatLng _center = LatLng(50, 50);
  @override
  void initState() {
    super.initState();

    getposition().then((value) {
      setState(() {
        _center = LatLng(value.latitude, value.longitude);
        lat = value.latitude;
        long = value.longitude;
      });
      getplacmark(value.latitude, value.longitude).then((val) {
        setState(() {
          city = val.first.name! + " , " + val.first.locality!;
          loading = false;
        });
      });
    });

    stationcity().then((value) {
      for (var item in value) {
        print(item["name"]);
      }
    });
    // print(_center);
  }

  //late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: _center, zoom: 22),
    ));
    setState(() {
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
        ? Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text("Loading map view...")
              ],
            ),
          )
        : GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 19.0,
            ),
            markers: Set<Marker>.from(markers),
          );
  }
}
