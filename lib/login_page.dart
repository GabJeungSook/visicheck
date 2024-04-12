import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_dashboard.dart'; // Import the admin dashboard
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Use a single form key
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Icon myIcon =
      Icon(Icons.check_circle, color: Colors.green); // Replace with your icon
  Future<void> _signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      // Validate form before sign in
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Login successful!
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green, // Green for success
          ),
        );

        // Navigate to home or other authenticated screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'Login failed';
        // Handle specific login errors and provide more informative messages
        switch (e.code) {
          case 'invalid-email':
            message = 'Please enter a valid email address.';
            break;
          case 'invalid-credential':
            message = 'The email address or password is incorrect.';
            break;
          default:
            // Handle other errors (optional)
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red, // Red for error
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(42),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ]),
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 500,
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(fontSize: 40, color: Colors.green),
                      ),
                      children: [
                        WidgetSpan(
                            child: myIcon,
                            alignment: PlaceholderAlignment.middle),
                        const TextSpan(text: ' VisiCheck'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      floatingLabelStyle: TextStyle(color: Colors.green),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                       floatingLabelStyle: TextStyle(color: Colors.green),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                      
                  ),
                  const SizedBox(height: 28), // Add some space (optional
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signIn(
                            _emailController.text, _passwordController.text);
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
