import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visitor_management/components/add_user_form.dart';
import 'package:visitor_management/constaints.dart';

class Department extends StatefulWidget {
  Department({Key? key}) : super(key: key);
  static const int numItems = 10;

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  List<bool> selected =
      List<bool>.generate(Department.numItems, (int index) => false);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<List<Map<String, dynamic>>> getUsers() {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  return usersCollection.snapshots().map((snapshot) {
    final userDocs = snapshot.docs;
    final users = userDocs.map((doc) => doc.data()).toList();
    return users;
  });
}

  @override
  Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryAncient),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add User'),
                onPressed: () {
                 showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return AddUserForm(); // Replace with your form widget
                  },
                );
                },
              ),
            ],
          ),
        Container(
          width: double.infinity,
           child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: getUsers(), // Use the updated getUsers method
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Extract the list of users from the snapshot
                final users = snapshot.data!;

                return DataTable(
                 columnSpacing: 16.0,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Department')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: users.map((userData) => DataRow(
                    cells: [
                      DataCell(Text(userData['name'] ?? '')),
                      DataCell(Text(userData['email'] ?? '')),
                      DataCell(Text(userData['department'] ?? '')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit action with user data
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Handle delete action with user data
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              // Display a loading indicator while data is being fetched
              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    ),
  );
}
}
