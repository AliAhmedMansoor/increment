import 'package:flutter/material.dart';
import 'package:incrementapp/constants/my_button.dart';
import 'package:incrementapp/constants/routes.dart';
import 'package:incrementapp/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(
                  Icons.eject_outlined,
                  size: 100,
                  color: Color.fromARGB(255, 251, 251, 251),
                ),
                const Text(
                  'verify email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "The email has been sent to you.",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Text(
                  'In case you haven\'t received, tap the button.',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 50),
                MyButton(
                  onTap: () async {
                    await AuthService.firebase().sendEmailVerification();
                  },
                  child: const Center(
                    child: Text(
                      "Resend Verification",
                      style: TextStyle(
                        color: Color.fromARGB(255, 21, 21, 21),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Already verified?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                MyButton(
                  onTap: () async {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  color: const Color.fromARGB(255, 186, 231, 179),
                  child: const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color.fromARGB(255, 21, 21, 21),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      habitsRoute,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Not Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
