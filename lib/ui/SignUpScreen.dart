import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sportson/provider/AuthProvider.dart';
import 'package:sportson/ui/HomeScreen.dart';
import 'package:sportson/ui/OTPScreen.dart';
import 'package:sportson/ui/PrivacyPolicy.dart';
import 'package:sportson/ui/SignInScreen.dart';
import 'package:sportson/ui/TermsAndconditions.dart';

import '../resources/StyleResources.dart';
import '../utlity/Functions.dart';
import '../widgets/MainTitle.dart';
import '../widgets/MyTextbox.dart';
import '../widgets/loading_screen.dart';

class SignUpScreen extends StatefulWidget {

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool isLoading=false;
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isterms=false;
  var formkey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AuthProvider provider;

  String _currentAddress="";
  Position _currentPosition;

  //locations
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.subAdministrativeArea},${place.administrativeArea}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition);
    }).catchError((e) {
      debugPrint(e);
    });
  }
  //locations

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<AuthProvider>(context,listen: false);
    // _name.text="Keyur";
    // _phone.text="8866555469";
    // _email.text="keyur457812@gmail.com";
    // _password.text="123";
    _getCurrentPosition();
  }
  BuildContext ctx;
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
                            text: "Sign Up to ",
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
                            hint: "Name",
                            controller: _name,
                            ispassword: false,
                            keyboard: TextInputType.name,
                            validator: (val)
                            {
                              if(val.isEmpty)
                              {
                                return "Please enter Name";
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 15.0),
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
                            hint: "Email",
                            controller: _email,
                            ispassword: false,
                            keyboard: TextInputType.emailAddress,
                            validator: (val)
                            {
                              if(val.isEmpty)
                              {
                                return "Please enter Email";
                              }
                              else if(!Functions.isEmail(val))
                              {
                                return "Please enter valid Email";
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
                        SizedBox(height: 17.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: isterms,

                                activeColor: StyleResources.GreenColor,
                                side: MaterialStateBorderSide.resolveWith(
                                      (states) => BorderSide(width: 1.0, color: StyleResources.WhiteColor),
                                ),
                                onChanged: (val){
                                  setState(() {
                                    isterms = val;
                                  });
                                }
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child:  RichText(
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.end,
                                  textDirection: TextDirection.rtl,
                                  softWrap: true,
                                  maxLines: 2,
                                  textScaleFactor: 1,
                                  text: TextSpan(
                                    text: "By creating an account, I agree to the ",
                                    style: TextStyle(
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 14.0,
                                        color: StyleResources.WhiteColor
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Terms of Service",
                                          recognizer: new TapGestureRecognizer()..onTap = (){
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context)=> TermsAndconditions())
                                            );
                                          },
                                          style: TextStyle(
                                              fontFamily: 'PoppinsRegular',
                                              fontSize: 14.0,
                                              color: StyleResources.WhiteColor
                                          )),
                                      TextSpan(
                                          text: " and ",
                                          style: TextStyle(
                                              fontFamily: 'PoppinsRegular',
                                              fontSize: 14.0,
                                              color: StyleResources.WhiteColor
                                          )),
                                      TextSpan(
                                          text: "Privacy Policy",
                                          recognizer: new TapGestureRecognizer()..onTap = (){
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context)=> PrivacyPolicy())
                                            );
                                          },
                                          style: TextStyle(
                                              fontFamily: 'PoppinsRegular',
                                              fontSize: 14.0,
                                              color: StyleResources.WhiteColor
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 59.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async{
                              String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
                              if(formkey.currentState.validate())
                              {
                                if(isterms)
                                {
                                  setState(() {
                                    isLoading=true;
                                  });
                                  Map<String,String> params = {
                                    "name":_name.text.toString(),
                                    "email":_email.text.toString(),
                                    "number":_phone.text.toString(),
                                    "password":_password.text.toString(),
                                    "token":"",
                                    "location":_currentAddress,
                                    "timezone":currentTimeZone
                                  };
                                  await provider.register(context, params);
                                  if(provider.isRegister)
                                  {
                                    // Functions.ShowSnackbar(context,_scaffoldKey, provider.registerMessage,"Dismiss");
                                    Functions.ShowSnackbar(context,_scaffoldKey, provider.registerotp,"Dismiss");
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=> OTPScreen())
                                    );
                                  }
                                  else
                                  {
                                    Functions.ShowSnackbar(context,_scaffoldKey, provider.registerMessage,"OK");
                                  }
                                  setState(() {
                                    isLoading=false;
                                  });
                                }
                                else
                                {
                                  Functions.ShowSnackbar(context,_scaffoldKey, "Please accept "
                                      "terms of service and privacy policy","OK");
                                }
                              }
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
                        SizedBox(height: 14.0),
                        RichText(
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          softWrap: true,
                          maxLines: 1,
                          textScaleFactor: 1,
                          text: TextSpan(
                            text: "Already Have an Account? ",
                            style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: 14.0,
                                color: StyleResources.WhiteColor
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sign In',
                                  recognizer: new TapGestureRecognizer()..onTap = (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=> SignInScreen())
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
