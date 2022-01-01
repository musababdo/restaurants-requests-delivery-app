import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:talabatdelivery/constants.dart';
import 'package:talabatdelivery/screens/login.dart';
import 'package:talabatdelivery/provider/mudelHud.dart';
import 'package:talabatdelivery/widgets/customTextView.dart';

class register extends StatefulWidget {
  static String id = 'SignupScreen';

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  int _state=0;

  String _username, _password,_phone;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    Future register() async {
      var url = "https://talabatdelivery.000webhostapp.com/delivery_register.php";
      var response = await http.post(url, body: {
        "username": _username.trim(),
        "password": _password.trim(),
        "phone": _phone.trim(),
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        Fluttertoast.showToast(
            msg: "الحساب موجود",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        Fluttertoast.showToast(
            msg: "تم الحفظ بنجاح",
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
      }
    }

    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        //inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: height * .2,
              ),
              CustomTextField(
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: (){
                      if (_state == 0) {
                        animateButton();
                      }
                      if (_globalKey.currentState.validate()){
                        _globalKey.currentState.save();
                        try{
                          register();
                        }on PlatformException catch(e){

                        }
                      }else{
                        setState(() {
                          _state = 0;
                        });
                      }
                    },
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: setUpButtonChild(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'تسجيل دخول   ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    'لديك حساب ؟',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        'انشاء حساب',
        style: TextStyle(color: Colors.white),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }
}