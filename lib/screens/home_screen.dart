import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hive/hive.dart';
import 'package:mytok_worker/utils/colors.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final channel = IOWebSocketChannel.connect('ws://90.156.211.5:8080');
  List<Map<String, dynamic>> ordersData = [];
  bool isWebSocketConnected = false;

  @override
  void initState() {
    super.initState();
    streamListener();
  }

  streamListener() {
    channel.stream.listen((message) {
      if (mounted) {
        final getData = jsonDecode(message);
        setState(() {
          isWebSocketConnected = true; // WebSocket is connected
          ordersData = List<Map<String, dynamic>>.from(jsonDecode(message));
        });
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          isWebSocketConnected = false; // WebSocket is down
        });
      }
    });
  }

  late int status = 0;
  var box = Hive.box('users');

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My tok",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.yellow,
      ),
      body: Column(
        children: [
          Expanded(
            child: isWebSocketConnected
                ? ordersData.isEmpty
                    ? Center(
                        child: Text(
                          "Buyurtmalar mavjud emas",
                          style:
                              TextStyle(fontSize: w * 0.05, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: ordersData.length,
                        itemBuilder: (context, index) {
                          final item = ordersData[index];
                          return Card(
                            child: ListTile(
                              leading: _buildLeadingIcon(item['category']),
                              title: Text(
                                item['category'] ?? '',
                                style: TextStyle(
                                    color: AppColors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.06),
                              ),
                              subtitle: Text(item['location'] ?? ''),
                              trailing: _buildForm(item['id']),
                            ),
                          );
                        },
                      )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Internet bilan muammo!",
                        style:
                            TextStyle(fontSize: w * 0.05, color: Colors.grey),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      // CircleAvatar(
                      //   radius: 30,
                      //   backgroundColor: AppColors.yellow,
                      //   child: IconButton(
                      //     onPressed: () {
                      //       // streamListener();
                      //     },
                      //     icon: Icon(Icons.update, color: Colors.white, size: 30,),
                      //   ),
                      // )
                    ],
                  )),
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: h * 0.08,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.history,
            size: 30,
            color: Colors.white,
          ),
          // Icon(Icons.phone, size: 30, color: Colors.white,),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: AppColors.yellow,
        buttonBackgroundColor: AppColors.yellow,
        backgroundColor: Colors.white,
        animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          if (index == 1) {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyOrders()));
          } else if (index == 2) {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ContactScreen()));
          } else if (index == 3) {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Profile()));
          }
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

Widget _buildLeadingIcon(String category) {
  if (category == "Montaj") {
    return CircleAvatar(
      child: Image.asset("assets/images/montaj.png"),
    );
  } else if (category == "Shit ishlari") {
    return CircleAvatar(
      child: Image.asset("assets/images/shit.png"),
    );
  } else if (category == "Vklyuchatel") {
    return CircleAvatar(
      child: Image.asset("assets/images/vklyuchatel.png"),
    );
  } else if (category == "Simyog'och") {
    return CircleAvatar(
      child: Image.asset("assets/images/simyogoch.png"),
    );
  } else if (category == "Qandil o'rnatish") {
    return CircleAvatar(
      child: Image.asset("assets/images/qandil.png"),
    );
  } else {
    return CircleAvatar(
      child: Image.asset("assets/images/montaj.png"),
    );
  }
}

Widget _buildIcon(String category) {
  if (category == "0") {
    return IconButton(onPressed: () {}, icon: Icon(Icons.download));
  } else {
    return Icon(Icons.check);
  }
}

Widget _buildForm(String id) {
  return IconButton(
    onPressed: () {},
    icon: Icon(Icons.check),
  );
}
