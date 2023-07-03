import 'package:flutter/material.dart';
import 'package:sportson/ui/NoInternet.dart';
import 'package:sportson/ui/SupportScreen.dart';

import '../resources/StyleResources.dart';

class Functions
{
  static bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
  // Redirect to page
  static void PageRedirection(context,error)
  {
    if(error=="Internet Connection Failure")
      {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> NoInternet())
        );
      }
    else
      {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> SupportScreen())
        );
      }
  }

//  Snackbar

  static ShowSnackbar(context,_scaffoldKey,message,buttontext)
  {
    var snackBar = SnackBar(
      content: Text(message),
      backgroundColor: (Colors.black),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: buttontext,
        textColor: StyleResources.GreenColor,
        onPressed: () {
          _scaffoldKey.currentState.removeCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}