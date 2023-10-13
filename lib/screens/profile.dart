import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mytok_worker/screens/home_test.dart';
import 'package:mytok_worker/screens/my_orders.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  TextEditingController amountController = TextEditingController();
  var box = Hive.box('users');

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Text(
            "Balans: ${box.get('balans')}  ",
            style: TextStyle(color: Colors.white, fontSize: w * 0.04),
          )
        ],
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h * 0.02,
            ),
            Text("Hisobni to'ldirish",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.06)),
            SizedBox(
              height: h * 0.01,
            ),
            ListTile(
              title: Text(
                "Hodim:",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.05),
              ),
              subtitle: Text(
                "${box.get("firstname")} ${box.get("lastname")}",
                style: TextStyle(color: Colors.grey, fontSize: w * 0.04),
              ),
              leading: CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurpleAccent,
              ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    focusColor: AppColors.yellow,
                    labelText: "Summa",
                    prefixIcon: Icon(
                      Icons.monetization_on_outlined,
                      color: AppColors.yellow,
                    ),
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // shape: const StadiumBorder(),
                // elevation: 20,
                backgroundColor: AppColors.yellow,

              ),
              onPressed: () {
                if(amountController.text.length > 3){
                  launchUrl(Uri.parse("https://mytok.uz/flutterapi/payment.php?amount=${amountController.text}&worker_id=${box.get('id')}"));
                  SystemNavigator.pop();
                }
                else{
                  _amountError(context);
                }
              },
              child: Text("To'lash", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 2,
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
          if (index == 0) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeTest()));
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyOrders()));
          } else if (index == 3) {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Profile()));
          }
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}


_amountError(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Xatolik!",
    desc: "Minimal summa 10000 so'm",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () => Navigator.pop(context),
        color: AppColors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}