import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Viewallhouses extends StatefulWidget {
  const Viewallhouses({super.key});

  @override
  State<Viewallhouses> createState() => _ViewallhousesState();
}

class _ViewallhousesState extends State<Viewallhouses> {

  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('houses');
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
        title: Text("ViewHouses"),
      ),

      body: houseList.isEmpty
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

    ));
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

              ],
            ),
          ),
        );
      },
    );
  }
}
