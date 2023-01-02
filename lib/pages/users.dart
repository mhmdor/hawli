import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/pages/editUser.dart';
import 'package:hawli/pages/ordersUser.dart';
import 'package:hawli/pages/paymentsUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Users> {
  int? sortColumnIndex;
  bool isAscending = false;
  List usersFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List Users = [];
  bool is_loading = false;
  final _formKey = GlobalKey<FormState>();

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
      Users.addAll(json.decode(response.body)["users"]);
      usersFiltered = Users;
      print(usersFiltered);
      is_loading = false;
    });

    // return status["users"][2];
  }

  @override
  void initState() {
    super.initState();

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 204, 228, 248),
        extendBody: true,
        body: _buildBody());
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
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
                      textAlign: TextAlign.center,
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'بحث', border: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          _searchResult = value;
                          usersFiltered = Users.where((user) =>
                                  user["name"].contains(_searchResult) ||
                                  user["phone"]
                                      .toString()
                                      .contains(_searchResult) ||
                                  user["address"].contains(_searchResult) ||
                                  user["id"].toString().contains(_searchResult))
                              .toList();
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
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: is_loading
                            ? const CircularProgressIndicator()
                            : DataTable(
                                sortAscending: isAscending,
                                sortColumnIndex: sortColumnIndex,
                                border: TableBorder.all(
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        const Color.fromARGB(255, 20, 35, 50),
                                    width: 1.5),
                                dataRowHeight: 70,
                                headingRowHeight: 65,
                                dataTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 9, 39, 72)),
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 245, 245, 245)),
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: const Text(
                                      'الاسم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    onSort: onSort,
                                  ),
                                  DataColumn(
                                    label: const Text(
                                      'رصيد',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    onSort: onSort,
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      'الطلبات',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    // onSort: onSort,
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      'الدفعات',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    // onSort: onSort,
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      'تعديل',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    // onSort: onSort,
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      'الموبايل',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    // onSort: onSort,
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      'العنوان',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    // onSort: onSort,
                                  ),
                                  DataColumn(
                                    label: const Text(
                                      'الرقم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
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
                                      DataCell(Center(
                                        child: Text(
                                          usersFiltered[index]["balance"]
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                      DataCell(
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 10, 103, 36)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EntrustingUser2(
                                                          name: usersFiltered[
                                                              index]["name"],
                                                          id: usersFiltered[
                                                                  index]["id"]
                                                              .toString())),
                                            );
                                          },
                                          child: const Text(
                                            "الطلبات",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(
                                                  255, 221, 157, 19)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EntrustingUser(
                                                          name: usersFiltered[
                                                              index]["name"],
                                                          id: usersFiltered[
                                                                  index]["id"]
                                                              .toString())),
                                            );
                                          },
                                          child: const Text(
                                            "الدفعات",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 171, 3, 40)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditUser(
                                                        name:
                                                            usersFiltered[index]
                                                                ["name"],
                                                                address:
                                                            usersFiltered[index]
                                                                ["address"],
                                                        id: usersFiltered[index]
                                                                ["id"]
                                                            .toString(),
                                                        minBalance: usersFiltered[
                                                                    index]
                                                                ["min_balance"]
                                                            .toString(),
                                                        ratio:
                                                            usersFiltered[index]
                                                                    ["ratio"]
                                                                .toString(),
                                                      )),
                                            );
                                          },
                                          child: const Text(
                                            "تعديل المعلومات",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataCell(Center(
                                        child: Text(
                                          usersFiltered[index]["phone"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                      DataCell(Center(
                                        child: Text(
                                          usersFiltered[index]["address"],
                                          textAlign: TextAlign.center,
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
          ),
        ],
      ),
    );
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
