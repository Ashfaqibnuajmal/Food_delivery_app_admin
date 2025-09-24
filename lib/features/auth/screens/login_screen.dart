import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/features/auth/widgets/custom_button.dart';
import 'package:mera_web/features/auth/widgets/custom_logo.dart';
import 'package:mera_web/features/auth/widgets/custom_textformfiled.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid username and password",
              style: CustomTextStyles.snackBar)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Logo Section
          const Expanded(
            flex: 1,
            child: LoginLogoSection(
              logoPath: "assets/Logo.jpeg",
              title: "Admin",
              subtitle: "Manage your hotel efficiently",
            ),
          ),

          // Right Login Form
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
                          style: CustomTextStyles.loginHeading, // Custom style
                        ),
                        const SizedBox(height: 30),
                        LoginTextField(
                          hintText: "Enter your name",
                          icon: Icons.person,
                          controller: _nameControlller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        LoginTextField(
                          hintText: "Enter your password",
                          icon: Icons.lock,
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        LoginButton(
                          label: "Login",
                          onPressed: () => _login(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
