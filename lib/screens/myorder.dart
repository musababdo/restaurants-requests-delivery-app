import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:talabatdelivery/constants.dart';
import 'package:talabatdelivery/screens/orderdetails.dart';

class MyOrder extends StatefulWidget {
  static String id = 'myorder';
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {

  SharedPreferences preferences;

  Future getOrder() async{
    var url = 'https://talabatdelivery.000webhostapp.com/display_delivery_order.php';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Stream orders() async* {
    while (true) {
      await Future.delayed(Duration(microseconds: 1));
      yield await getOrder();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getOrder();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0,
        title: Text(
          'طلباتي',
          style: TextStyle(color: Colors.black),
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
      body: StreamBuilder(
        stream: orders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          try {
            if(snapshot.data.length > 0 ){
              return snapshot.hasData ?
              ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data;
                    return Container(
                      child: Card(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'SDG ${list[index]['price']}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    '  : السعر',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    list[index]['restname'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    '   : المطعم',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      ////
                                    },
                                    child: GestureDetector(
                                      onTap:(){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(list: list,index: index,),),);                                      },
                                      child: Text(
                                        'التفاصيل',
                                        style: TextStyle(color: kMainColor),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    list[index]['date'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                  : new Center(
                child: new CircularProgressIndicator(),
              );
            }else{
              return Container(
                height: screenHeight -
                    (screenHeight * .08) -
                    appBarHeight -
                    statusBarHeight,
                child: Center(
                  child: Text('لايوجد طلبات',
                    style: TextStyle(
                        fontSize: 30
                    ),
                  ),
                ),
              );
            }
          }catch(e){
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}