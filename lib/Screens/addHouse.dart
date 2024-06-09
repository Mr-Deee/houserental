import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'Admin.dart';

class AddHousePage extends StatefulWidget {
  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final houseNameController = TextEditingController();
  final houseTypeController = TextEditingController();
  final houseColorController = TextEditingController();
  final houseNumberController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final classificationController = TextEditingController();
  final priceController = TextEditingController();
  final roomsController = TextEditingController();
  final locationController = TextEditingController();

  List<File?> _images = [];
  List<String> _imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        title: Text(
          'Add House ',
          style: TextStyle(
            fontFamily: 'Bowlby',
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.aspectRatio * 70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          scrollDirection: Axis.vertical,
          children: [
            Column(
              children: <Widget>[
                // Your existing text fields...
                // Add image picker button
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _imageSelectorContainer(0),
                      _imageSelectorContainer(1),
                      _imageSelectorContainer(2),
                    ],
                  ),
                ),
                buildTextField(
                    controller: houseNameController,
                    labelText: 'House Name',
                    icon: Icons.house_rounded),
                buildTextField(
                    controller: houseTypeController,
                    labelText: 'House Type',
                    icon: Icons.apartment_rounded),
                buildTextField(
                    controller: houseColorController,
                    labelText: 'House Color',
                    icon: Icons.color_lens_rounded),
                buildTextField(
                    controller: houseNumberController,
                    labelText: 'House Number',
                    icon: Icons.format_list_numbered_rounded),
                buildTextField(
                    controller: mobileNumberController,
                    labelText: 'Mobile Number',
                    icon: Icons.phone_android_rounded),
                buildTextField(
                    controller: classificationController,
                    labelText: 'Classification',
                    icon: Icons.class_rounded),
                buildTextField(
                    controller: priceController,
                    labelText: 'Price/Month',
                    icon: Icons.attach_money_rounded),
                buildTextField(
                    controller: roomsController,
                    labelText: 'No. of Rooms',
                    icon: Icons.room_rounded),
                buildTextField(
                    controller: locationController,
                    labelText: 'Location',
                    icon: Icons.location_on_rounded),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: ElevatedButton(
                    onPressed: () {
                      addHouse();
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'DelaGothic',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      enableFeedback: false,
                      elevation: 20,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
        required String labelText,
        required IconData icon}) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Icon(icon),
          floatingLabelStyle: TextStyle(
              color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(17),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: (BorderSide(width: 1.0, color: Colors.black)),
            borderRadius: BorderRadius.all(
              Radius.circular(17),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: (BorderSide(width: 1.0, color: Colors.blue)),
            borderRadius: BorderRadius.all(
              Radius.circular(17),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageSelectorContainer(int index) {
    return GestureDetector(
      onTap: () {
        _pickImage(index);
      },
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _images.length > index && _images[index] != null
              ? Image.file(_images[index]!)
              : Icon(Icons.add),
        ),
      ),
    );
  }

  void _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (_images.length < 4) {
          _images.add(File(pickedFile.path));
        } else {
          // Show error message or limit reached message
          // You can use a SnackBar for this purpose
        }
      });
    }
  }

  void addHouse() async {
    for (var imageFile in _images) {
      if (imageFile != null) {
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child(
            'house_images/${houseNameController.text}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(imageFile);
        final downloadURL = await storageRef.getDownloadURL();
        _imageUrls.add(downloadURL);
      }
    }
    addHouseToDb();
  }

  void addHouseToDb() {
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
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 6.0,
                            ),
                            CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                            SizedBox(
                              width: 26.0,
                            ),
                            Text("Adding house, please wait...")
                          ],
                        ),
                      ))));
        });
    _database.child('houses').push().set({
      'HouseImages': _imageUrls,
      'house_name': houseNameController.text,
      'house_type': houseTypeController.text,
      'house_color': houseColorController.text,
      'house_number': houseNumberController.text,
      'mobile_number': mobileNumberController.text,
      'classification': classificationController.text,
      'rooms': int.tryParse(roomsController.text) ?? 0,
      'price': double.tryParse(priceController.text) ?? 0.0,
      'location': locationController.text,
    }).then((_) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Admin()),
              (Route<dynamic> route) => false);
      displayToast("Added Successfully ", context);
    }).catchError((error) {
      // Handle errors
      print("Failed to add house: $error");
    });
  }

  void displayToast(String message, BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
