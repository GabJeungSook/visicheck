import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visitor_management/login_page.dart';
import 'package:visitor_management/pages/dashboard.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitor',
      theme: ThemeData(
          fontFamily: 'Nunito',
          // primaryColor: primary,
          // textTheme: TextTheme().apply(bodyColor: textColor),
          backgroundColor: Colors.yellow),
      home: Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Admin Dashboard'),
  //       leading: ElevatedButton(
  //         onPressed: ()=> _signOut(context),
  //               child: const Text('Logout'),
  //             ),
  //     ),
  //     body: const Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text('Welcome, Admin!'),
  //           // Add sections for displaying data, controls, etc.
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // After successful sign out, navigate back to login or any desired page
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with desired page
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