import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/constants/my_button.dart';
import 'package:incrementapp/constants/routes.dart';
import 'package:incrementapp/services/auth/auth_exceptions.dart';
import 'package:incrementapp/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

// Adding to Firestore
Future addUserDetails(String inputName, String inputEmail) async {
  await FirebaseFirestore.instance.collection('users').add({
    'name': inputName,
    'email': inputEmail,
  });
}

class _RegisterViewState extends State<RegisterView> {
  bool _obscureTextToggle = true;
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
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
                  'create an account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w200,
                  ),
                ),

                const SizedBox(height: 50),

                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _name,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Name',
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

                // Email
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

                // Password
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

                // Confirm Password
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _confirmPassword,
                    obscureText: _obscureTextToggle,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
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

                const SizedBox(height: 25),

                // Buttons
                MyButton(
                  onTap: () async {
                    final email = _email.text;
                    final password = _password.text;
                    final confirmPassword = _confirmPassword.text;

                    // Confirming Password
                    if (password != confirmPassword) {
                      await showErrorDialog(context, 'Passwords do not match.');
                      return;
                    }

                    // Exception Handling
                    try {
                      await AuthService.firebase().createUser(
                        email: email,
                        password: password,
                      );

                      AuthService.firebase().sendEmailVerification();
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        'Your password needs a gym pass!',
                      );
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(
                        context,
                        'Email is already registered!',
                      );
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        'Invalid Email.',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'Could not register.',
                      );
                    }

                    final user = AuthService.firebase().currentUser;
                    // Storing details in Firestore
                    addUserDetails(_name.text.trim(), _email.text.trim());
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

                const SizedBox(height: 10),

                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    },
                    child: const Text(
                      'Login Instead',
                      style: TextStyle(
                        color: Color.fromARGB(255, 237, 237, 237),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
