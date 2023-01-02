import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/widgets/title.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../widgets/OnGoingTask1.dart';

// ignore: camel_case_types
class orderById extends StatefulWidget {
  final String id;

  const orderById({Key? key, required this.id}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _orderById createState() => _orderById(id);
}

// ignore: camel_case_types
class _orderById extends State<orderById> {
  final String id;

  _orderById(this.id);

  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List Orders = [];

  var name = '';
  bool isloading = false;

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
    });
  }

  // ignore: prefer_typing_uninitialized_variables

  getOrders() async {
    String url = "${databaseHelper.serverUrl}/distributor/search-by-id?id";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';

    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url).replace(
        queryParameters: {'id': id},
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );

    setState(() {
      var state = json.decode(response.body);

      isloading = false;
      if (state["status"] == true) {
        Orders.add(state["data"]["order"]);
      }
    });
  }

  @override
  void initState() {
    isloading = true;
    getOrders();
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 228, 248),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
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
          Expanded(
            child: isloading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Orders.isEmpty
                        ? const Center(
                            child: Text(
                              'الطلب غير موجود ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 20),
                            ),
                          )
                        : ListView.builder(
                            itemCount: Orders.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  OnGoingTask1(
                                    code: "${Orders[index]["code"]}",
                                    icon: selecticon(Orders[index]["status"]),
                                    color: selectcolor(Orders[index]["status"]),
                                    date: "${Orders[index]["date"]}",
                                    name: "${Orders[index]["user"]["name"]}",
                                    phone: "${Orders[index]["phone"]}",
                                    value: "${Orders[index]["value"]}",
                                    totalvalue:
                                        "${Orders[index]["total_value"]}",
                                    sim: "${Orders[index]["sim"]}",
                                    id: "${Orders[index]["id"]}",
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
