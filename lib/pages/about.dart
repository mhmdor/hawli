import 'package:flutter/material.dart';
import 'package:hawli/widgets/news.dart';
import 'package:hawli/widgets/statics.dart';
import 'package:hawli/widgets/title.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          shadowColor: const Color.fromARGB(255, 48, 53, 69),
          toolbarHeight: 60,
          title: const Text(
            'حول',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 204, 228, 248),
        extendBody: true,
        body: Column(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Title1(tilte: "حول التطبيق"),
            Text("نسخة تجريبية من التطبيق"),
            Text("الاصدار 1.0"),
          ],
        ),
        
        );
  }
}
