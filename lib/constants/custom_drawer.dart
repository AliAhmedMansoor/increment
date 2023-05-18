import 'package:flutter/material.dart';
import 'package:incrementapp/constants/routes.dart';
import 'package:incrementapp/services/auth/auth_service.dart';

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
      child: Container(
        height: 480,
        child: Drawer(
          backgroundColor: const Color.fromARGB(255, 26, 26, 26),
          width: 200,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 20),
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
                      Text(
                        name ?? "",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    "Mode",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.dark_mode, color: Colors.white),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.settings, color: Colors.white),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.logout, color: Colors.white),
                  onTap: () async {
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
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

// Log Out Dialog
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Would you like to sign out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
