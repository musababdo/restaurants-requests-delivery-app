import 'package:flutter/material.dart';
import 'package:talabatdelivery/constants.dart';

class CustomTextField extends StatefulWidget {

  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final Function onClick;
  final Function myfun;
  final Function showHide;
  bool secure=true;
  String _errorMessage(String str) {
    switch (hint) {
      case 'الاسم':
        return 'الرجاء ادخال الاسم';
      case 'كلمه المرور':
        return 'الرجاء ادخال كلمه المرور';
      case 'الهاتف':
        return 'الرجاء ادخال الهاتف';
      case 'الموقع':
        return 'الرجاء ادخال الموقع';
      case 'معلم بارز':
        return 'الرجاء ادخال معلم بارز';
    }
  }

  CustomTextField({@required this.showHide,@required
  this.myfun,@required this.onClick, @required this.icon,
    @required this.hint, @required this.controller});

  @override
  stateCustom createState() => stateCustom();

}

class stateCustom extends State<CustomTextField>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value.isEmpty) {
            return widget._errorMessage(widget.hint);
            // ignore: missing_return
          }
        },
        onSaved: widget.onClick,
        onTap:widget.myfun,
        obscureText: widget.hint == 'كلمه المرور' ? widget.secure : false,
        keyboardType: widget.hint == 'الهاتف' ? TextInputType.number : TextInputType.text ,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: Icon(
            widget.icon,
            color: kMainColor,
          ),
          suffixIcon: IconButton(
            onPressed: (){
              setState(() {
                widget.secure = !widget.secure;
              });
            },
            icon: Icon(widget.hint == 'كلمه المرور' ? widget.secure
                ? Icons.visibility_off
                : Icons.visibility : null),
          ),
          filled: true,
          fillColor: kSecondaryColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }

}