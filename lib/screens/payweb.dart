import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main(List<String> args) {
  runApp(WebViewpg(pageurl: 'flutter.dev', ref: 'ref'));
}

class WebViewpg extends StatefulWidget {
  WebViewpg({
    required this.pageurl,
    required this.ref,
  });
  final String pageurl;
  final String ref;
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
                if (navigation.url == 'https://successful.com') {
                  verifytransaction(widget.ref,
                          "sk_test_a310b10d73f4449db22b02c96c28be222a6f4351")
                      .then((value) {
                    print(value.status.toString() + " " + value.message);
                  });
                  Navigator.of(context).pop();
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

Future<Initresponse> verifytransaction(String key, String ref) async {
  final response = await http
      .get(Uri.parse("https://api.paystack.co/transaction/verify/"+ref), headers: {

    HttpHeaders.authorizationHeader: 'Bearer $key',
  });

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
