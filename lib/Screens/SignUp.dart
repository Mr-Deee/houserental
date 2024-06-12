import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../model/Users.dart';
import 'Login.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  User? firebaseUser;
  User? currentfirebaseUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> registerNewUser(BuildContext context) async {
    // String fullPhoneNumber = '$selectedCountryCode${phonecontroller.text.trim()
    //     .toString()}';

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: 6.0,),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black),),
                            SizedBox(width: 26.0,),
                            Text("Signing up,please wait...")

                          ],
                        ),
                      ))));
        });


    firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text)
        .catchError((errMsg) {
      Navigator.pop(context);
      displayToast("Error" + errMsg.toString(), context);
    }))
        .user;


    if (firebaseUser != null) // user created

        {
      //save use into to database

      Map userDataMap = {

        "Email": _emailController.text.trim().toString(),
        "Name": _nameController.text.trim().toString(),
        // "phoneNumber": fullPhoneNumber,
        "Password": _passwordController.text.trim().toString(),

      };
      Clientsdb.child(firebaseUser!.uid).set(userDataMap);
      // Admin.child(firebaseUser!.uid).set(userDataMap);

      currentfirebaseUser = firebaseUser;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginScreen(),
        ),
      );
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) {
      //     return login();
      //   }),
      // );      // Navigator.pop(context);
      // error occured - display error
      displayToast("user has not been created", context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "House Rental",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Name",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                        registerNewUser(context);
  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      // Navigate to sign-up screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Don't have an account? Login",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    );

  }
}
displayToast(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}