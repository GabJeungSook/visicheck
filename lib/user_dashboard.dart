// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:visitor_management/constaints.dart';
import 'package:visitor_management/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserDashboard extends StatefulWidget {
 final Map<String, dynamic>? user;
  const UserDashboard({
    Key? key,
    this.user,
  }) : super(key: key);
  
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('visitors');

class _UserDashboardState extends State<UserDashboard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _purposeController = TextEditingController();
  final _departmentController = TextEditingController();
  String? _selectedDepartment;

  @override
  void dispose() {
    _nameController.dispose();
    _purposeController.dispose();
    _departmentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      // Set desired material properties (optional)
      color: Colors.white, // Example background color

      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.only(left: 505, right: 505, bottom: 16),
              child: Column(children: [
                //image
                Image.asset('imgs/visicheck.png', width: 550, height: 120),
                SizedBox(height: 20),
                Text('Visitor Information on ${widget.user?['department']}', style: TextStyle(fontSize: 20)),
                const Text('Please fill up this form',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      final confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Log out?'),
                            content: const Text(
                              'Are you sure you want to logout?',
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

                      // UI won't be blocked while waiting for dialog confirmation
                      if (confirmed ?? false) {

                        try {
                           FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } on FirebaseAuthException catch (e) {
                          print(e.message);
                        }
                      }
                    },
                    // onPressed: () async {
                    //   final confirmed = await showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         title: const Text('Log out?'),
                    //         content: Text(
                    //           'Are you sure you want to logout?',
                    //         ),
                    //         actions: [
                    //           TextButton(
                    //             child: const Text('Cancel'),
                    //             onPressed: () =>
                    //                 Navigator.of(context).pop(false),
                    //           ),
                    //           TextButton(
                    //             child: const Text('Confirm'),
                    //             onPressed: () =>
                    //                 Navigator.of(context).pop(true),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   );
                    //   if (confirmed ?? false) {
                    //     try {
                    //       await FirebaseAuth.instance.signOut();
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const LoginPage()),
                    //       );
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('You have been signed out.'),
                    //         ),
                    //       );
                    //     } on FirebaseAuthException catch (e) {
                    //       print(e.message);
                    //     }
                    //   }
                    // },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAncient,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Logout')),
                const SizedBox(height: 120),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    floatingLabelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(
                    labelText: "Purpose",
                    floatingLabelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  hint: const Text('Select Department'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Visitor',
                      child: Text('Visitor'),
                    ),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your department.';
                    }
                    return null;
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDepartment =
                          newValue!; // Update selected department
                    });
                  },
                   decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Set background color to transparent
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Customize focused border
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                //submit button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                       final name = _nameController.text;
                       final purpose = _purposeController.text;
                       final department = _selectedDepartment;

                      final confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Add Visitor'),
                            content: Text(
                              'Are you sure all the information is correct? \n\nName: $name\nPurpose: $purpose\nDepartment: $department\n\n',
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
                        final departmentToAdd = department ?? widget.user?['department'];
                        await _collectionRef.add({
                          'name': name,
                          'purpose': purpose,
                          'department_type': widget.user?['department'],
                          'department': department,
                          'timestamp': DateTime.now().toIso8601String(),
                        }).then((value) {
                          _nameController.clear();
                          _purposeController.clear();
                          _departmentController.clear();
                        
                        }).catchError((error) {
                          print("Failed to add visitor: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error adding visitor!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }

                    }
                  },
                  child: const Text('Submit'),
                ),
              ]),
            )

            ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // After successful sign out, navigate back to login or any desired page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage()), // Replace with desired page
      );

      // Optional: Show confirmation message (e.g., using a SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been signed out.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle sign out errors (optional)
      print(e.message); // For debugging
    }
  }
}
