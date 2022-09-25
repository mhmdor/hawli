import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class news extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> list = [
      'السادة المشتركين يرجى تسديد ذممكم المالية',
      'كل عام و انتم بخير',
      'للتواصل يرجى الاتصال على الرقم التالي 09999999999',
    ];
    return Container(
       constraints: const BoxConstraints(
              minHeight: 60, minWidth: double.infinity, maxHeight: 80 ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 247, 246, 246),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: CarouselSlider(
          options: CarouselOptions(
            scrollDirection: Axis.vertical,
            autoPlay: true,
          ),
          items: list
              .map(
                (item) => Center(child: Text(item,
               style: const TextStyle(
                 fontWeight: FontWeight.bold,
               ),)),
              )
              .toList(),
        ));
  }
}
