import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/widgets/OnGoingTask1.dart';
import 'package:hawli/widgets/OnGoingTask3.dart';
import 'package:hawli/widgets/title.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class EntrustingUser extends StatefulWidget {
  final String name;
  final String id;
  const EntrustingUser({Key? key, required this.name, required this.id})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _HomeState createState() => _HomeState(name, id);
}

class _HomeState extends State<EntrustingUser> {
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
    String url = "${databaseHelper.serverUrl}/distributor/orders/user/1";
    final prefs = await SharedPreferences.getInstance();
    // ignore: constant_identifier_names
    const Key = 'token';
    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url).replace(
        queryParameters: {'distributor_user_id': id},
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );

    var state = json.decode(response.body);

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
        backgroundColor: Colors.blueGrey,
        shadowColor: const Color.fromARGB(255, 48, 53, 69),
        toolbarHeight: 60,
        title: Text(
          "  $name1",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[800],
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
                                color: Colors.white,
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
                                    icon: Icons.task_alt,
                                    color: Colors.green,
                                    date: "${orders[index]["date"]}",
                                    name: "${orders[index]["user"]["name"]}",
                                    phone: "${orders[index]["phone"]}",
                                    value: "${orders[index]["value"]}",
                                    totalvalue:
                                        "${orders[index]["total_value"]}",
                                    sim: "${orders[index]["sim"]}",
                                    id: "${orders[index]["id"]}",
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
}
