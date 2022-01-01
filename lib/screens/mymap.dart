import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:talabatdelivery/screens/myorder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:android_intent/android_intent.dart';
import 'package:talabatdelivery/constants.dart';
import 'package:talabatdelivery/screens/profile.dart';
import 'package:talabatdelivery/screens/login.dart';

class OrderInfo {
  //Constructor
  String id;
  String name;
  String phone;
  String restname;
  String product;
  String price;
  String date;
  String delivery_id;

  OrderInfo.fromJson(Map json) {
    this.id       = json['id'];
    this.name     = json['name'];
    this.phone    = json['phone'];
    this.restname = json['restname'];
    this.product  = json['product'];
    this.price    = json['price'];
    this.date     = json['date'];
    this.delivery_id     = json['delivery_id'];
  }
}

class MyMap extends StatefulWidget {
  static String id ="map";
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MyMap> {

  MapboxMapController mapController;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LatLng currentPostion;
  Location _location = Location();
  String id,name,phone;
  String customername,customerphone,restname,product,price,date,delivery_id;
  SharedPreferences preferences;
  bool isSwitchedFT = false;
  int statuson=1,statusoff=0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool visibilityCount = false;

  Future saveLocation(double lat,double long) async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = "https://talabatdelivery.000webhostapp.com/delivery_save_location.php";
    var response = await http.post(url, body: {
      "lat" : lat.toString(),
      "long": long.toString(),
      "id"  : preferences.getString("id"),
    });
    var data = json.decode(response.body);
  }

