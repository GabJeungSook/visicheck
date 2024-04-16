import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visitor_management/components/add_user_form.dart';
import 'package:visitor_management/components/edit_user_form.dart';
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
    return usersCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
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
                    rows: users
                        .map((userData) => DataRow(
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
                                          // Get the user data for the current row
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditUserForm(
                                                  userData: userData);
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                            final confirmed = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Confirm Edit User'),
                                                content: Text(
                                                  'Are you sure you want to edit this user with the following details:\n\n'
                                                  'Name: ${userData['name']}\n'
                                                  'Email: ${userData['email']}\n'
                                                  'Department: ${userData['department']}',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () =>
                                                        Navigator.pop(context, false),
                                                  ),
                                                  TextButton(
                                                    child: const Text('Confirm'),
                                                    onPressed: () =>
                                                        Navigator.pop(context, true),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                           if (confirmed ?? false) {
                                               firestore.collection('users')
                                                  .where('id', isEqualTo: userData['id'])
                                                  .get()
                                                  .then((snapshot) {
                                                snapshot.docs.forEach((doc) => doc.reference.delete());
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('User deleted successfully!'),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              }).catchError((error) {
                                                print("Failed to delete user: $error");
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Error deleting user!'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              });
                                            }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
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
