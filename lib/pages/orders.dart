import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/widgets/news.dart';
import 'package:hawli/widgets/orderbetween.dart';
import 'package:hawli/widgets/title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/OnGoingTask.dart';
import 'package:http/http.dart' as http;

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Orders> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List Orders = [];
  bool isLoading = false;

  getOrders() async {
    String url = "${databaseHelper.serverUrl}/distributor/pindding-order";
    final prefs = await SharedPreferences.getInstance();
    // ignore: constant_identifier_names
    const Key = 'token';
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
      Orders.clear();
      Orders.addAll(state["orders"]);

      print(Orders);

      isLoading = false;
    });
  }

  @override
  void initState() {
    getOrders();
    isLoading = true;
    super.initState();
  }

  void acceptOrder(String id) {
    databaseHelper.acceptOrder(id).whenComplete(() {
      if (databaseHelper.status) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: const Text(
                'تمت العملية بنجاح',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 200,
                  right: 20,
                  left: 20),
            ))
            .closed
            .then((value) {
          setState(() {
            getOrders();
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (databaseHelper.time) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'خطأ بالأتصال بالسيرفر يرجى المحاولة لاحقا',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 200,
                right: 20,
                left: 20),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'عذرا العملية خاطئة',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 200,
                right: 20,
                left: 20),
          ));
        }
      }
    });
  }

  void rejectOrder(String id) {
    databaseHelper.rejectOrder(id).whenComplete(() {
      if (databaseHelper.status) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: const Text(
                'تم رفض العملية',
                textAlign: TextAlign.center,
              ),
              backgroundColor: const Color.fromARGB(255, 218, 117, 9),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 200,
                  right: 20,
                  left: 20),
            ))
            .closed
            .then((value) {
          setState(() {
            getOrders();
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (databaseHelper.time) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'خطأ بالأتصال بالسيرفر يرجى المحاولة لاحقا',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 200,
                right: 20,
                left: 20),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'عذرا العملية خاطئة',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 200,
                right: 20,
                left: 20),
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      extendBody: true,
      body: Column(
        children: [
          Title1(tilte: 'طلباتي الجديدة',),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Orders.isEmpty
                        ? const Center(
                            child: Text(
                            "لايوجد طلبات جديدة",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                        : ListView.builder(
                            itemCount: Orders.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(
                                                    height: 24,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: (() {}),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 58, 98, 2),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50,
                                                          vertical: 10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: const [
                                                        Icon(Icons
                                                            .task_alt_rounded),
                                                        Text('تسديد أوتو',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      acceptOrder(
                                                          "${Orders[index]["id"]}");
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 9, 44, 106),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50,
                                                          vertical: 10),
                                                    ),
                                                    child: isLoading
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: const [
                                                              Icon(Icons.task),
                                                              Text('تسديد يدوي',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                            ],
                                                          ),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      rejectOrder(
                                                          "${Orders[index]["id"]}");
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 159, 18, 18),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50,
                                                          vertical: 10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: const [
                                                        Icon(Icons
                                                            .cancel_outlined),
                                                        Text('رفض الطلب',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: OnGoingTask(
                                      date: "${Orders[index]["date"]}",
                                      name: "${Orders[index]["user"]["name"]}",
                                      phone: "${Orders[index]["phone"]}",
                                      value: "${Orders[index]["value"]}",
                                      totalvalue:
                                          "${Orders[index]["total_value"]}",
                                      sim: "${Orders[index]["sim"]}",
                                      id: "${Orders[index]["id"]}",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  )
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
}
