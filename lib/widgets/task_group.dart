import 'package:flutter/material.dart';
import 'package:hawli/main.dart';
import 'package:hawli/pages/deposit.dart';
import 'package:hawli/pages/news.dart';
import 'package:hawli/pages/registerUser.dart';
import 'package:hawli/pages/statics.dart';

class TaskGroupContainer extends StatelessWidget {
  final int selectedpage;
  final MaterialColor color;
  final bool? isSmall;
  final IconData icon;
  final String taskGroup;
  final int status;

  const TaskGroupContainer({
    Key? key,
    required this.color,
    required this.selectedpage,
    this.isSmall = false,
    required this.icon,
    required this.taskGroup,
    this.status = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (status == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        selectedpage: selectedpage,
                      )));
        } else if (status == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterUser()),
          );
        } else if (status == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Deposit()),
          );
        } else if (status == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const statics()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const News()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black),
          color: const Color.fromARGB(255, 247, 246, 246),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.8),
              blurRadius: 0,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: isSmall! ? Alignment.center : Alignment.center,
              child: Icon(
                icon,
                size: isSmall! ? 50 : 100,
                color: color[400],
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                taskGroup,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  color: Color.fromARGB(255, 32, 41, 46),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
