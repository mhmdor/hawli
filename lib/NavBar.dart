import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  var name = '';
  var phone = '';

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      phone = prefs.getString('phone')!;
      
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey,
      child: ListView(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(255, 247, 246, 246),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  height: 10,
                ),
                ClipOval(
                  child: SvgPicture.asset(
                    'assets/logo.svg',
                    height: 80,
                    width: 80,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 54, 70, 78),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      phone,
                      style: TextStyle(
                          color: Color.fromARGB(255, 116, 147, 162),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
            leading: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            title: const Text(
              'Favorites',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: const Text(
              'Friends',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            title: const Text(
              'Share',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => null,
          ),
          const ListTile(
            leading: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            title: Text(
              'Request',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            title: const Text(
              'تسجيل خروج  ',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onTap: () => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Stack(
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const CircleAvatar(
                                child: Icon(Icons.close),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                databaseHelper.logout();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignIn(),
                                  ),
                                );
                              },
                              child: const Text('تسجيل خروج'))
                        ],
                      ),
                    );
                  })
            },
          ),
          const Divider(
            color: Colors.white,
          ),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
            title: const Text(
              'إغلاق التطبيق',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onTap: () => exit(0),
          ),
          const Divider(
            color: Colors.white,
          ),
          const Divider(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
