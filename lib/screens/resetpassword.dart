/// This class is a stateful widget that has a textfield for the user to enter their email address. When
/// the user presses the reset button, the resetPassword() function is called. This function sends a
/// password reset email to the user's email address
import 'package:cis/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: Column(
              children: [
                // SizedBox(height: .h),
                Container(
                  height: 150,
                  width: 190,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage("assets/login.jpg"))),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 300,
                  height: 180,

                  color: Colors.white,
                  // color: kPrimaryColor,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color.fromARGB(160, 206, 206, 206),
                            filled: true,
                            label: Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                          onPressed: resetPassword, child: const Text("Reset"))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Fluttertoast.showToast(msg: "Password Resent Email has been Sent");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyLogin()),
      );

      // ignore: use_build_context_synchronously

    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
