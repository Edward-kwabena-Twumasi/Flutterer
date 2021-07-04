import 'package:flutter/material.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/agentStateProvider.dart';
import 'package:myapp/screens/agentlogin.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:myapp/screens/signup.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => CompanyState(), builder: (context, _) => DashApp()));
}

class DashApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dash-Board",
      home: Scaffold(
          floatingActionButton: Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 5,
                child: FloatingActionButton.extended(
                    heroTag: "addregion",
                    onPressed: () {},
                    label: Text("Add region")),
              ),
              Positioned(
                left: 20,
                bottom: 5,
                child: FloatingActionButton.extended(
                    heroTag: "addstation",
                    onPressed: () {},
                    label: Text("Add Station")),
              ),
              Positioned(
                left: 40,
                bottom: 5,
                child: FloatingActionButton.extended(
                    heroTag: "schedule",
                    onPressed: () {},
                    label: Text("Schedule Trip")),
              )
            ],
          ),
          body: Center(
            child: Container(
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: ListTile(title: Text("Regional Locations")),
                  ),
                  Card(
                    elevation: 5,
                    child: ListTile(title: Text("Stations Country wide")),
                  ),
                  Card(
                    elevation: 5,
                    child: ListTile(title: Text("Recent schedules")),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
