import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/my_button.dart';
import '../utilities/show_error_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Password reset link has been sent to you'),
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await showErrorDialog(context, 'User does not exist');
      } else {
        await showErrorDialog(context, 'Error: ${e.code}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      ),
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Logo
                const Icon(
                  Icons.eject_outlined,
                  size: 100,
                  color: Color.fromARGB(255, 251, 251, 251),
                ),

                const Text(
                  'reset password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w200,
                  ),
                ),

                const SizedBox(height: 50),

                // Email + Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 230, 230, 230)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 251, 251, 251))),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Reset Button
                MyButton(
                  onTap: () async {
                    passwordReset();
                  },
                  color: Color.fromARGB(255, 231, 179, 179),
                  child: const Center(
                    child: Text(
                      "Send Email",
                      style: TextStyle(
                        color: Color.fromARGB(255, 21, 21, 21),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "We'll send you a link to reset your password.",
                  style: TextStyle(color: Color.fromARGB(255, 231, 231, 231)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
