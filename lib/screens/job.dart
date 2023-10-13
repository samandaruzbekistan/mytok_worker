import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mytok_worker/screens/home_test.dart';
import 'package:mytok_worker/screens/my_orders.dart';
import 'package:mytok_worker/screens/profile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hive/hive.dart';
import 'package:mytok_worker/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Job extends StatefulWidget {
  Job({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  var box = Hive.box('users');
  bool getData = false;

  Map<String, dynamic> ordersData = {};

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  getOrder() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://mytok.uz/flutterapi/getworkhistory.php'));
    request.fields
        .addAll({'workid': '${widget.id}'});
    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    final data = json.decode(res);
    setState(() {
      getData = true;
      ordersData = Map<String, dynamic>.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Ish tavsilotlari",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.yellow,
      ),
      body: Container(
          child: getData
              ? Column(
            children: [
              ListTile(
                title: Text(
                  "Ish turi:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                subtitle: Text(
                  "${ordersData['category']}",
                  style:
                  TextStyle(color: Colors.grey, fontSize: w * 0.04),
                ),
                leading: CircleAvatar(
                  child: Icon(
                    Icons.workspaces_outline,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
              ListTile(
                title: Text(
                  "Buyurtma nomi:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                subtitle: Text(
                  "${ordersData['title']}",
                  style:
                  TextStyle(color: Colors.grey, fontSize: w * 0.04),
                ),
                leading: CircleAvatar(
                  child: Icon(
                    Icons.abc,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
              ListTile(
                title: Text(
                  "Tarifi:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                subtitle: Text(
                  "${ordersData['body']}",
                  style:
                  TextStyle(color: Colors.grey, fontSize: w * 0.04),
                ),
                leading: CircleAvatar(
                  child: Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
              ListTile(
                title: Text(
                  "Manzili:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                subtitle: Text(
                  "${ordersData['location']}",
                  style:
                  TextStyle(color: Colors.grey, fontSize: w * 0.04),
                ),
                leading: CircleAvatar(
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
              ListTile(
                title: Text(
                  "Buyurtmachi:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                subtitle: Text(
                  "${ordersData['fullname']}",
                  style:
                  TextStyle(color: Colors.grey, fontSize: w * 0.04),
                ),
                leading: CircleAvatar(
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
              ListTile(
                title: Text(
                  "Telefon:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                subtitle: Text(
                  "+${ordersData['phonenumber']}",
                  style:
                  TextStyle(color: Colors.grey, fontSize: w * 0.04),
                ),
                leading: CircleAvatar(
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: w*0.1, vertical: h*0.01),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Bajarilgan", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: w*0.06),),
                ),
              ),
            ],
          )
              : Center(
            child: CircularProgressIndicator(),
          )),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyOrders()));
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Profile()));
          } else if (index == 0) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeTest()));
          }
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}


