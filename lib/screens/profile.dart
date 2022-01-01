import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabatdelivery/constants.dart';
import 'package:talabatdelivery/screens/mymap.dart';
import 'package:talabatdelivery/screens/login.dart';
import 'package:talabatdelivery/provider/mudelHud.dart';
import 'package:talabatdelivery/widgets/customTextView.dart';

class proInfo {
  //Constructor
  String username;
  String password;
  String phone;

  proInfo.fromJson(Map json) {
    username = json['username'];
    password = json['password'];
    phone = json['phone'];
  }
}

class Profile extends StatefulWidget {
  static String id='profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _username=new TextEditingController();
  TextEditingController _password=new TextEditingController();
  TextEditingController _phone   =new TextEditingController();

  int _statedit=0;
  int _statedelete=0;

  SharedPreferences preferences;

  Future getProfile() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _username.text=preferences.getString("name");
      _password.text=preferences.getString("password") ;
      _phone.text=preferences.getString("phone") ;
    });
    print(preferences.getString("password"));
  }

  Future editProfile() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = "https://talabatdelivery.000webhostapp.com/delivery_edit_profile.php";
    var response = await http.post(url, body: {
      "username": _username.text,
      "password": _password.text,
      "phone"   : _phone.text,
      "id"      : preferences.getString("id"),
    });
    var data = json.decode(response.body);
    String success = data['success'];
    if (success == "1") {
      Fluttertoast.showToast(
          msg: "تم تعديل الملف الشخصي",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        Navigator.popAndPushNamed(context, MyMap.id);
      });
    } else {
      Fluttertoast.showToast(
          msg: "هنالك خطاء ما ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Future deleteProfile() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = "https://talabatdelivery.000webhostapp.com/delivery_delete_profile.php";
    var response = await http.post(url, body: {
      "id": preferences.getString("id"),
    });
    var data = json.decode(response.body);
    String success = data['success'];
    if (success == "1") {
      Fluttertoast.showToast(
          msg: "تم حذف الملف الشخصي",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        Navigator.popAndPushNamed(context, login.id);
      });
    } else {
      Fluttertoast.showToast(
          msg: "هنالك خطاء ما",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  bool _secureText = true;
  void showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor:Colors.transparent,
        elevation: 0,
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: height * .1,
              ),
              CustomTextField(
                controller:_username,
                onClick: (value) {
                  _username=value;
                },
                icon: Icons.perm_identity,
                hint: 'الاسم',
              ),
              SizedBox(
                height: height * .02,
              ),
              CustomTextField(
                controller:_password,
                onClick: (value) {
                  _password = value;
                },
                hint: 'كلمه المرور',
                icon: Icons.lock,
              ),
              SizedBox(
                height: height * .02,
              ),
              CustomTextField(
                controller:_phone,
                onClick: (value) {
                  _phone=value;
                },
                icon: Icons.phone,
                hint: 'الهاتف',
              ),
              SizedBox(
                height: height * .05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Builder(
                  builder: (context) => FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: editPro(),
                      ),
                      onPressed: (){
                        if (_statedit == 0) {
                          animateButtonedit();
                        }
                        editProfile();
                      }
                  ),
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Builder(
                  builder: (context) => FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: deletePro(),
                      ),
                      onPressed: (){
                        _showDialog();
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _showDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title:Text("هل تود حذف حسابك"),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    if (_statedelete == 0) {
                      animateButtondelite();
                    }
                    deleteProfile();
                    Navigator.of(context).pop();
                  },
                  child: Text("نعم")
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("لا")
              ),
            ],
          );
        }
    );
  }
  Widget editPro() {
    if (_statedit == 0) {
      return new Text(
        'تعديل الملف الشخصي',
        style: TextStyle(color: Colors.white),
      );
    } else if (_statedit == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
  Widget deletePro() {
    if (_statedelete == 0) {
      return new Text(
        'حذف الملف الشخصي',
        style: TextStyle(color: Colors.white),
      );
    } else if (_statedelete == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
  void animateButtonedit() {
    setState(() {
      _statedit = 1;
    });
  }
  void animateButtondelite() {
    setState(() {
      _statedelete = 1;
    });
  }
}