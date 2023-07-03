import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {

  var hint;
  TextEditingController controller;
  bool ispassword;
  TextInputType keyboard;
  FormFieldValidator<String> validator;
  MyTextBox({this.hint,this.controller,this.ispassword,this.keyboard,this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: ispassword,
      keyboardType: keyboard,
      style: TextStyle(color: Color(0xffB2B2B2)),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 25.0,top: 10.0,bottom: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          hintStyle: TextStyle(color: Color(0xffB2B2B2)),
          hintText: hint,
          fillColor: Color(0xff334E69)),

    );
  }
}

