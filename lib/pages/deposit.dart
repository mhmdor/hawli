import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/pages/depositUser.dart';

import 'package:hawli/pages/paymentsUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Deposit extends StatefulWidget {
  const Deposit({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Deposit> {
  int? sortColumnIndex;
  bool isAscending = false;
  List depositFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List deposit = [];
  bool is_loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController desccon = TextEditingController();

  TextEditingController valcont = TextEditingController();
  late String desc;
  late String value1;

  void addDeposit(String id, String value, String descr) {
    databaseHelper.addDeposit(id, value, descr).whenComplete(() {
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
             depositFiltered.clear();
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
      
      deposit.addAll(json.decode(response.body)["users"]);
     
      depositFiltered = deposit;

      is_loading = false;
    });

    // return status["deposit"][2];
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          shadowColor: const Color.fromARGB(255, 48, 53, 69),
          toolbarHeight: 60,
          title: const Text(
            "الأيداعات",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                          depositFiltered = deposit
                              .where((user) =>
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
                        depositFiltered = deposit;
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
                                  const DataColumn(
                                    label: Text(
                                      'إضافة ',
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
                                      'الإيداعات',
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
                                      'رصيد',
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
                                  depositFiltered.length,
                                  (index) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Center(
                                        child: Text(
                                          depositFiltered[index]["name"],
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
                                                              const Text(
                                                                "إيداع جديد",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      TextFormField(
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return 'القيمة مطلوبة';
                                                                      } else {
                                                                        return null;
                                                                      }
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    controller:
                                                                        valcont,
                                                                    decoration: const InputDecoration(
                                                                        icon: Icon(Icons
                                                                            .search),
                                                                        labelText:
                                                                            "ادخل قيمة الايداع"),
                                                                    onChanged:
                                                                        (value) {
                                                                      value1 =
                                                                          valcont
                                                                              .text;
                                                                    },
                                                                  )),
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      TextFormField(
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return 'السبب مطلوب';
                                                                      } else {
                                                                        return null;
                                                                      }
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    controller:
                                                                        desccon,
                                                                    decoration: const InputDecoration(
                                                                        icon: Icon(Icons
                                                                            .search),
                                                                        labelText:
                                                                            "ادخل سبب الايداع"),
                                                                    onChanged:
                                                                        (value) {
                                                                      desc = desccon
                                                                          .text;
                                                                    },
                                                                  )),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    ElevatedButton(
                                                                        child: const Text(
                                                                            "اضافة الايداع"),
                                                                        onPressed:
                                                                            () {
                                                                          if (_formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            _formKey.currentState!.save();
                                                                            addDeposit(
                                                                                depositFiltered[index]["id"].toString(),
                                                                                value1,
                                                                                desc.toString());
                                                                            Navigator.pop(context);
                                                                          }
                                                                        }),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: const Text(
                                            "إضافة إيداع",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 221, 157, 19)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      depositUser(
                                                          name: depositFiltered[
                                                              index]["name"],
                                                          id: depositFiltered[
                                                                  index]["id"]
                                                              .toString())),
                                            );
                                          },
                                          child: const Text(
                                            "الإيداعات",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataCell(Center(
                                        child: Text(
                                          depositFiltered[index]["balance"]
                                              .toString(),
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
      deposit.sort(
          (user1, user2) => compareInt(ascending, user1["id"], user2["id"]));
    } else if (columnIndex == 1) {
      deposit.sort((user1, user2) =>
          compareString(ascending, user1["name"], user2["name"]));
    } else if (columnIndex == 2) {
      deposit.sort((user1, user2) =>
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
