import 'package:flutter/material.dart';
import 'package:incrementapp/firebase/auth/auth_service.dart';
import 'package:incrementapp/reusables/routes.dart';
import 'package:incrementapp/views/settings_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({required this.name, Key? key}) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: SizedBox(
        height: 410,
        child: Drawer(
          backgroundColor: Color.fromARGB(255, 32, 32, 32),
          width: 210,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 70, bottom: 20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Color.fromARGB(255, 43, 43, 43),
                        child: Text(
                          "🗿",
                          style: TextStyle(fontSize: 45.0),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          name ?? "",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.settings, color: Colors.white),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SettingsView();
                    })).then((_) {
// Closing the custom drawer
                      Navigator.pop(context);
                    });
                  },
                ),
                ListTile(
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.logout, color: Colors.white),
                  onTap: () async {
                    Navigator.of(context).pop(true);

                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
