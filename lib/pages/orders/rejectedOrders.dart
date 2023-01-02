import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/widgets/OnGoingTask1.dart';
import 'package:hawli/widgets/orderbetween.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class RejectedOrders extends StatefulWidget {
  const RejectedOrders({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<RejectedOrders> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List Orders = [];

  List _foundorder = [];
  // ignore: prefer_typing_uninitialized_variables

  getOrders() async {
    String url = "${databaseHelper.serverUrl}/distributor/rejected-order";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );

    setState(() {
      var state = json.decode(response.body);

      Orders.addAll(state["orders"]);

      _foundorder = Orders;
      print(_foundorder);
    });
  }

  @override
  void initState() {
    getOrders();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 228, 248),
      // ignore: unnecessary_null_comparison
      body: Orders == null || Orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
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
                                icon: Icons.cancel_sharp,
                                color: const Color.fromARGB(255, 177, 29, 18),
                                date: "${_foundorder[index]["date"]}",
                                name: "${_foundorder[index]["user"]["name"]}",
                                phone: "${_foundorder[index]["phone"]}",
                                value: "${_foundorder[index]["value"]}",
                                totalvalue: "${_foundorder[index]["total_value"]}",
                                sim: "${_foundorder[index]["sim"]}",
                                id: "${_foundorder[index]["id"]}",
                                code: "${_foundorder[index]["code"]}",
                                reason:"${_foundorder[index]["reject_reason"]}" ,
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
      print(_foundorder);
    });
  }
}
