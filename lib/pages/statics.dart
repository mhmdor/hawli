import 'package:flutter/material.dart';
import 'package:hawli/widgets/news.dart';
import 'package:hawli/widgets/statics.dart';

class statics extends StatefulWidget {
  const statics({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<statics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          shadowColor: const Color.fromARGB(255, 48, 53, 69),
          toolbarHeight: 60,
          title: const Text(
            'الإحصائيات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 204, 228, 248),
        extendBody: true,
        body: _buildBody());
  }

  Stack _buildBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 65,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 50,
                ),
                staticsBlock(
                  title: 'احصائيات المستخدمين آخر شهر',
                  icon: Icons.account_box,
                ),
                SizedBox(
                  height: 30,
                ),
                staticsBlock(
                  title: 'الارصدة',
                  icon: Icons.add_box,
                ),
                SizedBox(
                  height: 30,
                ),
                staticsBlock(
                  title: 'العمليات',
                  icon: Icons.add_chart,
                ),
                SizedBox(
                  height: 30,
                ),
                staticsBlock(
                  title: 'الاحصائيات اخر شهر',
                  icon: Icons.alarm_sharp,
                ),
              ],
            ),
          ),
        ),
        news(),
      ],
    );
  }
}
