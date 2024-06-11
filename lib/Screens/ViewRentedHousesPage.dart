import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewRentedHouses extends StatefulWidget {
  const ViewRentedHouses({super.key});

  @override
  State<ViewRentedHouses> createState() => _ViewRentedHousesState();
}

class _ViewRentedHousesState extends State<ViewRentedHouses> {
  List<Map<dynamic, dynamic>> rentedHouseList = [];
  Widget build(BuildContext context) {
    return Scaffold(
      body:  rentedHouseList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: rentedHouseList.length,
        itemBuilder: (context, index) {
          final rentedHouse = rentedHouseList[index];
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text(
                rentedHouse['house_name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${rentedHouse['location']}'),
                  Text('Total Price: \$${rentedHouse['total_price']}'),
                  Text('Rented for: ${rentedHouse['number_of_days']} days'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
