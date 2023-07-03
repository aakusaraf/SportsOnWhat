import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportson/models/CustomSettings.dart';
import 'package:sportson/models/Game.dart';
import 'package:sportson/models/Packages.dart';
import 'package:sportson/models/UserData.dart';
import 'package:sportson/resources/UrlResources.dart';
import 'package:sportson/utlity/ApiHandler.dart';
import 'package:sportson/utlity/error_handler.dart';

import '../models/GameType.dart';
import '../utlity/Functions.dart';

class AuthProvider with ChangeNotifier
{
  bool isRegister=false;
  var registerMessage="";
  var registeruserid="";
  var registerotp="";
  var registermobile="";
  register(context,params) async
  {
    try
    {
      await ApiHandler.post(UrlResources.REGISTER,body: params).then((json){
        print(json.toString());
        if(json["status"]=="true")
          {
            isRegister=true;
            registerMessage=json["message"].toString();
            registeruserid=json["user_id"].toString();
            registerotp=json["otp"].toString();
            registermobile = params["number"].toString();
          }
        else
          {
            isRegister=false;
            registerMessage=json["message"].toString();
          }
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }


  bool isverify=false;
  var otpmessage="";
  verifyotp(context,params) async
  {
    try
    {
      await ApiHandler.post(UrlResources.OTP_VERIFY,body: params).then((json) async{
        print("params = ${params}");
        if(json["status"]=="true")
        {
          isverify=true;
          notifyListeners();
          otpmessage=json["message"].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("islogin", true);
          UserData obj = UserData.fromJson(json["userdata"]);
          prefs.setString("userdata", jsonEncode(obj));
          loggedinuser = UserData.fromJson(jsonDecode(prefs.getString("userdata")));
          //
        }
        else
        {
          isverify=false;
          notifyListeners();
          otpmessage=json["message"].toString();
        }
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }

  var isLogin="false";
  var loginMessage="";
  UserData loggedinuser;
  login(context,params) async
  {
    try
    {
      await ApiHandler.post(UrlResources.LOGIN,body: params).then((json) async{
        if(json["status"]=="true")
          {
            isLogin="true";
            loginMessage=json["message"].toString();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("islogin", true);
            UserData obj = UserData.fromJson(json["userdata"]);
            prefs.setString("userdata", jsonEncode(obj));
            loggedinuser = UserData.fromJson(jsonDecode(prefs.getString("userdata")));
          }
        else if(json["status"]=="notverify")
          {
            isLogin="notverify";
            loginMessage=json["message"].toString();

            registeruserid=json["user_id"].toString();
            registerotp=json["otp"].toString();
            registermobile = params["number"].toString();
          }
        else
          {
            isLogin="false";
            loginMessage=json["message"].toString();
          }
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }


  List<GameType> allgametypes;
  List<Game> allgames;
  List<Game> defaultgames;
  viewGame(context) async
  {
    try
    {
      await ApiHandler.get(UrlResources.ALL_GAME_TYPE).then((json) async{
        allgametypes = json["gametype"].map<GameType>((obj)=>GameType.fromJson(obj)).toList();
        defaultgames = allgames = json["games"].map<Game>((obj)=>Game.fromJson(obj)).toList();
        notifyListeners();
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }

  viewOnlyGame(context) async
  {
    try
    {
      await ApiHandler.get(UrlResources.ALL_GAME_TYPE).then((json) async{
        defaultgames = allgames = json["games"].map<Game>((obj)=>Game.fromJson(obj)).toList();
        notifyListeners();
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }
  List<Game> _filterList = [];

  List<Game> get filterList {
    return _filterList;
  }

  set filterList(List<Game> newList) {
    _filterList = newList;
    notifyListeners();
  }
  bool _isApplyFilter = false;

  bool get isApplyFilter {
    return _isApplyFilter;
  }

  set isApplyFilter(bool newList) {
    _isApplyFilter = newList;
    notifyListeners();
  }
  filterItem(context,itemid) async
  {
    print(itemid);
    isApplyFilter = true;
    filterList.clear();
    filterList = defaultgames.where((obj) => obj.typeId==itemid).toList();
    // allgames = defaultgames.where((obj) => obj.typeId==itemid).toList();
  }


  CustomSettings setting;
  getSettings(context,params) async
  {
    try
    {
      await ApiHandler.post(UrlResources.SETTINGS,body: params).then((json) async{
        setting = CustomSettings.fromJson(json);
        notifyListeners();
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }


  var isemailfound="false";
  var emailmessage="";
  var emailotp="";
  var emailuserid="";
  checkemail(context,params) async
  {
    try
    {
      await ApiHandler.post(UrlResources.FORGOTPASSWORD_SEND_OTP,body: params).then((json) async{
        if(json["status"]=="true")
        {
          isemailfound="true";
          emailmessage=json["message"].toString();
          emailotp=json["otp"].toString();
          emailuserid=json["userid"].toString();
        }
        else
        {
          isemailfound="false";
          emailmessage=json["message"].toString();
        }
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }

  var isresetpassword="false";
  var resetpasswordmessage="";
  resetpassword(context,params) async
  {
    try
    {
      await ApiHandler.post(UrlResources.RESET_PASSWORD,body: params).then((json) async{
        if(json["status"]=="true")
        {
          isresetpassword="true";
          resetpasswordmessage=json["message"].toString();
        }
        else
        {
          isresetpassword="false";
          resetpasswordmessage=json["message"].toString();
        }
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }

  List<Packages> allpackages;
  getPackageDetails(context) async
  {
    try
    {
      await ApiHandler.get(UrlResources.GET_PACKAGES).then((json) async{
        print("json data = ${json.toString()}");
        allpackages = json.map<Packages>((obj)=>Packages.fromJson(obj)).toList();
        notifyListeners();
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }

  addPackage(context,params) async
  {
    try
    {
      print("here params is");
      await ApiHandler.post(UrlResources.ADD_PACKAGES,body: params).then((json)async{
        print("all json = ${json}");
        print(json.toString());
        if(json["status"]=="true")
        {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isSubscription", true);
          Map<String,dynamic> params1 = {
            "userid":loggedinuser.userId.toString(),
          };
          print("params = ${params}");
          await getUserPackage(context,params1);
          Navigator.of(context).pop();

        }
        else
        {
          Navigator.of(context).pop();
        }
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }

  getUserPackage(context,params) async
  {
    try
    {

      await ApiHandler.post(UrlResources.GET_USER_PACKAGES,body: params).then((json)async{
        print("all json = ${json}");
        print(json.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if(json["status"]=="true")
        {
          prefs.setBool("isSubscription", true);
          // Navigator.of(context).pop();
        }
        else
        {
          prefs.setBool("isSubscription", false);
          // Navigator.of(context).pop();
        }
      });
    }
    on ErrorHandler catch (e)
    {
      Functions.PageRedirection(context, e.message);
    }
  }
}
