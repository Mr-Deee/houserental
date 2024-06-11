import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('houses');
  final DatabaseReference _rentaldb = FirebaseDatabase.instance.ref().child('rental');
  List<Map<dynamic, dynamic>> houseList = [];

  @override
  void initState() {
    super.initState();
    fetchHouses();
  }


  void fetchHouses() {
    _database.onValue.listen((event) {
      final List<Map<dynamic, dynamic>> houses = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        houses.add(value);
      });
      setState(() {
        houseList = houses;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
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
          )
        ],
        title: Text("HomePage"),
      ),
      body:  houseList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: houseList.length,
        itemBuilder: (context, index) {
          final house = houseList[index];
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text(
                house['house_name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type: ${house['house_type']}'),
                  Text('Price/Month: \$${house['price']}'),
                  Text('Location: ${house['location']}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                showHouseDetails(house);
              },
            ),
          );
        },
      ),
    );
  }

  void showHouseDetails(Map<dynamic, dynamic> house) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  house['house_name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Type: ${house['house_type']}'),
                Text('Color: ${house['house_color']}'),
                Text('Number: ${house['house_number']}'),
                Text('Price/Month: \$${house['price']}'),
                Text('Rooms: ${house['rooms']}'),
                Text('Location: ${house['location']}'),
                Text('Mobile: ${house['mobile_number']}'),
                Text('Classification: ${house['classification']}'),
                SizedBox(height: 10),
                if (house['HouseImages'] != null)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (house['HouseImages'] as List).length,
                      itemBuilder: (context, imgIndex) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            house['HouseImages'][imgIndex],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),


                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showRentDialog(house);
                    },
                    child: Text('Rent'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void showRentDialog(Map<dynamic, dynamic> house) {
    TextEditingController daysController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rent ${house['house_name']}'),
          content: TextField(
            controller: daysController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Number of days',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final int numberOfDays = int.parse(daysController.text);
                final double pricePerDay = house['price'] / 30; // Assuming the price is given per month
                final double totalPrice = numberOfDays * pricePerDay;

                writeRentalToDatabase(house, numberOfDays, totalPrice);
                Navigator.pop(context);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void writeRentalToDatabase(Map<dynamic, dynamic> house, int numberOfDays, double totalPrice) {
    _rentaldb.push().set({
      'house_name': house['house_name'],
      'house_number': house['house_number'],
      'mobile_number': house['mobile_number'],
      'location': house['location'],
      'number_of_days': numberOfDays,
      'total_price': totalPrice,
      'timestamp': DateTime.now().toString(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('House rented successfully!')),
      );
    }).catchError((error) {
      print("Failed to rent house: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to rent house.')),
      );
    });
  }
}

