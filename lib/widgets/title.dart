import 'package:flutter/material.dart';

class Title1 extends StatelessWidget {
  final String tilte;

 

   const Title1({super.key, required this.tilte});
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
            minHeight: 80, minWidth: double.infinity, maxHeight: 80),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 247, 246, 246),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Text(tilte,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color.fromARGB(255, 49, 64, 71),
          height: 2.5,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),));
  }
}
