import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';

import 'package:hawli/widgets/title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<News> {
  int? sortColumnIndex;
  bool isAscending = false;

  late String _title;
  TextEditingController controller = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: non_constant_identifier_names
  List News = [];
  bool is_loading = false;
  String name1 = "";
  final _formKey = GlobalKey<FormState>();

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name1 = prefs.getString('name')!;
    });
  }

  getNews() async {
    setState(() {
      is_loading = true;
    });
    String url = "${databaseHelper.serverUrl}/distributor/news";
    final prefs = await SharedPreferences.getInstance();
    // ignore: constant_identifier_names
    const Key = 'token';
    final value = prefs.get(Key);

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );
    setState(() {
      News.clear();
      News.addAll(json.decode(response.body)["data"]["news_lines"]);

      print(News);
      is_loading = false;
    });
  }

  void addNews(String title) {
    is_loading = true;
    databaseHelper.addNews(title).whenComplete(() {
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
                  bottom: MediaQuery.of(context).size.height - 400,
                  right: 20,
                  left: 20),
            ))
            .closed
            .then((value) {
          setState(() {
            getNews();
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
                bottom: MediaQuery.of(context).size.height - 400,
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
                bottom: MediaQuery.of(context).size.height - 400,
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
    getNews();
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
            name1,
            style: const TextStyle(
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
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Title1(
                    tilte: 'الشريط الأخباري',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Stack(
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                                labelStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                labelText:
                                                    'أدخل الجملة الجديدة',
                                                hintText: 'الجملة'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الجملة مطلوب';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value) {
                                              setState(() {
                                                _title = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            child: const Text(" اضافة الجملة"),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                Navigator.pop(context);
                                                addNews(_title);
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
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "إضافة جملة جديدة",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: is_loading
                          ? const CircularProgressIndicator()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DataTable(
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
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'الرقم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'الجملة',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'حذف',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  News.length,
                                  (index) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Center(
                                        child: Text(
                                          News[index]["id"].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                      DataCell(Center(
                                        child: Text(
                                          News[index]["title"].toString(),
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
                                                      255, 167, 7, 7)),
                                          onPressed: () {},
                                          child: const Text(
                                            "حذف",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
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
}
