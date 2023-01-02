import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';


import 'package:hawli/widgets/title.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../widgets/deposit.dart';

class depositUser extends StatefulWidget {
  final String name;
  final String id;
  const depositUser({Key? key, required this.name, required this.id})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _HomeState createState() => _HomeState(name, id);
}

class _HomeState extends State<depositUser> {
  final String name;
  final String id;

  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List deposit = [];
  bool isLoading = false;
  var name1 = '';

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name1 = prefs.getString('name')!;
    });
  }

  getdeposit() async {
    print(id);
    String url = "${databaseHelper.serverUrl}/distributor/deposits-user?user_id=";
    final prefs = await SharedPreferences.getInstance();
    // ignore: constant_identifier_names
    const Key = 'token';
    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url).replace(
        queryParameters: {'user_id': id},
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );

    var state = json.decode(response.body);
    print(state);
    deposit.addAll(state);

    print(deposit);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getdeposit();
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
            tilte: " إيداعات $name",
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: deposit.isEmpty
                        ? const Center(
                            child: Text(
                            "لايوجد إيداعات ",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ))
                        : ListView.builder(
                            itemCount: deposit.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Deposit(
                                    
                                    date: "${deposit[index]["created_at"]}",
                                    
                                   
                                    value: "${deposit[index]["value"]}",
                                   
                                    id: "${deposit[index]["id"]}", desc: "${deposit[index]["description"]}",
                                   
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
