import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main(List<String> args) {
  runApp(WebViewpg(
    pageurl: 'flutter.dev',
  ));
}

class WebViewpg extends StatefulWidget {
  WebViewpg({required this.pageurl});
  final String pageurl;
  @override
  WebViewpgState createState() => WebViewpgState();
}

class WebViewpgState extends State<WebViewpg> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text("Make payment"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 5,
            child: WebView(
              debuggingEnabled: true,
              initialUrl: widget.pageurl,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (navigation) {
                if (navigation.url == '') {
                 
                }
                 return NavigationDecision.navigate;
              },
            ),
          ),
        ),
      ),
    );
  }
}


class Initresponse {
  String message;
  Map<String, dynamic> data;
  bool status;
  Initresponse(
      {required this.message, required this.data, required this.status});

  factory Initresponse.fromJson(Map<String, dynamic> json) {
    return Initresponse(
        message: json["message"], data: json["data"], status: json["status"]);
  }
}

Future<Initresponse> verifytransaction(
    String key, String ref) async {
  final response = await http.get(
    Uri.parse("https://api.paystack.co/transaction/verify"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $key',
    }
  );

  if (response.statusCode == 200) {
// If the server did return a 201 CREATED response,
// then parse the JSON.
    return Initresponse.fromJson(jsonDecode(response.body));
  } else {
// If the server did not return a 201 CREATED response,
// then throw an exception.
    throw Exception('Failed to create album.');
  }
}
