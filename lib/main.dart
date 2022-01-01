import 'package:flutter/material.dart';
import 'package:talabatdelivery/constants.dart';
import 'package:talabatdelivery/screens/login.dart';
import 'package:talabatdelivery/screens/mymap.dart';
import 'package:talabatdelivery/provider/mudelHud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabatdelivery/screens/myorder.dart';
import 'package:talabatdelivery/screens/orderdetails.dart';
import 'package:talabatdelivery/screens/register.dart';
import 'package:talabatdelivery/screens/splashscreen.dart';
import 'package:talabatdelivery/screens/profile.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Loading....'),
              ),
            ),
          );
        }else {
          isUserLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelHud>(
                create: (context) => ModelHud(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: isUserLoggedIn ? SplashScreen.id : login.id,
              //initialRoute: MyMap.id,
              routes: {
                SplashScreen.id: (context) => SplashScreen(),
                MyMap.id: (context) => MyMap(),
                login.id: (context) => login(),
                register.id: (context) => register(),
                Profile.id: (context) => Profile(),
                MyOrder.id: (context) => MyOrder(),
                OrderDetails.id: (context) => OrderDetails(),
              },
            ),
          );
        }
      },
    );
  }
}
