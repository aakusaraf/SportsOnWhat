import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportson/resources/UrlResources.dart';
import 'package:sportson/ui/PackageScreen.dart';
import '../models/UserData.dart';
import '../provider/AuthProvider.dart';
import '../provider/DarkThemeProvider.dart';
import '../resources/StyleResources.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:path/path.dart' as Path;

import '../utlity/Functions.dart';
import '../widgets/MyTextbox.dart';
import '../widgets/loading_screen.dart';
class MyProfileScreen extends StatefulWidget {

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}
enum AppState {
  free,
  picked,
  cropped,
}
class _MyProfileScreenState extends State<MyProfileScreen> {
  AuthProvider provider;
  var themeChange;
  File finalimage;
  AppState state;
  ImagePicker _picker = ImagePicker();
  bool isLoading=false;
  var isTakeSubscription = false;
  @override
  void initState() {
    super.initState();
    themeChange = Provider.of<DarkThemeProvider>(context,listen: false);
    provider = Provider.of<AuthProvider>(context, listen: false);
    state = AppState.free;
    getSubscriptionData();
  }
  getSubscriptionData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isTakeSubscription = prefs.getBool('isSubscription') ?? false;
    });
  }
  Future<Null> _pickImage(type) async {
    XFile imageFile;
    if(type=="camera")
      {
         imageFile = await _picker.pickImage(source: ImageSource.camera);
      }
    else
      {
         imageFile = await _picker.pickImage(source: ImageSource.gallery);
      }

    if (imageFile != null) {
      setState(() {
        finalimage = File(imageFile.path);
        _cropImage();
      });
    }
  }

  Future<Null> _cropImage() async {
    CroppedFile croppedFile = await ImageCropper().cropImage(
      sourcePath: finalimage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: StyleResources.BlueColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        isLoading=true;
      });
      finalimage = File(croppedFile.path);
      var stream = new http.ByteStream(DelegatingStream.typed(finalimage.openRead()));
      var length = await finalimage.length();
      var uri = Uri.parse(UrlResources.UPLOAD_PROFILE);
      var request = new http.MultipartRequest("POST", uri);
      var multipartFileSign = new http.MultipartFile('profile_pic', stream, length,
          filename: Path.basename(finalimage.path));
      request.files.add(multipartFileSign);
      request.fields['userid'] = provider.loggedinuser.userId.toString();
      var response = await request.send();
      if(response.statusCode==200)
        {
          response.stream.transform(utf8.decoder).listen((value)  async{
            var json = jsonDecode(value);
            if(json["status"]=="true")
              {
                var filename = json["photo"].toString();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var userjson = jsonDecode(prefs.getString("userdata"));
                userjson["photo"]=filename;
                UserData obj = UserData.fromJson(userjson);
                prefs.setString("userdata", jsonEncode(obj));
                provider.loggedinuser = UserData.fromJson(jsonDecode(prefs.getString("userdata")));
                Functions.ShowSnackbar(context,_scaffoldKey, json["message"],"OK");
              }
            else
              {
                Functions.ShowSnackbar(context,_scaffoldKey, json["message"],"OK");
              }
          });
        }
      else
        {
          Functions.ShowSnackbar(context,_scaffoldKey, "Something goes wrong. please contact administrator","OK");
        }
      setState(() {
        isLoading=false;
      });
    }
  }

  void _clearImage() {
    finalimage = null;
    setState(() {
      state = AppState.free;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  openSelectMarketingFileDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel",style: TextStyle(
              color:(themeChange.isdark)?StyleResources.BlackColor:StyleResources.BlackColor,
            fontSize: 14.0,
            fontFamily: 'PoppinsRegular'
        )),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          CupertinoActionSheetAction(
            child: Text("Camera",style: TextStyle(
                color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.BlackColor,
                fontSize: 14.0,
                fontFamily: 'PoppinsRegular'
            )),
            onPressed: () {
              _pickImage("camera");
              Navigator.pop(context);

            },
          ),
          CupertinoActionSheetAction(
            child: Text("Choose Photo",style: TextStyle(
                color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.BlackColor,
                fontSize: 14.0,
                fontFamily: 'PoppinsRegular'
            )),
            onPressed: () {
              _pickImage("gallery");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  _showDialog(BuildContext context){
    var alert = AlertDialog(
      title: Column(
        children: <Widget>[
          Text("CupertinoAlertDialog"),
        ],
      ),
      content: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(),
            TextField(),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },),
        ElevatedButton(
          child: Text("CANCEL"),
          onPressed: () {
            Navigator.of(context).pop();
          },),

      ],
    );
    showDialog(context: context, builder: (BuildContext context){
      return alert;
    });

  }
  @override
  Widget build(BuildContext context) {

    themeChange = Provider.of<DarkThemeProvider>(context,listen: true);
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
              color: (themeChange.isdark)?StyleResources.AppBackgroubdDark:StyleResources.AppBackgorundLight,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        height: 240.0,
                        padding: EdgeInsets.only(top: 20.0,right: 20.0,left: 20.0,bottom: 28.0),
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
                                    SvgPicture.asset(
                                      "img/burger.svg",
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("My Profile",textAlign: TextAlign.center,style: TextStyle(
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
                      GestureDetector(
                        onTap: (){
                          openSelectMarketingFileDialog();
                        },
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(top:140.0,right: 20.0,left: 20.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            margin:EdgeInsets.all(20.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: (themeChange.isdark)?StyleResources.EditIconBackgroundDark:StyleResources.EditIconBackgroundLight,
                                  width: 1.0
                              ),
                              color: (themeChange.isdark)?StyleResources.EditIconBackgroundDark:StyleResources.EditIconBackgroundLight,),
                            child: SvgPicture.asset(
                              "img/ic-edit.svg",
                              height: 30.0,
                              width: 30.0,
                              color:  (themeChange.isdark)?StyleResources.EditIconDark:StyleResources.EditIconLight,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        child: Column(
                          children: [
                          Container(
                          height: 112,
                          width: 112,
                          // padding: EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: UrlResources.PROFILE_IMAGE + provider.loggedinuser.photo.toString(),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.person_outline,size: 60,),
                              ),
                            ),
                          ),
                        ),

                        // Container(
                            //   height: 112,
                            //   width: 112,
                            //   child:
                            //   provider.loggedinuser.photo.toString()=="" ||provider.loggedinuser.photo.toString() == null?
                            //       Text("A")
                            //         :
                            //   ClipRRect(
                            //     borderRadius: BorderRadius.circular(50),
                            //     child: Image.network(
                            //       UrlResources.PROFILE_IMAGE+provider.loggedinuser.photo.toString(),
                            //       fit: BoxFit.cover,
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 8.0,),
                            Text(provider.loggedinuser.name.toString(),style: TextStyle(
                                color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.BlackColor,
                                fontSize: 16.0,
                                fontFamily: 'PoppinsSemiBold'
                            )),
                            SizedBox(height: 8.0,),
                            Text(provider.loggedinuser.location ?? "-",style: TextStyle(
                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                fontSize: 14.0,
                                fontFamily: 'PoppinsRegular'
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0,right: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 18.0,),
                            Text("Personal Info",style: TextStyle(
                                color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.BlackColor,
                                fontSize: 16.0,
                                fontFamily: 'PoppinsSemiBold'
                            )),
                            SizedBox(height: 13.0,),
                            Container(
                              padding: EdgeInsets.all(25.0),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "img/message.svg",
                                              height: 15.0,
                                              width: 15.0,
                                              color:  (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                            ),
                                            SizedBox(width: 18.0,),
                                            Expanded(
                                              child: Text(provider.loggedinuser.email.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsRegular',
                                                  fontSize: 14.0,
                                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 18.0,),
                                        Container(
                                          width: double.infinity,
                                          height: 0.5,
                                          color:  (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "img/call.svg",
                                              height: 15.0,
                                              width: 15.0,
                                              color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                            ),
                                            SizedBox(width: 18.0,),
                                            Expanded(
                                              child: Text(provider.loggedinuser.phone.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'PoppinsRegular',
                                                    fontSize: 14.0,
                                                    color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 18.0,),
                                        Container(
                                          width: double.infinity,
                                          height: 0.5,
                                          color:  (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "img/map.svg",
                                              height: 15.0,
                                              width: 15.0,
                                              color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                            ),
                                            SizedBox(width: 18.0,),
                                            Expanded(
                                              child: Text(provider.loggedinuser.location ?? "-",
                                                  style: TextStyle(
                                                    fontFamily: 'PoppinsRegular',
                                                    fontSize: 14.0,
                                                    color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                            ),
                            SizedBox(height: 18.0,),
                            Text("Update Billing",style: TextStyle(
                                color:  (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.BlackColor,
                                fontSize: 16.0,
                                fontFamily: 'PoppinsSemiBold'
                            )),
                            SizedBox(height: 12.0,),
                            InkWell(
                              onTap: (){
                                isTakeSubscription?null:
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PackageScreen()));
                              },
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "img/subscription.jpg",
                                          height: 15.0,
                                          width: 15.0,
                                          // color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                        ),
                                        SizedBox(width: 18.0,),
                                        Expanded(
                                          child:isTakeSubscription?Text("Subscription already active",style: TextStyle(
                                            fontFamily: 'PoppinsRegular',
                                            fontSize: 14.0,
                                            color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                          ),): Text("Subscription",
                                            style: TextStyle(
                                              fontFamily: 'PoppinsRegular',
                                              fontSize: 14.0,
                                              color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                            ),),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                              ),
                            ),
                            SizedBox(height: 18.0,),
                            Text("Preferences",style: TextStyle(
                                color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.BlackColor,
                                fontSize: 16.0,
                                fontFamily: 'PoppinsSemiBold'
                            )),
                            SizedBox(height: 12.0,),
                            Container(
                              padding: EdgeInsets.all(19.0),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Dark mode",style: TextStyle(
                                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular'
                                            )),
                                            SizedBox(
                                                width: 40,
                                                height: 30,
                                                child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: Switch(
                                                      activeColor: StyleResources.GreenColor,
                                                      inactiveThumbColor: Color(0xff707070),
                                                      inactiveTrackColor: Color(0xffE2E2E2),
                                                      value: themeChange.isdark,
                                                      onChanged: (val)
                                                      {
                                                        themeChange.darkTheme = val;
                                                      },
                                                    )))
                                          ],
                                        ),
                                        SizedBox(height: 12.0,),
                                        Container(
                                          width: double.infinity,
                                          height: 0.5,
                                          color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                        ),
                                        SizedBox(height: 11.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Time Preferences",style: TextStyle(
                                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular'
                                            )),
                                            Row(
                                              children: [
                                                Text(provider.loggedinuser.timezone ?? "-",style: TextStyle(
                                                    color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                    fontSize: 10.0,
                                                    fontFamily: 'PoppinsRegular'
                                                )),
                                                SizedBox(width: 15.0,),
                                                SvgPicture.asset(
                                                  "img/ic-right-arrow.svg",
                                                  height: 15.0,
                                                  width: 15.0,
                                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.0,),
                                        Container(
                                          width: double.infinity,
                                          height: 0.5,
                                          color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                        ),
                                        SizedBox(height: 11.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Location",style: TextStyle(
                                                color:(themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular'
                                            )),
                                            Row(
                                              children: [
                                                Text(provider.loggedinuser.location ?? "-",style: TextStyle(
                                                    color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                    fontSize: 10.0,
                                                    fontFamily: 'PoppinsRegular'
                                                )),
                                                SizedBox(width: 15.0,),
                                                SvgPicture.asset(
                                                  "img/ic-right-arrow.svg",
                                                  height: 15.0,
                                                  width: 15.0,
                                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.0,),
                                        Container(
                                          width: double.infinity,
                                          height: 0.5,
                                          color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                        ),
                                        SizedBox(height: 11.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Skins",style: TextStyle(
                                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular'
                                            )),
                                            Row(
                                              children: [
                                                Text("(default)",style: TextStyle(
                                                    color:(themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                    fontSize: 10.0,
                                                    fontFamily: 'PoppinsRegular'
                                                )),
                                                Container(
                                                  height: 15.0,
                                                  width: 15.0,
                                                  margin: EdgeInsets.all(2.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff002244),
                                                      borderRadius: BorderRadius.circular(2.0)
                                                  ),
                                                ),
                                                Container(
                                                  height: 15.0,
                                                  width: 15.0,
                                                  margin: EdgeInsets.all(2.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff69BE28),
                                                      borderRadius: BorderRadius.circular(2.0)
                                                  ),
                                                ),
                                                Container(
                                                  height: 15.0,
                                                  width: 15.0,
                                                  margin: EdgeInsets.all(2.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffA5ACAF),
                                                      borderRadius: BorderRadius.circular(2.0)
                                                  ),
                                                ),
                                                SizedBox(width: 15.0,),
                                                SvgPicture.asset(
                                                  "img/ic-right-arrow.svg",
                                                  height: 15.0,
                                                  width: 15.0,
                                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                            ),
                            SizedBox(height: 18.0,),
                            Text("Login Details",style: TextStyle(
                                color:  (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.BlackColor,
                                fontSize: 16.0,
                                fontFamily: 'PoppinsSemiBold'
                            )),
                            SizedBox(height: 12.0,),
                            Container(
                              padding: EdgeInsets.all(25.0),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "img/ic-user.svg",
                                              height: 15.0,
                                              width: 15.0,
                                              color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                            ),
                                            SizedBox(width: 18.0,),
                                            Expanded(
                                              child: Text(provider.loggedinuser.email.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsRegular',
                                                  fontSize: 14.0,
                                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                ),),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 18.0,),
                                        Container(
                                          width: double.infinity,
                                          height: 0.5,
                                          color: Color(0xffBBBBBB),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),

                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "img/ic-lock.svg",
                                              height: 15.0,
                                              width: 15.0,
                                              color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                            ),
                                            SizedBox(width: 18.0,),
                                            Expanded(
                                              child: Text(provider.loggedinuser.password.replaceAll(RegExp(r"."), "*").toString(),
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsRegular',
                                                  fontSize: 14.0,
                                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                ),),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    width: double.infinity,
                                    height: 0.5,
                                    color: Color(0xffBBBBBB),
                                  ),
                                  SizedBox(height: 15.0,),

                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                            ),
                            SizedBox(height: 18.0,),
                            // Container(
                            //   padding: EdgeInsets.all(25.0),
                            //   margin: EdgeInsets.only(bottom: 28.0),
                            //   width: double.infinity,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         child: Column(
                            //           children: [
                            //             Text("Cancel Membership",style: TextStyle(
                            //                 color: Color(0xffFF0000),
                            //                 fontSize: 14.0,
                            //                 fontFamily: 'PoppinsRegular'
                            //             )),
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            //   decoration: BoxDecoration(
                            //       color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                            //       borderRadius: BorderRadius.circular(10.0)
                            //   ),
                            // ),
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
