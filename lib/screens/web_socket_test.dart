import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mytok_worker/utils/colors.dart';
import 'package:web_socket_channel/io.dart';

import '../utils/colors.dart';

class WebSocket extends StatefulWidget {
  const WebSocket({Key? key}) : super(key: key);

  @override
  State<WebSocket> createState() => _WebSocketState();
}

class _WebSocketState extends State<WebSocket> {
  final channel = IOWebSocketChannel.connect('ws://90.156.211.5:8080');

  @override
  void initState(){
    super.initState();
    streamListener();
  }

  streamListener(){
    channel.stream.listen((message) {
      // late getData = jsonDecode(message);
      print(message);
      // setState(() {
      //   btcPrice =getData['p'];
      // });
    });
  }

  String btcPrice = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web socket'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "BTC/USDT narxi",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.black, fontSize: 20.0),
            ),
            // Padding(padding: EdgeInsets.all(8.0),
            //   child:Text(btcPrice, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: AppColors.primaryColor),),),
          ],
        ),
      ),
    );
  }
}


