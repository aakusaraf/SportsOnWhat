import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sportson/ui/PackageScreen.dart';
import 'package:sportson/ui/SignUpScreen.dart';

import '../resources/StyleResources.dart';
import '../widgets/MainTitle.dart';

class SignupIntroScreen extends StatefulWidget {

  @override
  State<SignupIntroScreen> createState() => _SignupIntroScreenState();
}

class _SignupIntroScreenState extends State<SignupIntroScreen> {
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
                  SizedBox(height: 70.0),
                MainTitle(
                  text: "SPORTS ON WHAT",
                ),
                  SizedBox(height: 47.0),
                  Text("Welcome to \n Sports on What",textAlign: TextAlign.center,style: TextStyle(
                      fontFamily: 'PoppinsMedium',
                      height: 1.3,
                      fontSize: 24.0,
                      color: StyleResources.WhiteColor
                  ),),
                  SizedBox(height: 25.0),
                  Image.asset("img/ad1.png"),
                  SizedBox(height: 14.0),
                  Image.asset("img/ad2.png"),
                  SizedBox(height: 42.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=> SignUpScreen())
                        );
                      },
                      child: Text("Sign Up"),
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
                  ),
                  SizedBox(height: 16.0),
                RichText(
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.rtl,
                  softWrap: true,
                  maxLines: 1,
                  textScaleFactor: 1,
                  text: TextSpan(
                    text: "Don't want ads? ",
                    style: TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 14.0,
                      color: StyleResources.WhiteColor
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Click Here',
                          recognizer: new TapGestureRecognizer()..onTap = (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> PackageScreen())
                            );
                          },
                          style: TextStyle(
                            fontFamily: 'PoppinsRegular',
                            fontSize: 14.0,
                            color: StyleResources.GreenColor,
                            decoration: TextDecoration.underline,
                          )
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
