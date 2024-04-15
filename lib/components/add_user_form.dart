import 'package:flutter/material.dart';

class AddUserForm extends StatefulWidget {
  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _departmentController = TextEditingController();

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
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) => value!.isEmpty ? 'Please enter a password' : null,
              obscureText: true, // Hide password text
            ),
            TextFormField(
              controller: _departmentController,
              decoration: const InputDecoration(labelText: 'Department'),
              validator: (value) => value!.isEmpty ? 'Please enter a department' : null,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text('Add User'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission here (add user to Firestore)
                      // Use the data from the controllers
                      final name = _nameController.text;
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final department = _departmentController.text;

                      // Implement your logic to add the user to Firestore...

                      Navigator.pop(context); // Close the modal
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