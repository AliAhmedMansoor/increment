import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/themes/colours.dart';
import '../reusables/my_button.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  String _errorMessage = '';
  String _nameError = '';
  String _nameSuccess = '';
  String _message = 'We will send you a link to reset your password.';
  final firestoreInstance = FirebaseFirestore.instance;
  String? fetchedName;
  String? fetchedUuid;

  @override
  void initState() {
    super.initState();

// Reading Name or Greeting
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get()
          .then((querySnapshot) {
        final List<DocumentSnapshot> documentList = querySnapshot.docs;

        if (documentList.isNotEmpty) {
          final String uuid = documentList.first.id;
          final String name = documentList.first['name'];

          setState(() {
            fetchedName = name;
            fetchedUuid = uuid;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> nameUpdate(String newName) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();
      final List<DocumentSnapshot> documentList = querySnapshot.docs;

      if (documentList.isNotEmpty) {
        final String uuid = documentList.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uuid)
            .update({'name': newName});

        setState(() {
          fetchedName = newName;
        });
      }
    }
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Settings'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colours.gradient1,
                Colours.gradient2,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colours.body,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                  color: Colours.mainText,
                                  fontSize: 16,
                                ),
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

                      const SizedBox(height: 15),

                      // Email + Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          controller: _name,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(
                            color: Colours.mainText,
                          ),
                          decoration: InputDecoration(
                            hintText: fetchedName,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colours.unfocusedBorder,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colours.focusedBorder),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Error Message
                      if (_nameError.isNotEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15.0, left: 25, right: 25),
                            child: Text(
                              _nameError,
                              style: const TextStyle(
                                color: Colours.error,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                      // Success Message
                      if (_nameSuccess.isNotEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15.0, left: 25, right: 25),
                            child: Text(
                              _nameSuccess,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                      // Update Button
                      MyButton(
                        color: Colours.mainButton,
                        onTap: () {
                          if (_name.text.trim().isEmpty) {
                            setState(() {
                              _nameError =
                                  'Oh no, it seems like your name has vanished into thin air!';
                              _nameSuccess = '';
                            });
                          } else {
                            setState(() {
                              _nameError = '';
                              _nameSuccess = 'Your name has been updated! 🎉';
                            });
                            nameUpdate(_name.text.trim());
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colours.mainText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // PASSWORD
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colours.body,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "Password",
                                style: TextStyle(
                                  color: Colours.mainText,
                                  fontSize: 16,
                                ),
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

                      const SizedBox(height: 15),

                      // Email + Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          controller: _email,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Colours.mainText,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colours.unfocusedBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colours.focusedBorder),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Error Message
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, left: 25, right: 25),
                          child: Center(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                color: Colours.error,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                      // Reset Button
                      MyButton(
                        onTap: () async {
                          passwordReset();
                        },
                        color: Colours.mainButton,
                        child: const Center(
                          child: Text(
                            "Reset",
                            style: TextStyle(
                              color: Colours.mainText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 24),
                          child: Text(
                            textAlign: TextAlign.center,
                            _message,
                            style: const TextStyle(color: Colours.body),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
