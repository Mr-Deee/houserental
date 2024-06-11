import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:houserental/Screens/Admin.dart';
import 'package:houserental/Screens/Login.dart';
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

DatabaseReference Clientsdb = FirebaseDatabase.instance.ref().child("Users");

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
        initialRoute:'/',
       // FirebaseAuth.instance.currentUser == null ? '/' : '/signup',
        routes: {
          "/": (context) => CheckUserRole(),
          // "/splash": (context) => SplashScreen(),
           "/HomeScreen": (context) => Homepage(),
           "/Admin": (context) => Admin(),
          "/SignIn": (context) => LoginScreen(),
          "/signup": (context) => SignUP(),
        });
  }
}
class CheckUserRole extends StatefulWidget {
  @override
  _CheckUserRoleState createState() => _CheckUserRoleState();
}

class _CheckUserRoleState extends State<CheckUserRole> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _checkUserRoleAndNavigate();
  }
  void _checkUserRoleAndNavigate() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent adminSnapshot = await _databaseReference.child('Admin').once();
      DatabaseEvent gasStationSnapshot = await _databaseReference.child('Users').once();

      if (adminSnapshot.snapshot.value != null &&
          (adminSnapshot.snapshot.value as Map<dynamic, dynamic>).containsKey(user.uid)) {
        // User is an admin
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/Admin');});
      } else if (gasStationSnapshot.snapshot.value != null &&
          (gasStationSnapshot.snapshot.value as Map<dynamic, dynamic>).containsKey(user.uid)) {
              Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/HomeScreen');});
      } else {
        // User is not assigned a role
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/signup');});
      }
    } else {
      // No user logged in
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/SignIn');});
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can show a loading indicator while checking user role
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

