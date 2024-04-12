import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter Web App',
      home: 
      FirebaseAuth.instance.currentUser != null ? const AdminDashboard() : const LoginPage(), 
    );
  }
}
