import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportson/ui/ForgotPasswordOTP.dart';
import 'package:sportson/ui/PackageScreen.dart';
import 'package:sportson/ui/SignInScreen.dart';
import 'package:sportson/ui/SignUpScreen.dart';

import '../provider/AuthProvider.dart';
import '../resources/StyleResources.dart';
import '../utlity/Functions.dart';
import '../widgets/MainTitle.dart';
import '../widgets/MyTextbox.dart';
import '../widgets/loading_screen.dart';
import 'ForgotPassword.dart';
import 'HomeScreen.dart';
import 'OTPScreen.dart';

class ResetPassword extends StatefulWidget {

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var formkey = new GlobalKey<FormState>();
  BuildContext ctx;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading=false;
  TextEditingController _password = TextEditingController();
  AuthProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<AuthProvider>(context, listen: false);
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      ctx=context;
    });
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
                  child: Form(
                    key: formkey,
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
                            Text("Reset Password",style: TextStyle(
                                fontFamily: 'PoppinsSemiBold',
                                fontSize: 20.0,
                                color: StyleResources.WhiteColor
                            ))
                          ],
                        ),

                        SizedBox(height: 32.0),
                        MyTextBox(
                            hint: "New Password",
                            controller: _password,
                            ispassword: true,
                            keyboard: TextInputType.text,
                            validator: (val)
                            {
                              if(val.isEmpty)
                              {
                                return "Please enter Password";
                              }
                              return null;
                            }
                        ),

                        SizedBox(height: 15.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async{

                              if(formkey.currentState.validate())
                              {
                                setState(() {
                                  isLoading=true;
                                });
                                Map<String,String> params = {
                                  "userid":provider.emailuserid,
                                  "password":_password.text.toString()
                                };
                                await provider.resetpassword(context,params);
                                if(provider.isresetpassword=="true")
                                  {
                                    Functions.ShowSnackbar(context,_scaffoldKey, provider.resetpasswordmessage,"OK");
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => SignInScreen()), (Route route) => false);
                                  }
                                else
                                  {
                                    Functions.ShowSnackbar(context,_scaffoldKey, provider.resetpasswordmessage,"OK");
                                  }
                                setState(() {
                                  isLoading=false;
                                });
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

                      ],
                    ),
                  ),
                ),
              ),
              isLoading ?loading_screen() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
