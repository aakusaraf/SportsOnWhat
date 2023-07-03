import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:sportson/ui/ResetPassword.dart';

import '../provider/AuthProvider.dart';
import '../resources/StyleResources.dart';
import '../utlity/Functions.dart';
import '../widgets/MainTitle.dart';

class ForgotPasswordOTP extends StatefulWidget {
  @override
  State<ForgotPasswordOTP> createState() => _ForgotPasswordOTPState();
}

class _ForgotPasswordOTPState extends State<ForgotPasswordOTP> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var otp="";
  AuthProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<AuthProvider>(context, listen: false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: StyleResources.BlueColor,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: StyleResources.ContainerSize,right: StyleResources.ContainerSize),
                color: StyleResources.BlueColor,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.keyboard_backspace,color: Colors.white,size: 30.0),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 25.0,),
                          Text("OTP",style: TextStyle(
                              fontFamily: 'PoppinsSemiBold',
                              fontSize: 20.0,
                              color: StyleResources.WhiteColor
                          ))
                        ],
                      ),
                      SizedBox(height: 50.0),
                      RichText(
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.end,
                        textDirection: TextDirection.rtl,
                        softWrap: true,
                        maxLines: 1,
                        textScaleFactor: 1,
                        text: TextSpan(
                          text: "Code is sent to ",
                          style: TextStyle(
                              fontFamily: 'PoppinsSemiBold',
                              fontSize: 20.0,
                              color: StyleResources.WhiteColor
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "test@gmail.com",
                                style: TextStyle(
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: 20.0,
                                  color: StyleResources.GreenColor,
                                )
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.0),
                      OtpTextField(
                        numberOfFields: 4,
                        borderColor: Color(0xffB2B2B2),
                        margin: EdgeInsets.all(15.0),
                        borderWidth: 1.0,
                        fieldWidth: 50.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          decorationThickness: 1.0,
                          color: Color(0xffB2B2B2),
                        ),
                        //set to true to show as box or false to show as dash
                        showFieldAsBox: true,
                        //runs when a code is typed in
                        onCodeChanged: (String code) {
                          //handle validation or checks here
                        },
                        //runs when every textfield is filled
                        onSubmit: (String verificationCode){
                          setState(() {
                            otp=verificationCode;
                          });
                        }, // end onSubmit
                      ),
                      SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async{
                            if(otp=="" || otp.length!=4)
                            {
                              Functions.ShowSnackbar(context,_scaffoldKey, "Please Enter OTP","OK");
                            }
                            else
                            {
                              if(otp!=provider.emailotp)
                              {
                                Functions.ShowSnackbar(context,_scaffoldKey, "OTP mismatch!","OK");
                              }
                              else
                              {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ResetPassword())
                                );
                              }
                            }


                          },
                          child: Text("Submit"),
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
                      SizedBox(height: 14.0),
                      RichText(
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.end,
                        textDirection: TextDirection.rtl,
                        softWrap: true,
                        maxLines: 1,
                        textScaleFactor: 1,
                        text: TextSpan(
                          text: "Not Received OTP ?",
                          style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              fontSize: 14.0,
                              color: StyleResources.WhiteColor
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Resend',
                                recognizer: new TapGestureRecognizer()..onTap = (){

                                },
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: 14.0,
                                  color: StyleResources.GreenColor,
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
