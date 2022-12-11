import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/widgets/orderbetween.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../widgets/OnGoingTask1.dart';

class AcceptedOrders extends StatefulWidget {
  const AcceptedOrders({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<AcceptedOrders> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List Orders = [];

  List _foundorder = [];
  bool isLoading = false;

  // ignore: prefer_typing_uninitialized_variables

  getOrders() async {
    String url = "${databaseHelper.serverUrl}/distributor/accepted-order";
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
      var state = json.decode(response.body);
      print(state);

      Orders.addAll(state["orders"]);
      isLoading = false;
      _foundorder = Orders;
      print(_foundorder);
    });
  }

  @override
  void initState() {
    getOrders();
    isLoading = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      // ignore: unnecessary_null_comparison
      body: Orders == null || Orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () => _runFilter("mtn"),
                          child: const Text(
                            "mtn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                      ElevatedButton(
                          onPressed: () => _runFilter("syriatel"),
                          child: const Text(
                            "syriatel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                      ElevatedButton(
                          onPressed: () => _runFilter(""),
                          child: const Text(
                            "الكل",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: ListView.builder(
                        itemCount: _foundorder.length,
                        itemBuilder: ((context, index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              OnGoingTask1(
                                icon: Icons.task_alt,
                                color: Colors.green,
                                date: "${_foundorder[index]["date"]}",
                                name: "${_foundorder[index]["user"]["name"]}",
                                phone: "${_foundorder[index]["phone"]}",
                                value: "${_foundorder[index]["value"]}",
                                totalvalue:
                                    "${_foundorder[index]["total_value"]}",
                                sim: "${_foundorder[index]["sim"]}",
                                id: "${_foundorder[index]["id"]}",
                              ),
                            ],
                          );
                        })),
                  ),
                ),
                orderbetween(),
              ],
            ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = Orders;
    } else {
      results = Orders.where((user) =>
              user["sim"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundorder = results;
    });
  }
}
