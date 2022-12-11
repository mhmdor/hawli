import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/widgets/title.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../widgets/OnGoingTask1.dart';

// ignore: camel_case_types
class orderBetweenDate extends StatefulWidget {
  final String start;
  final String end;
  const orderBetweenDate({Key? key, required this.start, required this.end})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _orderBetweenDate createState() => _orderBetweenDate(start, end);
}

// ignore: camel_case_types
class _orderBetweenDate extends State<orderBetweenDate> {
  final String start;
  final String end;
  _orderBetweenDate(this.start, this.end);

  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List Orders = [];

  List _foundorder = [];

  var name = '';

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
    });
  }

  // ignore: prefer_typing_uninitialized_variables

  getOrders() async {
    String url =
        "${databaseHelper.serverUrl}/distributor/orders-by-date?start=2022-11-12&end=2022-12-03";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';

    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url).replace(
        queryParameters: {'start': start, 'end': end},
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );

    setState(() {
      var state = json.decode(response.body);
      print(state);

      Orders.addAll(state["orders"]);

      _foundorder = Orders;
      print(_foundorder);
    });
  }

  @override
  void initState() {
    getOrders();
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        shadowColor: const Color.fromARGB(255, 48, 53, 69),
        toolbarHeight: 60,
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const Title1(
            tilte: 'نتائج الطلبات المطلوبة',
          ),
          Container(
            margin: EdgeInsets.only(top: 10,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () => _runFilter("mtn"),
                    child: const Text(
                      "mtn",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                ElevatedButton(
                    onPressed: () => _runFilter("syriatel"),
                    child: const Text(
                      "syriatel",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                ElevatedButton(
                    onPressed: () => _runFilter(""),
                    child: const Text(
                      "الكل",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    child: Orders == null || Orders.isEmpty
              ? const Center(child: CircularProgressIndicator())
              :  ListView.builder(
                        itemCount: _foundorder.length,
                        itemBuilder: ((context, index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              OnGoingTask1(
                                icon: selecticon(_foundorder[index]["status"]),
                                color:
                                    selectcolor(_foundorder[index]["status"]),
                                date: "${_foundorder[index]["date"]}",
                                name: "${_foundorder[index]["user"]["name"]}",
                                phone: "${_foundorder[index]["phone"]}",
                                value: "${_foundorder[index]["value"]}",
                                totalvalue:
                                    "${_foundorder[index]["total_value"]}",
                                sim: "${_foundorder[index]["sim"]}",
                                id: "${_foundorder[index]["id"]}",
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          );
                        })),
                  ),
                ),
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

    setState(() {
      _foundorder = results;
    });
  }

  IconData selecticon(status) {
    if (status == 2) {
      return Icons.card_travel;
    } else if (status == 0) {
      return Icons.cancel_sharp;
    } else {
      return Icons.task_alt;
    }
  }

  Color selectcolor(status) {
    if (status == 2) {
      return Colors.blue;
    } else if (status == 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
