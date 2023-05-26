import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusables/my_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _email = TextEditingController();
  String _errorMessage = '';
  String _message = 'We will send you a link to reset your password.';

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim());
      setState(() {
        _message =
            'The password reset email has been sent to you! Please check your inbox or spam. :)';
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'Uh-oh! The account does not exist.';
        });
      } else if (e.code == 'missing-email') {
        setState(() {
          _errorMessage = 'Umm, this is not how it works.';
        });
      } else {
        setState(() {
          _errorMessage = 'Error: ${e.code}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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

// Error Message
                if (_errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
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

                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                    child: Text(
                      textAlign: TextAlign.center,
                      _message,
                      style:
                          TextStyle(color: Color.fromARGB(255, 231, 231, 231)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
