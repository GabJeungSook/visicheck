import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:visitor_management/user_dashboard.dart';
import 'login_page.dart'; // Import the login page
import 'admin_dashboard.dart'; // Import the admin dashboard

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB5cMX-Ii7AeTZ8lE6EJ43gjp3QyQy5Epc",
          projectId: "visitor-management-4e46e",
          messagingSenderId: "825622302590",
          appId: "1:825622302590:web:1c7e14065de37495f9ad2f"));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

@override
  void initState() {
    super.initState();
  }


Future<Widget?> checkUser() async { // Explicitly define return type as Widget?
  if (FirebaseAuth.instance.currentUser != null) {
    if (FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
      return const AdminDashboard();
    } else {
      final userData = FirebaseFirestore.instance.collection('users');
      final email = FirebaseAuth.instance.currentUser!.email;
      final userSnapshot = await userData.where('email', isEqualTo: email).get();
      final userDataMap = userSnapshot.docs.first.data() as Map<String, dynamic>;
      return UserDashboard(user: userDataMap); // Pass data after fetching
    }
  } else {
    return const LoginPage();
  }
}

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    title: 'VisiCheck',
    home: FutureBuilder<Widget?>(
      future: checkUser(), // Retrieve user data
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final widget = snapshot.data;
        if (connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading indicator
        } else if (connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Handle error
          }
          return widget ?? const LoginPage(); // Display login page if no data
        } else {
          return const Text('Unexpected state'); // Handle other states (optional)
        }
      },
    ),
  );
}
}
