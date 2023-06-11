import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/reusables/my_button.dart';
import 'package:incrementapp/reusables/my_secondary_butto.dart';
import 'package:incrementapp/reusables/routes.dart';
import 'package:incrementapp/firebase/auth/auth_exceptions.dart';
import 'package:incrementapp/firebase/auth/auth_service.dart';
import 'package:incrementapp/themes/colours.dart';

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

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  bool _obscureTextToggle = true;
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  String _errorMessage = '';

  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
        tween:
            Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween:
            Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Colours.gradient1,
                    Colours.gradient2,
                  ],
                  begin: _topAlignmentAnimation.value,
                  end: _bottomAlignmentAnimation.value,
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),

                        const Text(
                          'create an account',
                          style: TextStyle(
                            color: Colours.heading,
                            fontSize: 30,
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
                            style: const TextStyle(color: Colours.mainText),
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle:
                                  const TextStyle(color: Colours.hintText),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colours.unfocusedBorder)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colours.focusedBorder)),
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
                            style: const TextStyle(color: Colours.mainText),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle:
                                  const TextStyle(color: Colours.hintText),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colours.unfocusedBorder)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colours.focusedBorder)),
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
                            style: const TextStyle(color: Colours.mainText),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle:
                                  const TextStyle(color: Colours.hintText),
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
                                    color: Colours.hintEye,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colours.unfocusedBorder)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colours.focusedBorder)),
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
                            style: const TextStyle(color: Colours.mainText),
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle:
                                  const TextStyle(color: Colours.hintText),
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
                                    color: Colours.hintEye,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colours.unfocusedBorder)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colours.focusedBorder)),
                            ),
                          ),
                        ),

                        // Error Message
                        if (_errorMessage.isNotEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 25, right: 25, bottom: 0),
                              child: Text(
                                textAlign: TextAlign.center,
                                _errorMessage,
                                style: const TextStyle(
                                  color: Colours.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Buttons
                        MyButton(
                          color: Colours.mainButton,
                          onTap: () async {
                            final email = _email.text;
                            final password = _password.text;
                            final confirmPassword = _confirmPassword.text;

                            // Confirming Password
                            if (password != confirmPassword) {
                              setState(() {
                                _errorMessage =
                                    'Passwords are not identical twins.';
                              });
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
                              setState(() {
                                _errorMessage =
                                    'Your password needs a gym pass!';
                              });
                            } on EmailAlreadyInUseAuthException {
                              setState(() {
                                _errorMessage =
                                    'Oops! An account with this email already exists.';
                              });
                            } on InvalidEmailAuthException {
                              setState(() {
                                _errorMessage =
                                    'Uh-oh! The email syntax is invalid.';
                              });
                            } on GenericAuthException {
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

                            final user = AuthService.firebase().currentUser;
                            // Storing details in Firestore
                            addUserDetails(
                                _name.text.trim(), _email.text.trim());
                          },
                          child: const Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colours.mainText,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        MySecondaryButton(
                          onTap: () async {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoute, (route) => false);
                          },
                          child: const Center(
                            child: Text(
                              "Go Back",
                              style: TextStyle(
                                color: Colours.secondaryButtonText,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
