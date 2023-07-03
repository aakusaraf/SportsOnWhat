import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../provider/AuthProvider.dart';
import '../provider/DarkThemeProvider.dart';
import '../resources/StyleResources.dart';
import '../widgets/loading_screen.dart';
class PrivacyPolicy extends StatefulWidget {

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  AuthProvider provider;
  bool isLoading=false;
  var value="";

  getdata() async
  {
    setState(() {
      isLoading=true;
    });
    Map<String,String> params = {
      "settingid":"2"
    };
    await provider.getSettings(context, params);
    setState(() {
      value = provider.setting.settingValue.toString();
    });
    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AuthProvider>(context, listen: false);
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context,listen: true);
    return Scaffold(
      body: Stack(
        children: [
          Container(
              color: (themeChange.isdark)?StyleResources.AppBackgroubdDark:StyleResources.AppBackgorundLight,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20.0,right: 20.0,left: 20.0,bottom: 20.0),
                    decoration: BoxDecoration(
                        color: (themeChange.isdark)?StyleResources.BlueColorDark:StyleResources.BlueColor,
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25.0),bottomRight: Radius.circular(25.0))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.arrow_back,color:(themeChange.isdark)?StyleResources.WhiteColor:StyleResources.WhiteColor,),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Privacy Policy",textAlign: TextAlign.center,style: TextStyle(
                                          fontFamily: 'PoppinsMedium',
                                          fontSize: 16.0,
                                          color: StyleResources.WhiteColor
                                      ),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 18.0,),

                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0,right: 20.0,left: 20.0,bottom: 28.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (value!="")? Html(data:value)
                            // Text(value,style: TextStyle(
                            //   fontFamily: 'PoppinsRegular',
                            //   fontSize: 14.0,
                            //   color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                            // ),)
                                :SizedBox(height: 0,)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
          isLoading ?loading_screen() : Container()
        ],
      ),
    );
  }
}
