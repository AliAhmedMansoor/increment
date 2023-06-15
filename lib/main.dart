import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:incrementapp/reusables/routes.dart';
import 'package:incrementapp/firebase/auth/auth_service.dart';
import 'package:incrementapp/views/login_view.dart';
import 'package:incrementapp/views/main_view.dart';
import 'package:incrementapp/views/register_view.dart';
import 'package:incrementapp/views/settings_view.dart';
import 'package:incrementapp/views/verify_email_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

String initialRoute=habitsRoute;
late final SharedPreferences preferences;
late List<String> habitName;
late int habitStartTime;
late String habitDuration;
void setUpPreferences(){

  String key;
  for(int i=1;i<4;i++)
  {
    key='routine$i';
    if(preferences.getStringList(key)==null) {
      preferences.setStringList(key, List.filled(7,''));
    }

  }
  for(int i=1;i<4;i++)
  {
    key='habitStart$i';
    if(preferences.getStringList(key)==null){
      preferences.setStringList(key,List.from(['1','0'],growable: false));
    }
  }
  for(int i=1;i<4;i++)
  {
    key='habitDuration$i';
    if(preferences.getStringList(key)==null){
      preferences.setStringList(key,List.from(['0','1'],growable: false));
    }
  }
  if(preferences.getStringList('habitName')==null){
    preferences.setStringList('habitName', List.empty(growable: true));
  }

}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();

  preferences = await SharedPreferences.getInstance();
  preferences.clear();
  setUpPreferences();

  runApp(MaterialApp(
    title: 'increment',
    theme: ThemeData.dark(),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      habitsRoute: (context) => MainView(currentIndex: 0),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      settingsRoute: (context) => const SettingsView(),
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
