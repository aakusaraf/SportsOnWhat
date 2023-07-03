import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportson/ui/ForgotPasswordOTP.dart';
import 'package:sportson/ui/PackageScreen.dart';
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

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  var formkey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AuthProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _phone.text="8866555469";
    // _password.text="123";
    provider = Provider.of<AuthProvider>(context,listen: false);
  }
  BuildContext ctx;
  bool isLoading=false;
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
                        SizedBox(height: 70.0),
                        MainTitle(
                          text: "SPORTS ON WHAT",
                        ),
                        SizedBox(height: 64.0),
                        RichText(
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          softWrap: true,
                          maxLines: 1,
                          textScaleFactor: 1,
                          text: TextSpan(
                            text: "Sign In to ",
                            style: TextStyle(
                                fontFamily: 'PoppinsSemiBold',
                                fontSize: 20.0,
                                color: StyleResources.WhiteColor
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sports on What',
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
                        MyTextBox(
                            hint: "Phone Number",
                            controller: _phone,
                            ispassword: false,
                            keyboard: TextInputType.phone,
                            validator: (val)
                            {
                              if(val.isEmpty)
                              {
                                return "Please enter Phone Number";
                              }
                              else if(val.length!=10)
                              {
                                return "Please enter valid Phone Number";
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 15.0),
                        MyTextBox(
                            hint: "Password",
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
                        SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=> ForgotPassword())
                              );
                            },
                            child: Text("Forgot Password?",
                                style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: 14.0,
                                    color: StyleResources.WhiteColor
                                )),
                          ),
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
                                  "number":_phone.text.toString(),
                                  "password":_password.text.toString(),
                                };
                                await provider.login(context, params);
                                if(provider.isLogin=="true")
                                {
                                  print("true");
                                  Functions.ShowSnackbar(context,_scaffoldKey, provider.loginMessage,"DISMISS");
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (context) => HomeScreen()), (Route route) => false);
                                }
                                else if(provider.isLogin=="notverify")
                                  {
                                    print("notverify");
                                    Functions.ShowSnackbar(context,_scaffoldKey, provider.loginMessage,"OK");
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=> OTPScreen())
                                    );
                                  }
                                else
                                {
                                  print("test");
                                  Functions.ShowSnackbar(context,_scaffoldKey, provider.loginMessage,"OK");
                                }
                                setState(() {
                                  isLoading=false;
                                });
                              }
                            },
                            child: Text("Sign In"),
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
                            text: "Not Account Yet? ",
                            style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: 14.0,
                                color: StyleResources.WhiteColor
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sign Up',
                                  recognizer: new TapGestureRecognizer()..onTap = (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=> SignUpScreen())
                                    );
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
              ),
              isLoading ?loading_screen() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
