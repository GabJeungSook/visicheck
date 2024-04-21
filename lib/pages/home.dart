import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visitor_management/components/order_table.dart';
import 'package:visitor_management/components/status_list.dart';
import 'package:visitor_management/constaints.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String searchTerm = "";

  Stream<List<Map<String, dynamic>>> getVisitors() {
    final usersCollection = FirebaseFirestore.instance.collection('visitors');
    return usersCollection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
        final userDocs = snapshot.docs;
        final users = userDocs.map((doc) => doc.data()).toList();
        return users.where((user) => user["name"].toLowerCase().contains(searchTerm.toLowerCase()) || user["purpose"].toLowerCase().contains(searchTerm.toLowerCase()) || user["department_type"].toLowerCase().contains(searchTerm.toLowerCase()) || user["department"].toLowerCase().contains(searchTerm.toLowerCase())).toList();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: componentPadding, right: componentPadding, top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatusList(),
          SizedBox(
            height: 50,
          ),
          TextField(
            onChanged: (value) => setState(() => searchTerm = value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              labelText: "Search Visitors",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(componentPadding),
              ),
            ),
          ),
          SizedBox(
            height: componentPadding,
          ),
          Container(
            width: double.infinity,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getVisitors(), // Use the updated getUsers method
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  if (users.isEmpty) {
                    // Show image for empty user list
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 50.0),
                          const Text('No visitors yet!',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Image.asset(
                            'imgs/empty_users.png', // Replace with your image path
                            width: 250.0,
                            height: 250.0,
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Show DataTable for users
                    return DataTable(
                      columnSpacing: 16.0,
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Purpose')),
                        DataColumn(label: Text('Visitor Type')),
                        DataColumn(label: Text('Destination')),
                        DataColumn(label: Text('Date')),
                      ],
                      rows: users
                          .map((userData) => DataRow(
                            cells: [
                              DataCell(Text(userData['name'] ?? '')),
                              DataCell(Text(userData['purpose'] ?? '')),
                              DataCell(Text(userData['department_type'] ?? '')),
                              DataCell(Text(userData['department'] ?? '')),
                              DataCell(Text(DateFormat('MMMM dd, yyyy hh:mm a').format(DateTime.parse(userData['timestamp'])) ?? '')),
                            ],
                          ))
                          .toList(),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Show loading indicator while data is being fetched
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          // OrderTable(),
        ],
      ),
    );
  }
}