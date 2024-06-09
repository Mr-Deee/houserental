import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:houserental/Screens/SignUp.dart';
import 'package:houserental/Screens/homepage.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'model/Users.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
await Future.delayed(Duration(seconds: 2)); // Ad
runApp((MultiProvider( providers: [

ChangeNotifierProvider<Users>(
create: (context) => Users(),
),

] ,child : MyApp())));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        debugShowCheckedModeBanner: false,
        initialRoute:
        FirebaseAuth.instance.currentUser == null ? '/signup' : '/Homepage',
        routes: {
          // "/splash": (context) => SplashScreen(),
          // "/onboard": (context) => OnBoardingPage(),
          // "/signin": (context) => signin(),
          "/signup": (context) => SignUP(),
          "/Homepage": (context) => Homepage(),
        });
  }
}


