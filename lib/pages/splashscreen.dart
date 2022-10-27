import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawli/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => read());
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);
    
    if (value != '0') {
      // ignore: use_build_context_synchronously
      return Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ignore: use_build_context_synchronously
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignIn(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo(160, 160),
            const SizedBox(
              height: 35,
            ),
            richText(35),
          ],
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return SvgPicture.asset(
      'assets/logo.svg',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Color.fromARGB(255, 60, 135, 172),
          height: 1.03,
        ),
        children: const [
          TextSpan(
            text: 'مرحبا بك',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: ' في \n تطبيق ',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'حولي',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
