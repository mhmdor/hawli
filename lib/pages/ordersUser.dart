import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/widgets/OnGoingTask1.dart';
import 'package:hawli/widgets/OnGoingTask3.dart';
import 'package:hawli/widgets/title.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class EntrustingUser2 extends StatefulWidget {
  final String name;
  final String id;
  const EntrustingUser2({Key? key, required this.name, required this.id})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _HomeState createState() => _HomeState(name, id);
}

class _HomeState extends State<EntrustingUser2> {
  final String name;
  final String id;

  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List orders = [];
  bool isLoading = false;
  var name1 = '';

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name1 = prefs.getString('name')!;
    });
  }

  getorders() async {
    print(id);
    String url = "${databaseHelper.serverUrl}/distributor/orders/user/$id";
    final prefs = await SharedPreferences.getInstance();
    // ignore: constant_identifier_names
    const Key = 'token';
    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );

    var state = json.decode(response.body);
    print(state);
    orders.addAll(state["orders"]);

    print(orders);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getorders();
    getUser();
    isLoading = true;
    super.initState();
  }

  _HomeState(this.name, this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: const Color.fromARGB(255, 48, 53, 69),
        toolbarHeight: 60,
        title: Text(
          "  $name1",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 204, 228, 248),
      extendBody: true,
      body: Column(
        children: [
          Title1(
            tilte: " طلبات $name",
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: orders.isEmpty
                        ? const Center(
                            child: Text(
                            "لايوجد طلبات ",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ))
                        : ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  OnGoingTask1(
                                    code: "${orders[index]["code"]}",
                                    icon: selecticon(orders[index]["status"]),
                                    color: selectcolor(orders[index]["status"]),
                                    date: "${orders[index]["date"]}",
                                    name: "${orders[index]["user"]["name"]}",
                                    phone: "${orders[index]["phone"]}",
                                    value: "${orders[index]["value"]}",
                                    totalvalue:
                                        "${orders[index]["total_value"]}",
                                    sim: "${orders[index]["sim"]}",
                                    id: "${orders[index]["id"]}",
                                    reason: "${orders[index]["reject_reason"]}",
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  )
                                ],
                              );
                            })),
                  ),
          ),
        ],
      ),
    );
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
