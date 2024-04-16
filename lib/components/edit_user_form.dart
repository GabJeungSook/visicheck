import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUserForm extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditUserForm({required this.userData});

  @override
  _EditUserFormState createState() => _EditUserFormState();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedDepartment;
  // ... other controllers for department, password (if editable)

  @override
  void initState() {
    super.initState();
    // Pre-populate controllers with user data
    _nameController.text = widget.userData['name'];
    _emailController.text = widget.userData['email'];
    _selectedDepartment = widget.userData['department'];
    // ... pre-populate other controllers
  }

  // ... form building logic similar to your add user form

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
            // TextFormField(
            //   controller: _passwordController,
            //   decoration: const InputDecoration(labelText: 'Password'),
            //   validator: (value) =>
            //       value!.isEmpty ? 'Please enter a password' : null,
            //   obscureText: true, // Hide password text
            // ),
            DropdownButtonFormField<String>(
              value: _selectedDepartment,
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
                  child: const Text('Edit User'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final name = _nameController.text;
                      final email = _emailController.text;
                      final department = _selectedDepartment;
                      final userId = widget.userData['id'];
                      // Confirmation dialog
                      final confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Edit User'),
                            content: Text(
                              'Are you sure you want to edit this user with the following details:\n\n'
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
                        widget._collectionRef
                            .where('id', isEqualTo: userId)
                            .get()
                            .then((snapshot) {
                          snapshot.docs.forEach((doc) {
                            doc.reference.update({
                              'name': name,
                              'email': email,
                              'department': department
                            });
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User updated successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }).catchError((error) {
                          print("Failed to update user: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error updating user!'),
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
