import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talabatdelivery/screens/myorder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabatdelivery/constants.dart';
import 'package:talabatdelivery/models/order.dart';
import 'package:talabatdelivery/models/product.dart';

class OrderDetails extends StatefulWidget {
  static String id='orderdetails';

  final List list;
  final int index;
  OrderDetails({this.list,this.index});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  String id,location,marklocation,price,date,name,phone,restname,quantity,deliveryid;
  List product=[];
  List<Order> orderList=[];
  var data,image;
  bool visibility_accept = true;
  bool visibility_call = false;
  int status_accept=1;
  int status_refuse=2;

  SharedPreferences preferences;

  Future getDeliveryId() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      deliveryid=preferences.getString("id");
    });
  }

  Future editDeliveryState() async {
    var url = "https://talabatdelivery.000webhostapp.com/delivery_edit.php";
    var response = await http.post(url, body: {
      "delivery_id" : deliveryid,
      "id"     : id,
    });
    var data = json.decode(response.body);
  }

  Future editStateAccept() async {
    var url = "https://talabatdelivery.000webhostapp.com/delivery_edit_order_delivery_id.php";
    var response = await http.post(url, body: {
      "status" : status_accept.toString(),
      "id"     : id,
    });
    var data = json.decode(response.body);
  }

  Future editStateRefuse() async {
    var url = "https://talabatdelivery.000webhostapp.com/delivery_edit_order_delivery_id.php";
    var response = await http.post(url, body: {
      "status" : status_refuse.toString(),
      "id"     : id,
    });
    var data = json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id           = widget.list[widget.index]['id'];
    restname     = widget.list[widget.index]['restname'];
    name         = widget.list[widget.index]['name'];
    phone        = widget.list[widget.index]['phone'];
    location     = widget.list[widget.index]['location'];
    marklocation = widget.list[widget.index]['marklocation'];
    price        = widget.list[widget.index]['price'];
    date         = widget.list[widget.index]['date'];
    //product.add(widget.list[widget.index]['product']);
    //widget.list[widget.index]['product']=product.map((e) => jsonEncode(e.toJson())).toList().toString();
    //print(widget.list[widget.index]['product']);
    //print(product.length);
    data = json.decode(widget.list[widget.index]['product']);
    product = data.map((j) => Product.fromJson(j)).toList();
    for (final item in product) {
      orderList.add(Order(item.id, item.name, item.image, item.quantity));
      //id = item.id;
      //name = item.name;
      //image=item.image;
      //quantity=item.quantity.toString();
    }
    /*final items = (data as List).map((i) => new Product.fromJson(i));
              for (final item in items) {
                id = item.id;
                name = item.name;
                image=item.image;
                quantity=item.quantity.toString();
                print(item.id);
              }*/
    //print(product.length);
    getDeliveryId();
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0,
        title: Text(
          'تفاصيل الطلب',
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
      persistentFooterButtons: <Widget>[
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibility_call,
          child: Padding(
              padding: const EdgeInsets.only(right: 140,left: 110),
              child:FloatingActionButton(
                onPressed:(){
                  launch(('tel://${phone}'));
                },
                child: Icon(Icons.call),
                backgroundColor: Colors.black,
              )
            ),
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibility_accept,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                      child: Text(
                        'رفض',
                        style: TextStyle(color: Colors.white,fontSize: 18),
                      ),
                    ),
                    onPressed: (){
                      editStateRefuse();
                      Navigator.popAndPushNamed(context,MyOrder.id);
                    }
                ),
              SizedBox(
                width: screenHeight * .2,
              ),
              FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                      child: Text(
                        'قبول',
                        style: TextStyle(color: Colors.white,fontSize: 18),
                      ),
                    ),
                    onPressed: (){
                      editStateAccept();
                      editDeliveryState();
                      setState(() {
                        visibility_accept=false;
                        visibility_call=true;
                      });
                    }
                ),
            ],
          ),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    '   : أسم العميل',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'SDG ${price.toString()}',
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
                    restname,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    '   : المطعم',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Text(
                date,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'السله',
                style: TextStyle(color: Colors.black),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        height: screenHeight * .15,
                        child: Row(
                          children: <Widget>[
                            Image.network(orderList[index].image),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          (orderList[index].name),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          ('${orderList[index].quantity.toString()}  :  الكميه'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        color: kSecondaryColor,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}