import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportson/models/UserData.dart';
import 'package:sportson/resources/UrlResources.dart';
import 'package:sportson/ui/MyProfileScreen.dart';
import 'package:http/http.dart' as http;
import '../provider/AuthProvider.dart';
import '../provider/DarkThemeProvider.dart';
import '../resources/StyleResources.dart';
import 'SignInScreen.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthProvider provider;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var currentItem=0;
bool isLoading = false;
  bool islogin=false;
  var isTakeSubscription = false;
  checklogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.containsKey("islogin"))
      {
        setState(() {
          islogin=true;
        });
      }
    if(prefs.containsKey("islogin")){
      var data = prefs.getString("userdata");
      provider.loggedinuser = UserData.fromJson(jsonDecode(data));
      Map<String,dynamic> params = {
        "userid":provider.loggedinuser.userId.toString(),
      };
      print("params = ${params}");
      await provider.getUserPackage(context,params);
      setState(() {
        isTakeSubscription = prefs.getBool('isSubscription') ?? false;
      });
    }
  }
  Future<List<dynamic>> alldata;
  List<dynamic> _gametypeData = [];
  Future<List<dynamic>> getgametypedata()async{
    Uri uri = Uri.parse(UrlResources.ALL_GAME_TYPE);
    var response = await http.get(uri);
    print("response = ${response.statusCode}");
    if (response.statusCode == 200) {
      var body = response.body;

      var json = jsonDecode(body);
      print("body =${json["gametype"].runtimeType}");
      setState(() {
        _gametypeData = json["gametype"];
      });
      return json["gametype"];

      // print("jsondata = ${_gametypeData}");
    } else {
      print("api error");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   print("aaa = ${getgametypedata().runtimeType}");
    checklogin();
   setState(() {

     alldata = getgametypedata();
   });
    provider = Provider.of<AuthProvider>(context, listen: false);
    provider.viewGame(context);
    // await provider.viewGame(context);
    // checklogin();
  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context, listen: true);
    final themeChange = Provider.of<DarkThemeProvider>(context,listen: true);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color:  (themeChange.isdark)?StyleResources.AppBackgroubdDark:StyleResources.AppBackgorundLight,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Text("data"),
            Container(
              decoration: BoxDecoration(
              color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25.0),bottomRight: Radius.circular(25.0))
              ),
              child: Column(
                children: [
                  Container(

                    padding: EdgeInsets.only(top: 20.0,right: 20.0,left: 20.0,bottom: 28.0),
                    decoration: BoxDecoration(
                        color:  (themeChange.isdark)?StyleResources.BlueColorDark:StyleResources.BlueColor,
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25.0),bottomRight: Radius.circular(25.0))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            (islogin)?GestureDetector(
                              onTap: () async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.clear();
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                    builder: (context) => SignInScreen()), (Route route) => false);

                              },
                              child: Container(
                                child: Text("Log Out",style: TextStyle(
                                    color: StyleResources.WhiteColor,
                                    fontSize: 10.0,
                                    fontFamily: 'PoppinsMedium'
                                )),
                                padding: EdgeInsets.only(left: 17.0,right: 17.0,top: 3.0,bottom: 3.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: StyleResources.GreenColor,
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                              ),
                            ):GestureDetector(
                              onTap: () async{
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>SignInScreen())
                                );
                              },
                              child: Container(
                                child: Text("Log In",style: TextStyle(
                                    color: StyleResources.WhiteColor,
                                    fontSize: 10.0,
                                    fontFamily: 'PoppinsMedium'
                                )),
                                padding: EdgeInsets.only(left: 17.0,right: 17.0,top: 3.0,bottom: 3.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: StyleResources.GreenColor,
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0,),
                        GestureDetector(
                          onTap: (){
                            if(islogin)
                              {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context)=> MyProfileScreen())
                                );
                              }

                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  (islogin && provider.loggedinuser.photo != null)?Container(
                                    height: 50,
                                    width: 50,
                                    child: (provider.loggedinuser.photo.toString()=="")?
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        'img/templogo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ):
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                          UrlResources.PROFILE_IMAGE+provider.loggedinuser.photo.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ):ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.all(5.0),
                                      color: Colors.white,
                                      child: SvgPicture.asset(
                                        "img/sportsontext.svg",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text((islogin)?"Welcome,"+provider.loggedinuser.name.toString():"Welcome",textAlign: TextAlign.center,style: TextStyle(
                                            fontFamily: 'PoppinsMedium',
                                            fontSize: 16.0,
                                            color: StyleResources.WhiteColor
                                        ),),
                                        Text((DateFormat('EEEE,d MMM').format(DateTime.now())),textAlign: TextAlign.center,style: TextStyle(
                                            fontFamily: 'PoppinsLight',
                                            fontSize: 14.0,
                                            color: StyleResources.WhiteColor
                                        ),),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              Text(new DateFormat.jm().format(DateTime.now()),textAlign: TextAlign.center,style: TextStyle(
                                  fontFamily: 'PoppinsMedium',
                                  fontSize: 14.0,
                                  color: StyleResources.WhiteColor
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 150.0,
                      width: double.infinity,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                          borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25.0),bottomRight: Radius.circular(25.0))
                      ),
                    child: (_gametypeData==null)
                        ?SizedBox(height: 0)
                        :(_gametypeData.length<=0)?Text("No Game Found"):ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _gametypeData.length,
                      itemBuilder: (context,index)
                      {
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              currentItem = provider.allgametypes[index].typeId;
                            });
                            await provider.filterItem(context, provider.allgametypes[index].typeId);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  padding: EdgeInsets.all(12.5),  // Adjust the padding here
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: (currentItem != 0 && currentItem == provider.allgametypes[index].typeId)
                                          ? StyleResources.GreenColor
                                          : (themeChange.isdark)
                                          ? StyleResources.CircleDark
                                          : StyleResources.CircleLight,
                                      width: 1.0,
                                    ),
                                    color: (themeChange.isdark)
                                        ? StyleResources.EditIconBackgroundDark
                                        : StyleResources.WhiteColor,
                                  ),
                                  child: Image.network(
                                    UrlResources.GAME_TYPE_IMAGE +
                                        _gametypeData[index]["type_img"].toString(),
                                    fit: BoxFit.fill,  // Adjust the fit of the image to cover the container
                                  ),
                                ),
                                SizedBox(height: 8.0,),
                                Text(
                                  _gametypeData[index]["type_name"].toString(),
                                  style: TextStyle(
                                    fontFamily: 'PoppinsMedium',
                                    fontSize: 12.0,
                                    color: (currentItem != 0 && currentItem == _gametypeData[index]["type_id"])
                                        ? StyleResources.GreenColor
                                        : (themeChange.isdark)
                                        ? StyleResources.HeadingColorDark
                                        : StyleResources.HeadingColorLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      }
                    ),
                  ),
                ],
              ),
            ),
            // Text("data"),
            provider.isApplyFilter? Expanded(child: Container(
              padding: EdgeInsets.only(right: 20.0,left: 20.0),
              child:provider.filterList.length> 0? ListView.separated(
              itemCount: provider.filterList.length,
              itemBuilder: (context,index)
              {
                return Container(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.network(
                            UrlResources.GAME_TYPE_IMAGE+
                                provider.filterList[index].typeImg.toString(),
                            height: 30,
                            width: 30,
                          )
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10.0),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  imageUrl:UrlResources.TEAM_IMAGE+provider.filterList[index].firstteamlogo.toString(),
                                  height: 60,
                                  width: 60,
                                ),
                                Text(provider.filterList[index].startname.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'PoppinsMedium',
                                      fontSize: 12.0,
                                      color:(themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(width: 15.0,),
                          Container(
                            height: 60.0,
                            width: 1.0,
                            color: Color(0xffE5E5E5),
                          ),
                          SizedBox(width: 15.0,),
                          Column(
                            children: [
                              Text(provider.allgames[index].datetext.toString(),style: TextStyle(
                                fontSize: 10.0,
                                fontFamily: 'PoppinsRegular',
                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                              ),),
                              SizedBox(width: 2.0,),
                              Text(provider.allgames[index].timetext.toString(),style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'PoppinsMedium',
                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                              ),)
                            ],
                          ),
                          SizedBox(width: 15.0,),
                          Container(
                            height: 60.0,
                            width: 1.0,
                            color: Color(0xffE5E5E5),
                          ),
                          SizedBox(width: 15.0,),
                          Container(
                            margin: EdgeInsets.only(right: 10.0),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  imageUrl:UrlResources.TEAM_IMAGE+provider.filterList[index].secondteamlogo.toString(),
                                  height: 60,
                                  width: 60,
                                ),

                                Text(provider.filterList[index].endname.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'PoppinsMedium',
                                      fontSize: 12.0,
                                      color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        height: 1.0,
                        width: 500.0,
                        color: Color(0xffE5E5E5),
                      ),
                      SizedBox(height: 15.0,),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Commcast",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'PoppinsRegular',
                                          color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                        ),)
                                  )
                              ),
                              Expanded(child: Align(alignment: Alignment.center,child: Text("-",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'PoppinsRegular',
                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                ),))),
                              Expanded(child: Align(alignment: Alignment.centerLeft,child: Text(provider.filterList[index].comast.toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'PoppinsRegular',
                                  color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.GreenColor,
                                ),))),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Align(alignment: Alignment.centerLeft,child: Text("Dish",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'PoppinsRegular',
                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                ),))),
                              Expanded(child: Align(alignment: Alignment.center,child: Text("-",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'PoppinsRegular',
                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                ),))),
                              Expanded(child: Align(alignment: Alignment.centerLeft,child: Text(provider.filterList[index].dish.toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'PoppinsRegular',
                                  color:  (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.GreenColor,
                                ),))),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Align(alignment: Alignment.centerLeft,child: Text("Direct",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'PoppinsRegular',
                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                ),))),
                              Expanded(child: Align(alignment: Alignment.center,child: Text("-",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'PoppinsRegular',
                                  color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                ),))),
                              Expanded(child: Align(alignment: Alignment.centerLeft,child: Text(provider.filterList[index].direct.toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'PoppinsRegular',
                                  color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.GreenColor,
                                ),))),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                );
              },
              separatorBuilder: (context, position) {
                if(position==1 || position==2)
                {
                  return Image.asset('img/ad1.png');
                }
                else
                {
                  return SizedBox(height: 0,);
                }

              },
            ): Center(
                child: Text('No data found'),
              ),)
            )
                : Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 20.0,left: 20.0),
                child: FutureBuilder(
                  future:alldata,

                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("object");
                      if (snapshot.data.length <= 0) {
                        return Center(
                          child: Text("No Data"),
                        );
                      } else {
                        return ListView.separated(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context,index)
                            {
                              return Container(
                                padding: EdgeInsets.all(20.0),
                                margin: EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.network(
                                          UrlResources.GAME_TYPE_IMAGE+snapshot.data[index]["type_img"].toString(),
                                          height: 30,
                                          width: 30,
                                        )
                                      ],
                                    ),
                                    // Text("data"),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10.0),
                                          child: Column(
                                            children: [
                                              // CachedNetworkImage(
                                              //   placeholder: (context, url) => CircularProgressIndicator(),
                                              //   errorWidget: (context, url, error) => Icon(Icons.error),
                                              //   imageUrl:UrlResources.TEAM_IMAGE+provider.allgames[index].firstteamlogo.toString(),
                                              //   height: 60,
                                              //   width: 60,
                                              // ),
                                              Text(provider.allgames[index].startname.toString(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'PoppinsMedium',
                                                    fontSize: 12.0,
                                                    color:(themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                  ))
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 15.0,),
                                        Container(
                                          height: 60.0,
                                          width: 1.0,
                                          color: Color(0xffE5E5E5),
                                        ),
                                        SizedBox(width: 15.0,),
                                        Column(
                                          children: [
                                            Text(provider.allgames[index].datetext.toString(),style: TextStyle(
                                              fontSize: 10.0,
                                              fontFamily: 'PoppinsRegular',
                                              color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                            ),),
                                            SizedBox(width: 2.0,),
                                            Text(provider.allgames[index].timetext.toString(),style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'PoppinsMedium',
                                              color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                            ),)
                                          ],
                                        ),
                                        SizedBox(width: 15.0,),
                                        Container(
                                          height: 60.0,
                                          width: 1.0,
                                          color: Color(0xffE5E5E5),
                                        ),
                                        SizedBox(width: 15.0,),
                                        Container(
                                          margin: EdgeInsets.only(right: 10.0),
                                          child: Column(
                                            children: [
                                              CachedNetworkImage(
                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                imageUrl:UrlResources.TEAM_IMAGE+provider.allgames[index].secondteamlogo.toString(),
                                                height: 60,
                                                width: 60,
                                              ),

                                              Text(provider.allgames[index].endname.toString(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'PoppinsMedium',
                                                    fontSize: 12.0,
                                                    color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0,),
                                    Container(
                                      height: 1.0,
                                      width: 500.0,
                                      color: Color(0xffE5E5E5),
                                    ),
                                    SizedBox(height: 15.0,),
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("Commcast",
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily: 'PoppinsRegular',
                                                        color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                                      ),)
                                                )
                                            ),
                                            Expanded(child: Align(alignment: Alignment.center,child: Text("-",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                              ),))),
                                            Expanded(child: Align(alignment: Alignment.centerLeft,child: Text(provider.allgames[index].comast.toString().toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.GreenColor,
                                              ),))),
                                          ],
                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(child: Align(alignment: Alignment.centerLeft,child: Text("Dish",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                              ),))),
                                            Expanded(child: Align(alignment: Alignment.center,child: Text("-",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                              ),))),
                                            Expanded(child: Align(alignment: Alignment.centerLeft,child: Text(provider.allgames[index].dish.toString().toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color:  (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.GreenColor,
                                              ),))),
                                          ],
                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(child: Align(alignment: Alignment.centerLeft,child: Text("Direct",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                              ),))),
                                            Expanded(child: Align(alignment: Alignment.center,child: Text("-",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color: (themeChange.isdark)?StyleResources.HeadingColorDark:StyleResources.HeadingColorLight,
                                              ),))),
                                            Expanded(child: Align(alignment: Alignment.centerLeft,child: Text(provider.allgames[index].direct.toString().toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color: (themeChange.isdark)?StyleResources.WhiteColor:StyleResources.GreenColor,
                                              ),))),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: (themeChange.isdark)?StyleResources.BlackColor:StyleResources.WhiteColor,
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                              );
                            },
                            separatorBuilder: (context, position) {
                              if(position==1 || position==2)
                              {
                                if(isTakeSubscription)
                                  {
                                   return Container();
                                  }else{
                                  return Image.asset('img/ad1.png');
                                }

                              }
                              else
                              {
                                return SizedBox(height: 0,);
                              }

                            },
                          );
                      }
                    } else {

                      return Center(
                        child: Text("No Data"),
                      );
                    }
                  },
                ),
                // child: (provider.allgames==null)
                //     ?SizedBox(height: 0)
                //     :(provider.allgames.length<=0)?Center(child: Container(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text("No Games Found"),
                //       SizedBox(height: 17.0,),
                //       ElevatedButton(
                //         onPressed: () async{
                //           provider.allgames=provider.defaultgames;
                //           setState(() {
                //             currentItem=0;
                //           });
                //         },
                //         child: Text("Reload"),
                //         style:  ElevatedButton.styleFrom(
                //             padding: EdgeInsets.only(left: 18.0,right: 18.0,top: 8.0,bottom: 8.0),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(25.0),
                //             ),
                //             primary: StyleResources.GreenColor,
                //             textStyle: TextStyle(
                //                 fontSize: 12,
                //                 fontFamily: 'PoppinsMedium',
                //                 fontWeight: FontWeight.bold)
                //         ),
                //       )
                //     ],
                //   ),
                // ))
                //     :RefreshIndicator(
                //       onRefresh: ()async{
                //         await provider.viewOnlyGame(context);
                //       },
                //       child:
                //     ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