  Future editState(int status) async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = "https://talabatdelivery.000webhostapp.com/delivery_edit_status.php";
    var response = await http.post(url, body: {
      "status" : status.toString(),
      "id"  : preferences.getString("id"),
    });
    var data = json.decode(response.body);
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _location.onLocationChanged.listen((l) {
      saveLocation(l.latitude, l.longitude);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 16),
        ),
      );
    });
  }

  Future getUser() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      name=preferences.getString("name");
      phone=preferences.getString("phone") ;
    });
  }

  Future<void> signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("name");
      preferences.remove("phone");
      preferences.remove("password");
      preferences.remove("id");
      pref.clear();
      Navigator.popAndPushNamed(context, login.id);
    });
  }

  savePref(String name,String phone,String restname,String product,String price,String date,String id,String delivery_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("customername", name);
      preferences.setString("customerphone", phone);
      preferences.setString("restname", restname);
      preferences.setString("product", product);
      preferences.setString("price", price);
      preferences.setString("date", date);
      preferences.setString("id", id);
      preferences.setString("delivery_id", delivery_id);
      preferences.commit();
    });
  }

  Future getOrderInfo() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      customername  = preferences.getString("customername");
      customerphone = preferences.getString("customerphone");
      restname      = preferences.getString("restname");
      product       = preferences.getString("product");
      price         = preferences.getString("price");
      date          = preferences.getString("date");
      delivery_id          = preferences.getString("delivery_id");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationServiceInDevice();
    getUser();
    getSwitchState();
    //initializeNotifications();
    getOrderInfo();
  }

  initializeNotifications() async {
    var android = AndroidInitializationSettings('@mipmap/launcher_icon');//icon will display when notification appears
    var ios = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      //debugPrint('notification payload: ' + payload);
    }
    Navigator.popAndPushNamed(context, MyMap.id);
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState((){
      preferences.setBool("switchState", value);
      //print('Switch Value saved $value');
    });
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bool isSwitchedFT = prefs.getBool("switchState");
      //print(isSwitchedFT);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: new Drawer(
          child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: kMainColor,
                  ),
                  accountName: Text(name !=null?name:"Your name here",style: TextStyle(fontSize: 20),),
                  accountEmail: Text(phone !=null?phone:"Your phone here",style: TextStyle(fontSize: 20),),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    ListTile(
                      dense: true,
                      title: Text("الملف الشخصي", style: TextStyle(color: Colors.black),),
                      leading: Icon(Icons.person),
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pushNamed(context,Profile.id);
                      },
                    ),
                    ListTile(
                      title: Text("الطلبات", style: TextStyle(color: Colors.black),),
                      leading: Icon(Icons.shopping_basket),
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pushNamed(context,MyOrder.id);
                      },
                    ),
                    ListTile(
                      dense: true,
                      title: Text("تسجيل خروج", style: TextStyle(color: Colors.black),),
                      leading: Icon(Icons.logout),
                      onTap: (){
                        Navigator.pop(context);
                        signOut();
                        Navigator.pushNamed(context,login.id);
                      },
                    ),

                  ],),
                ),
              ]
          ),
        ),
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation: 0,
          iconTheme: new IconThemeData(color: Colors.black),
          actions: <Widget>[
            Row(
              children: [
                Text(
                  "${isSwitchedFT ? "متصل" : "غير متصل"}",
                  style: TextStyle(fontSize: 18.0,
                  color: Colors.black),
                ),
                Switch(
                  value: isSwitchedFT,
                  onChanged: (value){
                    setState(() {
                      isSwitchedFT=value;
                      saveSwitchState(value);
                      if(value==true){
                        editState(statuson);
                      }else{
                        editState(statusoff);
                      }
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                )
              ],
            )

          ],
        ),
        body:WillPopScope(
          onWillPop:(){
            SystemNavigator.pop();
            return Future.value(false);
          },
          child:Stack(
            children: [
              MapboxMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                const CameraPosition(target: LatLng(0.0, 0.0),
                  //zoom: 18
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.only(top: 350),
//                child: FutureBuilder(
//                  future: getOrder(),
//                  builder: (context, snapshot) {
//                    if (snapshot.hasError) print(snapshot.error);
//                    return snapshot.hasData ?
//                    ListView.builder(
//                        itemCount: snapshot.data.length,
//                        itemBuilder: (context, index) {
//                          List list = snapshot.data;
//                          return Visibility(
//                              maintainSize: true,
//                              maintainAnimation: true,
//                              maintainState: true,
//                              visible: visibilityCount,
//                              child: Container(
//                                color: Colors.white,
//                                child: Padding(
//                                  padding: const EdgeInsets.all(15),
//                                  child: Column(
//                                    children: [
//                                      Row(
//                                        mainAxisAlignment: MainAxisAlignment.end,
//                                        children: <Widget>[
//                                          Text(
//                                            list[index]['name']!=null?list[index]['name']:"customername",
//                                            style: TextStyle(color: Colors.black,fontSize: 18),
//                                          ),
//                                          Text(
//                                            '  : أسم الزبون',
//                                            style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
//                                          ),
//                                        ],
//                                      ),
//                                      FloatingActionButton(
//                                        onPressed:(){
//                                          launch(('tel://${list[index]['phone']}'));
//                                        },
//                                        child: Icon(Icons.call),
//                                        backgroundColor: Colors.black,
//                                      ),
//                                      Row(
//                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                        children: <Widget>[
//                                          Builder(
//                                            builder: (context) => FlatButton(
//                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                                                color: Colors.black,
//                                                child: Padding(
//                                                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 5),
//                                                  child: Text(
//                                                    'رفض',
//                                                    style: TextStyle(color: Colors.white,fontSize: 18),
//                                                  ),
//                                                ),
//                                                onPressed: (){
//                                                  setState(() {
//                                                    visibilityCount = false ;
//                                                  });
//                                                }
//                                            ),
//                                          ),
//                                          Builder(
//                                            builder: (context) => FlatButton(
//                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                                                color: Colors.black,
//                                                child: Padding(
//                                                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 5),
//                                                  child: Text(
//                                                    'قبول',
//                                                    style: TextStyle(color: Colors.white,fontSize: 18),
//                                                  ),
//                                                ),
//                                                onPressed: (){
//                                                  setState(() {
//                                                    visibilityCount = false ;
//                                                  });
//                                                }
//                                            ),
//                                          )
//                                        ],
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            );
//                        })
//                        : new Center(
//                      //child: new CircularProgressIndicator(),
//                    );
//                  },
//                ),
//              ),
            ],
          )
        )
    );
  }

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  Future<void> checkLocationServiceInDevice() async{
    Location location = Location();
    _serviceEnabled=await location.serviceEnabled();
    if(_serviceEnabled){
      _permissionGranted = await location.hasPermission();
      if(_permissionGranted == PermissionStatus.granted){
        //_location= await location.getLocation();
        //print(_location.latitude.toString()+" "+_location.longitude.toString());
        /*location.onLocationChanged.listen((LocationData currentLocation) {
          setState(() {
            currentPostion = LatLng(currentLocation.latitude, currentLocation.longitude);
          });
          //print("my location "+currentLocation.latitude.toString()+" "+currentLocation.longitude.toString());
        });*/
      }
      else{
        _permissionGranted = await location.requestPermission();
        if(_permissionGranted == PermissionStatus.granted){
          print("start allowed");
        }else{
          SystemNavigator.pop();
        }
      }
    }
    else{
      _serviceEnabled=await location.requestService();
      if(_serviceEnabled){
        print("start traking");
      }else{
        SystemNavigator.pop();
      }
    }
  }
}