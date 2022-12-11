import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/pages/paymentsUser.dart';
import 'package:hawli/widgets/news.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Payment> {
  int? sortColumnIndex;
  final _formKey = GlobalKey<FormState>();
  bool isAscending = false;
  List usersFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List Users = [];
  bool is_loading = false;
  String balance = "";

  getUser() async {
    setState(() {
      is_loading = true;
    });
    String url = "${databaseHelper.serverUrl}/distributor/distributor-user";
    final prefs = await SharedPreferences.getInstance();
    // ignore: constant_identifier_names
    const Key = 'token';
    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );
    setState(() {
      Users.clear();
      Users.addAll(json.decode(response.body)["users"]);
      usersFiltered = Users;
      print(usersFiltered);
      is_loading = false;
    });

    // return status["users"][2];
  }

  void payment(String id, String balance) {
    databaseHelper.payment(id, balance).whenComplete(() {
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
            getUser();
          });
        });
      } else {
        setState(() {
          is_loading = false;
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
  void initState() {
    super.initState();

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[800],
        extendBody: true,
        body: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Card(
                  color: const Color.fromARGB(255, 247, 246, 246),
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                            hintText: 'Search', border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {
                            _searchResult = value;
                            usersFiltered = Users.where((user) =>
                                user["name"].contains(_searchResult) ||
                                user["id"]
                                    .toString()
                                    .contains(_searchResult)).toList();
                          });
                        }),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          controller.clear();
                          _searchResult = '';
                          usersFiltered = Users;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: is_loading
                        ? const CircularProgressIndicator()
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color: const Color.fromARGB(255, 42, 41, 41),
                                ),
                              ),
                              child: DataTable(
                                sortAscending: isAscending,
                                sortColumnIndex: sortColumnIndex,
                                border: TableBorder.symmetric(
                                  inside: const BorderSide(width: 1.5),
                                ),
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.blueGrey),
                                dataRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 247, 246, 246)),
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: const Text(
                                      'الاسم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    onSort: onSort,
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      'اضافة رصيد',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    // onSort: onSort,
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      'خصم رصيد',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    // onSort: onSort,
                                  ),
                                  DataColumn(
                                    label: const Text(
                                      'رصيد',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    onSort: onSort,
                                  ),
                                  DataColumn(
                                    label: const Text(
                                      'الرقم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    onSort: onSort,
                                  ),
                                ],
                                rows: List.generate(
                                  usersFiltered.length,
                                  (index) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Center(
                                        child: Text(
                                          usersFiltered[index]["name"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                      DataCell(
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 23, 118, 14)),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Stack(
                                                      children: <Widget>[
                                                        Form(
                                                          key: _formKey,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  usersFiltered[
                                                                          index]
                                                                      ["name"],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    TextFormField(
                                                                  decoration: const InputDecoration(
                                                                      labelStyle: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold),
                                                                      labelText:
                                                                          'أدخل الرصيد',
                                                                      hintText:
                                                                          'الرصيد'),
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return 'الرصيد مطلوب';
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                  onSaved:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      balance =
                                                                          value
                                                                              .toString();
                                                                    });
                                                                  },
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    ElevatedButton(
                                                                  child: const Text(
                                                                      " إضافة رصيد"),
                                                                  onPressed:
                                                                      () {
                                                                    if (_formKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      _formKey
                                                                          .currentState!
                                                                          .save();

                                                                      payment(
                                                                          usersFiltered[index]["id"]
                                                                              .toString(),
                                                                          balance
                                                                              .toString());
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: const Text("إضافة رصيد"),
                                        ),
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 148, 29, 20)),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Stack(
                                                      children: <Widget>[
                                                        Form(
                                                          key: _formKey,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  usersFiltered[
                                                                          index]
                                                                      ["name"],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    TextFormField(
                                                                  decoration: const InputDecoration(
                                                                      labelStyle: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold),
                                                                      labelText:
                                                                          'أدخل الرصيد',
                                                                      hintText:
                                                                          'الرصيد'),
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return 'الرصيد مطلوب';
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                  onSaved:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      balance =
                                                                          "-$value";
                                                                    });
                                                                  },
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    ElevatedButton(
                                                                  child: const Text(
                                                                      " خصم رصيد"),
                                                                  onPressed:
                                                                      () {
                                                                    if (_formKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      _formKey
                                                                          .currentState!
                                                                          .save();
                                                                      payment(
                                                                          usersFiltered[index]["id"]
                                                                              .toString(),
                                                                          balance
                                                                              .toString());
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: const Text("خصم رصيد"),
                                        ),
                                      ),
                                      DataCell(Center(
                                        child: Text(
                                          usersFiltered[index]["balance"]
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                      DataCell(Center(
                                        child: Text(
                                          usersFiltered[index]["id"].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      Users.sort(
          (user1, user2) => compareInt(ascending, user1["id"], user2["id"]));
    } else if (columnIndex == 1) {
      Users.sort((user1, user2) =>
          compareString(ascending, user1["name"], user2["name"]));
    } else if (columnIndex == 2) {
      Users.sort((user1, user2) =>
          compareInt(ascending, user1["balance"], user2["balance"]));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
  int compareInt(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
