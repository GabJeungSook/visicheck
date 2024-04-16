import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUserForm extends StatefulWidget {
  @override
  _AddUserFormState createState() => _AddUserFormState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('users');

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _departmentController = TextEditingController();
  String? _selectedDepartment;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Set minimum size
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a name' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an email' : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a password' : null,
              obscureText: true, // Hide password text
            ),
            DropdownButtonFormField<String>(
              value: _selectedDepartment, // Current selected department
              hint: const Text('Select Department'), // Hint text
              validator: (value) =>
                  value == null ? 'Please select a department' : null,
              items: const [
                DropdownMenuItem(
                  value: 'IT Department',
                  child: Text('IT Department'),
                ),
                DropdownMenuItem(
                  value: 'HR Department',
                  child: Text('HR Department'),
                ),
                DropdownMenuItem(
                  value: 'Admin Department',
                  child: Text('Admin Department'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue!; // Update selected department
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text('Add User'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final name = _nameController.text;
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final department = _selectedDepartment;

                      // Confirmation dialog
                      final confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Add User'),
                            content: Text(
                              'Are you sure you want to add a new user with the following details:\n\n'
                              'Name: $name\n'
                              'Email: $email\n'
                              'Department: $department',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Confirm'),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed ?? false) {
                         // Create user with email and password
                        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                         // Get the newly created user
                        final user = userCredential.user!;
                        // Add user to Firestore
                        await _collectionRef.add({
                          'id' : user.uid,
                          'name': name,
                          'email': email,
                          'password': password,
                          'department': department,
                           'timestamp': FieldValue.serverTimestamp(),
                        }).then((value) {
                          // Show Snackbar on success
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User added successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context); // Close the modal
                        }).catchError((error) {
                          print("Failed to add user: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error adding user!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
