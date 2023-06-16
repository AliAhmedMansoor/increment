import 'package:flutter/material.dart';
import 'package:incrementapp/reusables/my_button.dart';
import 'package:incrementapp/reusables/my_secondary_butto.dart';
import 'package:incrementapp/reusables/routes.dart';
import 'package:incrementapp/firebase/auth/auth_exceptions.dart';
import 'package:incrementapp/firebase/auth/auth_service.dart';
import 'package:incrementapp/themes/colours.dart';
import 'forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  bool _obscureTextToggle = true;
  late final TextEditingController _email;
  late final TextEditingController _password;
  String _errorMessage = '';

  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          body: Center(
        child: AnimatedBuilder(
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
                            'increment¹',
                            style: TextStyle(
                              color: Colours.heading,
                              fontSize: 32,
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
                                        _obscureTextToggle =
                                            !_obscureTextToggle;
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
                                    style: TextStyle(color: Colours.body),
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
                                    color: Colours.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          // Sign In Button
                          MyButton(
                              color: Colours.mainButton,
                              onTap: () async {
                                final email = _email.text;
                                final password = _password.text;
                                try {
                                  await AuthService.firebase().logIn(
                                    email: email,
                                    password: password,
                                  );

                                  final user =
                                      AuthService.firebase().currentUser;
                                  if (user?.isEmailVerified ?? false) {
                                    // Email is verified
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      habitsRoute,
                                      (route) => false,
                                    );
                                  } else {
                                    // Email is not verified
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      verifyEmailRoute,
                                      (route) => false,
                                    );
                                  }
                                } on UserNotFoundAuthException {
                                  setState(() {
                                    _errorMessage =
                                        'Oops! The user does not exist.';
                                  });
                                } on WrongPasswordAuthException {
                                  setState(() {
                                    _errorMessage =
                                        'Uh-oh! The password is invalid.';
                                  });
                                } on GenericAuthException {
                                  // await showErrorDialog(context, 'Authentication Error');
                                  setState(() {
                                    _errorMessage =
                                        'Sorry, something seems to be wrong.';
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
                                    color: Colours.mainText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )),

                          const SizedBox(height: 50),

                          // Divider
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colours.body,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    "1. One percent better every day!",
                                    style: TextStyle(color: Colours.body),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colours.body,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Register Button
                          MySecondaryButton(
                            onTap: () async {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  registerRoute, (route) => false);
                            },
                            child: const Center(
                              child: Text(
                                "Get Started",
                                style: TextStyle(
                                  color: Colours.secondaryButtonText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      )),
    );
  }
}
