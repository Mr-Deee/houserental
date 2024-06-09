import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
        initialRoute:
        FirebaseAuth.instance.currentUser == null ? '/onboard' : '/Homepage',
        routes: {
          // "/splash": (context) => SplashScreen(),
          "/onboard": (context) => OnBoardingPage(),
          "/signin": (context) => signin(),
          "/signup": (context) => signup(),
          "/Homepage": (context) => homepage(),
        });
  }
}


