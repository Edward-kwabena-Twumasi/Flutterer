import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ChatApp());
final TextEditingController _controller = TextEditingController();
final _channel = WebSocketChannel.connect(
  Uri.parse('wss://echo.websocket.org'),
);
void _sendMessage() {
  
  if (_controller.text.isNotEmpty) {
    _channel.sink.add(_controller.text);
  }
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const title = 'Chat assistant';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(title),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _sendMessage,
          tooltip: 'Send message',
          child: const Icon(Icons.send),
        ),
        body: ChatHomePage(
          title: title,
          channel: _channel,
        ),
      ),
    );
  }
}

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({
    Key? key,
    required this.title,
    required this.channel,
  }) : super(key: key);
  final String title;
  final WebSocketChannel channel;
  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Send a message'),
            ),
          ),
          const SizedBox(height: 24),
          StreamBuilder(
            stream: widget.channel.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          )
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
   widget.channel.sink.close();
    super.dispose();
  }
}
