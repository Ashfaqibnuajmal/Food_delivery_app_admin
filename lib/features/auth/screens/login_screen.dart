import 'package:flutter/material.dart';
import 'package:mera_web/features/home/home.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameControlller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _login(BuildContext context) {
    const String validName = "ashfaq";
    const String validPassword = "21072005";
    if (_formKey.currentState!.validate()) {
      if (_nameControlller.text == validName &&
          _passwordController.text == validPassword) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username and password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/Logo.jpeg",
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Admin",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Manage your hotel efficiently",
                      style: TextStyle(color: Colors.white70),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Admin Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _nameControlller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Enter you name",
                                prefixIcon: const Icon(Icons.person),
                                filled: true,
                                fillColor: Colors.black,
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter password";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Enter your password",
                                filled: true,
                                prefixIcon: const Icon(Icons.lock),
                                fillColor: Colors.black,
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                _login(context);
                              },
                              child: const Text("Login"))
                        ],
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
