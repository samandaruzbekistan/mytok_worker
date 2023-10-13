import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hive/hive.dart';
import 'package:mytok_worker/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class JobDetails extends StatefulWidget {
  JobDetails({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    var is_loading = true;
    getOrder();
  }

  getOrder(){
    print(5);
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
        child: Column(
          children: [
            ListTile(
              title: Text("Ish turi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: w*0.05),),
              subtitle: Text("Shit ishlari", style: TextStyle(color: Colors.grey, fontSize: w*0.04),),
              leading: CircleAvatar(child: Icon(Icons.workspaces_outline, color: Colors.white,), backgroundColor: Colors.deepPurpleAccent,),
            ),
            ListTile(
              title: Text("Buyurtma nomi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: w*0.05),),
              subtitle: Text("Shit ishlari", style: TextStyle(color: Colors.grey, fontSize: w*0.04),),
              leading: CircleAvatar(child: Icon(Icons.abc, color: Colors.white,), backgroundColor: Colors.deepPurpleAccent,),
            ),
            ListTile(
              title: Text("Tarifi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: w*0.05),),
              subtitle: Text("Shit ishlari", style: TextStyle(color: Colors.grey, fontSize: w*0.04),),
              leading: CircleAvatar(child: Icon(Icons.comment, color: Colors.white,), backgroundColor: Colors.deepPurpleAccent,),
            ),
            ListTile(
              title: Text("Manzili:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: w*0.05),),
              subtitle: Text("Shit ishlari", style: TextStyle(color: Colors.grey, fontSize: w*0.04),),
              leading: CircleAvatar(child: Icon(Icons.location_on_outlined, color: Colors.white,), backgroundColor: Colors.deepPurpleAccent,),
            ),
            ListTile(
              title: Text("Buyurtmachi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: w*0.05),),
              subtitle: Text("Shit ishlari", style: TextStyle(color: Colors.grey, fontSize: w*0.04),),
              leading: CircleAvatar(child: Icon(Icons.person_outline, color: Colors.white,), backgroundColor: Colors.deepPurpleAccent,),
            ),
            ListTile(
              title: Text("Telefon:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: w*0.05),),
              subtitle: Text("Shit ishlari", style: TextStyle(color: Colors.grey, fontSize: w*0.04),),
              leading: CircleAvatar(child: Icon(Icons.phone, color: Colors.white,), backgroundColor: Colors.deepPurpleAccent,),
            ),
            SizedBox(height: h*0.03,),
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 30,
                child: IconButton(
                  icon: Icon(Icons.phone, color: Colors.white,),
                  onPressed: (){
                    launchUrl(Uri.parse('tel:' + "+998975672009"));
                  },
                ),
              ),
            ),
          ],
        ),
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