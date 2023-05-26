import 'package:flutter/material.dart';
import 'package:incrementapp/constants/routes.dart';
import 'package:incrementapp/services/auth/auth_exceptions.dart';
import 'package:incrementapp/services/auth/auth_service.dart';
import '../constants/my_button.dart';
import 'forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscureTextToggle = true;
  late final TextEditingController _email;
  late final TextEditingController _password;
  String _errorMessage = '';

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

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
                // Logo
                const Icon(
                  Icons.eject_outlined,
                  size: 100,
                  color: Color.fromARGB(255, 251, 251, 251),
                ),

                const Text(
                  'increments',
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

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _password,
                    obscureText: _obscureTextToggle,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 230, 230, 230)),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextToggle = !_obscureTextToggle;
                            });
                          },
                          child: Icon(
                            _obscureTextToggle
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          )),
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

// Forgot Password
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ForgotPasswordView();
                          }));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 184, 184, 184)),
                        ),
                      ),
                    ],
                  ),
                ),

// Error Message
                if (_errorMessage.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 25, right: 25),
                      child: Text(
                        textAlign: TextAlign.center,
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

// Sign In Button
                MyButton(
                    onTap: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await AuthService.firebase().logIn(
                          email: email,
                          password: password,
                        );

                        final user = AuthService.firebase().currentUser;
                        if (user?.isEmailVerified ?? false) {
                          // Email is verified
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            habitsRoute,
                            (route) => false,
                          );
                        } else {
                          // Email is not verified
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute,
                            (route) => false,
                          );
                        }
                      } on UserNotFoundAuthException {
                        setState(() {
                          _errorMessage = 'Oops! The user does not exist.';
                        });
                      } on WrongPasswordAuthException {
                        setState(() {
                          _errorMessage = 'Uh-oh! The password is invalid.';
                        });
                      } on GenericAuthException {
                        // await showErrorDialog(context, 'Authentication Error');
                        setState(() {
                          _errorMessage =
                              'Sorry, there appears to be an authentication error.';
                        });
                      } on MissingDetailsAuthException {
                        setState(() {
                          _errorMessage =
                              'Oh no, it seems like your email and password are on a vacation!';
                        });
                      }
                    },
                    child: const Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color.fromARGB(255, 21, 21, 21),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )),

                const SizedBox(height: 50),

// Divider
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
                          "Don't have an account?",
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

// Register Button
                MyButton(
                  onTap: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  },
                  color: const Color.fromARGB(255, 186, 231, 179),
                  child: const Center(
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color.fromARGB(255, 21, 21, 21),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
