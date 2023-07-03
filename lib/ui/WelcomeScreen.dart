import 'package:flutter/material.dart';
import 'package:sportson/ui/HomeScreen.dart';
import 'package:sportson/ui/PackageScreen.dart';
import 'package:sportson/ui/SignUpScreen.dart';
import 'package:sportson/ui/SignupIntroScreen.dart';

import '../resources/StyleResources.dart';
import '../widgets/MainTitle.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: StyleResources.BlueColor,
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: StyleResources.ContainerSize,right: StyleResources.ContainerSize),
            color: StyleResources.BlueColor,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 113.0),
                MainTitle(
                  text: "SPORTS ON WHAT",
                ),
                  SizedBox(height: 244.0),
                  Text("Welcome to \n Sports on What",textAlign: TextAlign.center,style: TextStyle(
                      fontFamily: 'PoppinsMedium',
                      height: 1.3,
                      fontSize: 24.0,
                      color: StyleResources.WhiteColor
                  ),),
                  SizedBox(height: 54.0),
                  Text("Don't want the ads?",textAlign: TextAlign.center,style: TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 16.0,
                      color: StyleResources.WhiteColor
                  ),),
                  SizedBox(height: 15.0),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>PackageScreen())
                        );
                      },
                      child: Text("Join for \$1.99/month"),
                      style:  ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(left: 22.0,right: 22.0,top: 11.0,bottom: 11.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        primary: StyleResources.GreenColor,
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PoppinsMedium',
                            fontWeight: FontWeight.bold)
                      ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> HomeScreen())
                      );
                    },
                    child: Text(
                      'Continue with ads',
                      style: TextStyle(
                        color: StyleResources.GreenColor,
                        fontSize: 14,
                        fontFamily: 'PoppinsRegular',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
