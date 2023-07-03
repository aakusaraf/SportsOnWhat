import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportson/models/UserData.dart';
import 'package:sportson/resources/StyleResources.dart';
import 'package:sportson/ui/HomeScreen.dart';
import 'package:sportson/ui/MyProfileScreen.dart';
import 'package:sportson/ui/SignInScreen.dart';
import 'package:sportson/ui/WelcomeScreen.dart';

import '../provider/AuthProvider.dart';
import '../provider/DarkThemeProvider.dart';
import '../widgets/MainTitle.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthProvider provider;
  checklogin() async
  {
    print("we are here to check login");
    // await provider.viewGame(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("islogin"))
      {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        provider.loggedinuser = UserData.fromJson(jsonDecode(prefs.getString("userdata")));
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>HomeScreen())
        );
      }
    else
      {
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>SignInScreen())
        );
      }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<AuthProvider>(context, listen: false);
    // checklogin();
    // Timer.periodic(const Duration(milliseconds: 600), (time) {
    //
    // });
    Future.delayed(Duration(seconds: 3)).then((value) {
      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context)=>HomeScreen())
      // );
      print("we are here ");
      checklogin();

    });
  }
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context,listen: true);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: StyleResources.BlueColor,
        alignment: Alignment.center,
        child: MainTitle(
          text: "SPORTS ON WHAT",
        ),
      ),
    );
  }
}
