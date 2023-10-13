import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mytok_worker/screens/home_screen.dart';
import 'package:mytok_worker/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../firebase_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  var box = Hive.box('users');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.yellow,
        image: DecorationImage(
          image: const AssetImage("assets/images/logo.png"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.yellow,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('assets/images/logo.png'),
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        color: AppColors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hodim ilovasi",
          style: TextStyle(
              color: AppColors.black,
              fontSize: 32,
              fontWeight: FontWeight.w500),
        ),
        _buildGreyText("MyTok tezkor va sifatli xizmat"),
        const SizedBox(height: 60),
        _buildGreyText("Telefon"),
        _buildInputField(emailController),
        const SizedBox(height: 40),
        _buildGreyText("Parol"),
        _buildPasswordInputField(passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildPasswordInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }


  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        final firebaseApi = FirebaseApi();
        final fcmToken = await firebaseApi.getFCMToken();
        final connectivityResult = await (Connectivity().checkConnectivity());
        if ((emailController.text.length == 12) &&
            (emailController.text.startsWith("998"))) {
          if (passwordController.text.length < 8) {
            _onBasicAlertPressedValidatePassword(context);
          } else {
            if (connectivityResult != ConnectivityResult.none) {
              var request = http.MultipartRequest(
                  'POST', Uri.parse('https://mytok.uz/flutterapi/login.php'));
              request.fields.addAll({
                'phonenumber': '${emailController.text}',
                'password': '${passwordController.text}'
              });
              setState(() {
                _isLoading = true;
              });
              http.StreamedResponse response = await request.send();
              if (response.statusCode == 200) {
                var res = await response.stream.bytesToString();
                Map valueMap = json.decode(res);
                // print(valueMap);
                if (valueMap['success'] == false) {
                  _onBasicAlertPressed(context);
                  setState(() {
                    _isLoading = false;
                  });
                } else if (valueMap['success'] == true) {
                  var request2 = http.MultipartRequest(
                      'POST', Uri.parse('https://mytok.uz/flutterapi/fcmupdate.php'));
                  request2.fields.addAll({
                    'id': "${valueMap['data']['id']}",
                    'fmctoken': '${fcmToken}'
                  });
                  http.StreamedResponse response2 = await request2.send();
                  var res2 = await response2.stream.bytesToString();
                  Map valueMap2 = json.decode(res2);
                  print(valueMap2);
                  if((valueMap2['message'] == "Hech qanday yozuv yangilanmagan.") || (valueMap2['message'] == "Yangilanish muvaffaqiyatli")){
                    box.put('id', valueMap['data']['id']);
                    box.put('firstname', valueMap['data']['username']);
                    box.put('lastname', valueMap['data']['fristname']);
                    box.put('phone', valueMap['data']['phone_number']);
                    box.put('balans', valueMap['data']['balans']);
                    box.put('password', '${passwordController.text}');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                    setState(() {
                      _isLoading = false;
                    });
                  }
                  else{
                    _apiError(context);
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              } else {
                setState(() {
                  _isLoading = false;
                });
                _apiError(context);
              }
            } else {
              _internetError(context);
              setState(() {
                _isLoading = false;
              });
            }
          }
        } else {
          _onBasicAlertPressedValidatePhone(context);
          setState(() {
            _isLoading = false;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        backgroundColor: AppColors.black,
        minimumSize: const Size.fromHeight(60),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const Text(
              "KIRISH",
              style: TextStyle(color: AppColors.white),
            ),
    );
  }
}

_onBasicAlertPressed(context) {
  Alert(
    context: context,
    type: AlertType.info,
    title: "Xatolik!",
    desc: "Login yoki parol xato",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        color: AppColors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

_onBasicAlertPressedValidatePassword(context) {
  Alert(
    context: context,
    type: AlertType.info,
    title: "Xatolik!",
    desc: "Parol 8 ta belgidan iborat bo'lsin",
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

_onBasicAlertPressedValidatePhone(context) {
  Alert(
    context: context,
    type: AlertType.info,
    title: "Xatolik!",
    desc: "Telefon raqamni quidagicha kiriting:\n998 XX XXX XX XX",
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

_internetError(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Xatolik!",
    desc: "Internetga ulanmagansiz",
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

_apiError(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Xatolik!",
    desc: "API da nosozlik",
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


