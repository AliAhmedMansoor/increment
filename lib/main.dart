import 'package:flutter/material.dart';
import 'package:incrementapp/constants/routes.dart';
import 'package:incrementapp/services/auth/auth_service.dart';
import 'package:incrementapp/views/login_view.dart';
import 'package:incrementapp/views/main_view.dart';
import 'package:incrementapp/views/register_view.dart';
import 'package:incrementapp/views/verify_email_view.dart';
///alimansoor7897892@gmail.com
///aGoodpassword
void main() async {
  // SHAHUM: Learn about Widget Binding
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'increment',
    theme: ThemeData(
      primaryColor: Colors.red,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      habitsRoute: (context) => MainView(currentIndex: 0),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return MainView(currentIndex: 0);
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
