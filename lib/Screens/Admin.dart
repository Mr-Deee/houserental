import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houserental/Screens/VieAllHouses.dart';
import 'package:houserental/Screens/ViewRentedHousesPage.dart';
import 'package:houserental/Screens/addHouse.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      appBar: AppBar(
        actions: [   IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Sign Out'),
                  backgroundColor: Colors.white,
                  content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text('Are you certain you want to Sign Out?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        print('yes');
                        FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/SignIn", (route) => false);
                        // Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
        ),],
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        title: Text(
          'Admin',
          style: TextStyle(
            fontFamily: 'Bowlby',
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.aspectRatio * 70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          children: [
            buildCard(
              context,
              icon: Icons.add_home_rounded,
              title: 'Add Home',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddHousePage()),
                );
              },
            ),
            buildCard(
              context,
              icon: Icons.house_siding_rounded,
              title: 'View Rented Houses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRentedHouses()),
                );
              },
            ),
            buildCard(
              context,
              icon: Icons.view_list_rounded,
              title: 'View All Houses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Viewallhouses()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
