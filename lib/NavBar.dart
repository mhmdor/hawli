import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/pages/about.dart';
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
  var newPass = "";
  var oldPass = "";
  var confPass = "";

  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      phone = prefs.getString('phone')!;
    });
  }

  void changePasswprd() {
    DatabaseHelper()
        .changePassword(newPass, oldPass, confPass)
        .whenComplete(() {
      
      if (databaseHelper.status) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'تم تغيير كلمة السر بنجاح',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 400,
              right: 20,
              left: 20),
        ));
      } else {
        if (databaseHelper.time) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'خطأ بالأتصال بالسيرفر يرجى المحاولة لاحقا',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 400,
                right: 20,
                left: 20),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'عذرا العملية خاطئة',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 400,
                right: 20,
                left: 20),
          ));
        }
      }
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
      backgroundColor: Colors.blue,
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
                      style: const TextStyle(
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
              Icons.password,
              color: Colors.white,
            ),
            title: const Text(
              'تغيير كلمة السر',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: AlertDialog(
                        content: Stack(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          labelText: 'أدخل كلمة السر القديمة',
                                          hintText: 'كلمة السر القديمة'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'كلمة السر القديمة مطلوبة';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          oldPass = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      key: _passKey,
                                      obscureText: true,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          labelText: 'أدخل كلمة السر الجديدة',
                                          hintText: 'كلمة السر الجديدة'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'كلمة السر الجديدة مطلوبة';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          newPass = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          labelText: 'أدخل تاكيد كلمة السر',
                                          hintText: 'تأكيد كلمة السر'),
                                      validator: (confirmPassword) {
                                        if (confirmPassword != null &&
                                            confirmPassword.isEmpty) {
                                          return 'تأكيد كلمة السر مطلوب';
                                        }
                                        var password =
                                            _passKey.currentState?.value;
                                        if (confirmPassword != null &&
                                            confirmPassword
                                                    .compareTo(password) !=
                                                0) {
                                          return 'كلمة السر غير مطابقة';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          confPass = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: const Text("تغيير كلمة السر"),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          Navigator.pop(context);
                                          Navigator.of(context).pop();
                                          changePasswprd();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
          const Divider(
            color: Colors.white,
          ),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
            leading: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            title: const Text(
              'حول التطبيق',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const About()),
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
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            " هل انت متأكد من تسجيل الخروج ؟",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
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
