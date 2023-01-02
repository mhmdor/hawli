import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class news extends StatefulWidget {
  @override
  State<news> createState() => _newsState();
}

class _newsState extends State<news> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List News = [];
  List<String> list = [];

  bool isLoading = false;

  getNews() async {
    String url = "${databaseHelper.serverUrl}/distributor/news";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';

    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    ).timeout(const Duration(seconds: 10), onTimeout: () {
      setState(() {
        isLoading = false;
      });

      return Future.error('error');
    });

    setState(() {
      var state = json.decode(response.body)["data"]["news_lines"];

      News.addAll(state);
      isLoading = false;
      for (var i = 0; i < News.length; i++) {
        list.add(News[i]["title"]);
      }
    });
  }

  @override
  void initState() {
    getNews();
    isLoading = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
            minHeight: 60, minWidth: double.infinity, maxHeight: 80),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 32, 102, 159),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: isLoading
            ? const Center(child:  CircularProgressIndicator())
            : CarouselSlider(
                options: CarouselOptions(
                  scrollDirection: Axis.vertical,
                  autoPlay: true,
                ),
                items: list
                    .map(
                      (item) => Center(
                          child: Text(
                        item,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      )),
                    )
                    .toList(),
              ));
  }
}
