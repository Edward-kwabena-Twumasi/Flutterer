import 'dart:convert';
//import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/components/applicationwidgets.dart';
import 'package:myapp/providersPool/userStateProvider.dart';
import 'package:myapp/screens/homepage.dart';

const AndroidNotificationChannel Channel = AndroidNotificationChannel(
    "interval", "sendinterval", "channel for sending at interval",
    importance: Importance.high, playSound: true);
const AndroidNotificationChannel Channel1 = AndroidNotificationChannel(
    "future", "sendfuture", "channel for sending infuture",
    importance: Importance.high, playSound: true);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebasehandlebackgroundmessage(
    RemoteMessage remotemessage) async {
  await Firebase.initializeApp();
  print("You just received a background message $remotemessage");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebasehandlebackgroundmessage);

  if (kIsWeb) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(Channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(Notifies());
}

int messagecount = 0;
String constructFCMPayload(String token) {
  messagecount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': messagecount.toString(),
    },
    'notification': {
      'title': 'Hello user!',
      'body': 'This notification (#$messagecount) was created via FCM!',
    },
  });
}

class Notifies extends StatefulWidget {
  const Notifies({Key? key}) : super(key: key);

  @override
  _NotifiesState createState() => _NotifiesState();
}

class _NotifiesState extends State<Notifies> {
  String? token;
  double diff = 0;
  String statemsg = "";
  bool cancelperiod = false;
  DateTime now = DateTime.now();
  DateTime future = DateTime.now();
  TextEditingController body = TextEditingController();
  TextEditingController body1 = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        print(value.data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification!.android;

      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    Channel.id, Channel.name, Channel.description,
                    color: Colors.lightBlue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification!.android;
      if (notification != null && androidNotification != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });
    if (FirebaseAuth.instance.currentUser != null) {
      getToken(FirebaseAuth.instance.currentUser!.uid).then((value) {
        setState(() {
          token = value;
        });
        print(token);
      });
    }
  }

  Future<void> sendPushMessage() async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(token!),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
            onPressed: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>UserInfoClass() ),
                  );
            },
            icon: Icon(Icons.arrow_back_ios ,color:Colors.black )),
      ),
      body: Container(
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            child: Column(
              children: [
                InputFields("Remind every eg. 30 mins ", body, Icons.message,
                    TextInputType.multiline),
                SizedBox(),

                ButtonBar(children: [
                  TextButton(
                      onPressed: () {
                        flutterLocalNotificationsPlugin.cancel(1);
                        setState(() {
                          cancelperiod = true;
                        });
                      },
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () {
                         setState(() {
                          cancelperiod = false;
                        });
                        now = DateTime.now();
                        int inc = 1;
                        while (cancelperiod == false) {
                          future = DateTime.now().add(Duration(minutes: inc));
                          inc += 1;
                        }

                        flutterLocalNotificationsPlugin.periodicallyShow(
                            1,
                            "Periodic reminder",
                            "The time is "+future.toString(),
                            RepeatInterval.everyMinute,
                            NotificationDetails(
                                android: AndroidNotificationDetails(Channel.id,
                                    Channel.name, Channel.description,
                                    color: Colors.lightBlue,
                                    playSound: true,
                                    icon: '@mipmap/ic_launcher')),
                            payload: "received");
                      },
                      child: Text("Notify me")),
                ]),

                InputFields("Alert once at .eg 7am", body1, Icons.message,
                    TextInputType.multiline),
                ButtonBar(children: [
                  TextButton(
                      onPressed: () {
                        flutterLocalNotificationsPlugin.cancel(2);
                      },
                      child: Text("cancel")),
                  TextButton(
                      onPressed: () async {
                        if (body1.text.isNotEmpty) {
                          now = DateTime.now();
                          future = DateTime.now().add(Duration(
                              hours: int.parse(
                                body1.text.split(":")[0],
                              ),
                              minutes: int.parse(body1.text.split(":")[1])));

                          setState(() {
                            diff = future.difference(now).inMinutes / 1.0;
                            now = DateTime.now();
                            statemsg =
                                "notification to show at " + future.toString();
                          });
                          print(diff.toString());
                          flutterLocalNotificationsPlugin.show(
                              2,
                              "New notification",
                              "received at" +
                                  DateTime.now().toString().split(" ")[1],
                              NotificationDetails(
                                  android: AndroidNotificationDetails(
                                      Channel1.id,
                                      Channel1.name,
                                      Channel1.description,
                                      color: Colors.lightBlue,
                                      playSound: true,
                                      icon: '@mipmap/ic_launcher')),
                              payload: "once");
                        } else {
                          print('Provide correct time');
                        }
                      },
                      child: Text("Notify me")),
                ]),
                SizedBox(),
                // InputFields(
                //     "Alert me", body, Icons.message, TextInputType.multiline),
                // SizedBox(),
                ListTile(
                    title: Text("Notifications pending"),
                    subtitle: Text(
                      statemsg,
                      style: TextStyle(color: Colors.lightBlue),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//set timer