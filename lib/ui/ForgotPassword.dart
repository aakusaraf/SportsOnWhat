import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportson/ui/ForgotPasswordOTP.dart';

import '../provider/AuthProvider.dart';
import '../resources/StyleResources.dart';
import '../utlity/Functions.dart';
import '../widgets/MainTitle.dart';
import '../widgets/MyTextbox.dart';
import '../widgets/loading_screen.dart';

class ForgotPassword extends StatefulWidget {

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool isLoading=false;
  var formkey = new GlobalKey<FormState>();
  BuildContext ctx;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AuthProvider provider;

  TextEditingController _email = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _email.text="keyur457812@gmail.com";
    provider = Provider.of<AuthProvider>(context,listen: false);
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
                            Text("Forgot Password",style: TextStyle(
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
                            text: "Enter Your Email Address",
                            style: TextStyle(
                                fontFamily: 'PoppinsSemiBold',
                                fontSize: 18.0,
                                color: StyleResources.WhiteColor
                            ),
                          ),
                        ),
                        SizedBox(height: 32.0),
                        MyTextBox(
                            hint: "Email",
                            controller: _email,
                            ispassword: false,
                            keyboard: TextInputType.emailAddress,
                            validator: (val)
                            {
                              if(val.isEmpty)
                              {
                                return "Please enter email Address";
                              }
                              else if(!Functions.isEmail(val))
                              {
                                return "Please enter valid Email";
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
                                  "email":_email.text.toString(),
                                };
                                await provider.checkemail(context, params);
                                if(provider.isemailfound=="true")
                                  {
                                    Functions.ShowSnackbar(context,_scaffoldKey, provider.emailotp,"OK");
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ForgotPasswordOTP())
                                    );
                                  }
                                else
                                  {
                                    print(provider.emailmessage);
                                    Functions.ShowSnackbar(context,_scaffoldKey, provider.emailmessage,"OK");
                                  }
                                setState(() {
                                  isLoading=false;
                                });
                              }
                            },
                            child: Text("Send OTP"),
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
