import 'package:flutter/material.dart';
import 'package:mcommerce/components/CustomButton.dart';
import 'package:mcommerce/components/TextFields.dart';
import 'package:mcommerce/services/AuthService.dart';
import 'package:mcommerce/pages/LoginPage.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenHeight = constraints.maxHeight;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Please Create Account To Continue",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 117, 117, 117),
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    hintText: "First Name",
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Enter Last Name",
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Enter Email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Enter Password",
                    obscure: true,
                    controller: password1Controller,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Confirm Password",
                    controller: password2Controller,
                    obscure: true,
                  ),
                  const SizedBox(height: 25),
                  CustomLongButton(
                    text: "REGISTER",
                    backgroundColor: Colors.black,
                    onPressed: () {
                      register({
                        'email': emailController.text,
                        'password1': password1Controller.text,
                        'password2': password2Controller.text,
                        'firstName': firstNameController.text,
                        'lastName': lastNameController.text,
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text("Have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
