import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/components/applicationwidgets.dart';

const AndroidNotificationChannel Channel = AndroidNotificationChannel(
    "notifier", "sendnotes", "channel for sending notifications",
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
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(Channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(Notifies());
}

class Notifies extends StatefulWidget {
  const Notifies({Key? key}) : super(key: key);

  @override
  _NotifiesState createState() => _NotifiesState();
}

class _NotifiesState extends State<Notifies> {
  TextEditingController body = TextEditingController();
  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            child: Column(
              children: [
                InputFields("Message body", body, Icons.message, TextInputType.multiline),
                SizedBox(),
                TextButton(
                    onPressed: () {
                      flutterLocalNotificationsPlugin.show(
                          0,
                          "New notification",
                          body.text,
                          NotificationDetails(
                              android: AndroidNotificationDetails(
                                  Channel.id, Channel.name, Channel.description,
                                  color: Colors.lightBlue,
                                  playSound: true,
                                  icon: '@mipmap/ic_launcher')));
                    },
                    child: Text("NOTIFICATIONS")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//set timer