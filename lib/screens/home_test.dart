import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mytok_worker/screens/job_details.dart';
import 'package:mytok_worker/screens/my_orders.dart';
import 'package:mytok_worker/screens/profile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:web_socket_channel/io.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hive/hive.dart';
import 'package:mytok_worker/utils/colors.dart';
import 'package:http/http.dart' as http;

class HomeTest extends StatefulWidget {
  HomeTest({Key? key}) : super(key: key);

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List<Map<String, dynamic>> ordersData = [];
  bool isWebSocketConnected = false;
  late int status = 0;
  late bool is_loading = false;

  @override
  void initState() {
    super.initState();
    getBalans();
    fetchData();
  }

  Future<void> getBalans() async {
    var request = http.MultipartRequest('POST', Uri.parse('https://mytok.uz/flutterapi/getbalans.php'));
    request.fields.addAll({
      'jobid': '${box.get('id')}'
    });
    http.StreamedResponse response = await request.send();
    var balans_new = await response.stream.bytesToString();
    box.put('balans', "${balans_new}");
  }

  Future<void> fetchData() async {
    var request = http.MultipartRequest(
        'GET', Uri.parse('https://mytok.uz/API/databaseconnect.php'));
    request.fields.addAll({
      'region_id' : box.get("region_id")
    });

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();
        final data = json.decode(res);
        // Map valueMap = json.decode(res);
        // print(valueMap);
        if (data.isEmpty) {
          setState(() {
            status = -5;
          });
        } else {
          setState(() {
            status = 1;
            ordersData = List<Map<String, dynamic>>.from(data);
          });
        }
      } else {
        setState(() {
          status = -1;
        });
      }
    } else {
      setState(() {
        status = -2;
      });
    }
  }

  var box = Hive.box('users');


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var region_name = box.get('region_name');
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "My tok",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Text("Balans: ${box.get('balans')} ", style: TextStyle(color: Colors.white, fontSize: w*0.04),)
        ],
        backgroundColor: AppColors.yellow,
      ),
      body: FutureBuilder<dynamic>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (status == 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (status == -5) {
            return Center(
              child: Text('Buyurtmalar mavjud emas'),
            );
          } else if (status == -1) {
            return Center(
              child: Text('API da nosozlik'),
            );
          } else if (status == -2) {
            return Center(
              child: Text('Internetga ulanmagansiz'),
            );
          } else {
            final data = ordersData;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return GestureDetector(
                  onTap: () async {
                    if(int.parse(item['balans']) <= int.parse(box.get('balans'))){
                      _buildForm(context, item['id'], item['balans']);
                    }
                    else{
                      _balansError(context);
                    }
                  },
                  child: Card(
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
                      trailing: CircleAvatar(
                        backgroundColor: AppColors.yellow,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyOrders()));
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Profile()));
          } else if (index == 3) {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Profile()));
          }
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  void _buildForm(BuildContext context, String id, String balans) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Xabar!",
      desc: "Ishni qabul qilasizmi?",
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => JobDetails(id: id, balans: balans,)));
          },
          child: Text(
            "Qabul qilish",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          color: AppColors.black,
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
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


_balansError(context) {
  Alert(
    context: context,
    type: AlertType.info,
    title: "Xatolik!",
    desc: "Balans yetarli emas",
    buttons: [
      DialogButton(
        child: Text(
          "To'ldirish",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(),
          ),
        ),
        color: AppColors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}


