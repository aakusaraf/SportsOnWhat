import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportson/provider/AuthProvider.dart';
import 'package:sportson/resources/StyleResources.dart';
import 'package:sportson/ui/HomeScreen.dart';
import 'package:sportson/ui/MyProfileScreen.dart';
import 'package:sportson/ui/OTPScreen.dart';
import 'package:sportson/ui/PackageScreen.dart';
import 'package:sportson/ui/PrivacyPolicy.dart';
import 'package:sportson/ui/SignInScreen.dart';
import 'package:sportson/ui/SignupIntroScreen.dart';
import 'package:sportson/ui/SplashScreen.dart';
import 'package:sportson/ui/TermsAndconditions.dart';
import 'package:sportson/ui/TestPage.dart';
import 'package:sportson/ui/WelcomeScreen.dart';

import 'provider/DarkThemeProvider.dart';
import 'ui/SignUpScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>DarkThemeProvider()),
        ChangeNotifierProvider(create: (context)=>AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: SplashScreen(),
      ),
    );
  }
}