import 'package:flutter/material.dart';
import 'package:mcommerce/components/CustomButton.dart';
import 'package:mcommerce/components/TextFields.dart';
import 'package:mcommerce/services/AuthService.dart';
import 'package:mcommerce/pages/RegisterPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Please Sign In To Continue",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: const Color.fromARGB(255, 117, 117, 117)),
                ),
                SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  hintText: "Enter Email",
                  controller: emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  obscure: true,
                  hintText: "Enter Password",
                  controller: passwordController,
                ),
                SizedBox(
                  height: 25,
                ),
                CustomLongButton(
                  text: "LOGIN",
                  backgroundColor: Colors.black,
                  onPressed: () {
                    login({
                      'email': emailController.text,
                      'password': passwordController.text
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
