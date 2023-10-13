import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mytok_worker/screens/job.dart';
import 'package:mytok_worker/screens/profile.dart';

import '../utils/colors.dart';
import 'home_test.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  var box = Hive.box('users');
  bool getData = false;
  bool is_empty = false;

  List<Map<String, dynamic>> ordersData = [];

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  Future<void> getOrder() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://mytok.uz/flutterapi/getallhistory.php'));
    request.fields.addAll({'jobid': '${box.get('id')}'});
    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    final data = json.decode(res);
    // print(data);
    // Map valueMap2 = json.decode(res);
    if (data.isEmpty) {
      setState(() {
        getData = true;
        is_empty = true;
      });
    } else {
      setState(() {
        getData = true;
        ordersData = List<Map<String, dynamic>>.from(data);
      });
    }
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
      body: getData
          ? is_empty
              ? Center(
                  child: Text("Ishlar mavjud emas"),
                )
              : FutureBuilder<dynamic>(
                  future: getOrder(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: ordersData.length,
                      itemBuilder: (context, index) {
                        final item = ordersData[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Job(id: "${item['work_id']}")));
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(item['category'] ?? ''),
                              subtitle: Text(item['location'] ?? ''),
                              leading: _buildLeadingIcon(item['category']),
                              trailing: CircleAvatar(
                                backgroundColor: Colors.lightBlueAccent,
                                child: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
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
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyOrders()));
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

_buildLeadingIcon(String category) {
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
