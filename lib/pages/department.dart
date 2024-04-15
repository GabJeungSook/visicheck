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

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');
  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add User button with icon
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
                  // _collectionRef
                  //     .add({
                  //       'name': 'test3', // John Doe
                  //       'email': 'test@test3.com',
                  //       'password': 'test3',
                  //       'department': 'IT' // 42
                  //     })
                  //     .then((value) => print("User Added"))
                  //     .catchError(
                  //         (error) => print("Failed to add user: $error"));
                  // Handle add user action
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Wrap DataTable with Container for full width
          Container(
            width: double.infinity,
            child: DataTable(
              columnSpacing: 16.0, // Adjust column spacing as needed
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Action')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('Department 1')),
                    DataCell(Text('Email')),
                    DataCell(Text('Department')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Handle edit action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete action
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(Text('Department 2')),
                    DataCell(Text('Email')),
                    DataCell(Text('Department')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Handle edit action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete action
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
