import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:talabatdelivery/constants.dart';
import 'package:talabatdelivery/screens/mymap.dart';

class SplashScreen extends StatefulWidget {
  static String id='splashscreen';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {

  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    getConnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body:showText(),
    );
  }

  showText(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * .2,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('images/buyicon.png'),
                  ),
                  SizedBox(
                    height:5,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Text(
                      'أشتري الان',
                      style: TextStyle(fontFamily: 'Pacifico', fontSize: 25),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child:CircularProgressIndicator(),
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text("...جاري الاتصال"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      //navigateUser();// It will redirect  after 3 seconds
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyMap(),),);
    });
  }

  _showDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("فشل الاتصال"),
            content: Text("تأكد من ان جهازك متصل بالانترنت"),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("حسنا")
              ),
            ],
          );
        }
    );
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showDialog();
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      //iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {

      /*iswificonnected = true;
      setState(() async {
        wifiBSSID = await (Connectivity().getWifiBSSID());
        wifiIP = await (Connectivity().getWifiIP());
        wifiName = await (Connectivity().getWifiName());
      });*/
    }
  }
}