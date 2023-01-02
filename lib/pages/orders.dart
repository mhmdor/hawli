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
  final _formKey = GlobalKey<FormState>();
  late String _reason;

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
                  bottom: MediaQuery.of(context).size.height - 400,
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

  void rejectOrder(String id, String rejectReason) {
    databaseHelper.rejectOrder(id, rejectReason).whenComplete(() {
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
                  bottom: MediaQuery.of(context).size.height - 400,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 228, 248),
      extendBody: true,
      body: Column(
        children: [
          const Title1(
            tilte: 'طلباتي الجديدة',
          ),
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
                                color: Colors.blue,
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
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  const Text(
                                                                    "أدخل السبب ",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color.fromARGB(255, 8, 32, 52),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Form(
                                                                    key:
                                                                        _formKey,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              TextFormField(
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'سبب الرفض  مطلوب';
                                                                              } else {
                                                                                return null;
                                                                              }
                                                                            },
                                                                            onSaved:
                                                                                (value) {
                                                                              setState(() {
                                                                                _reason = value.toString();
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              backgroundColor: const Color.fromARGB(255, 159, 18, 18),
                                                                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                                            ),
                                                                            child:
                                                                                const Text("رفض الطلب"),
                                                                            onPressed:
                                                                                () {
                                                                              if (_formKey.currentState!.validate()) {
                                                                                _formKey.currentState!.save();
                                                                                Navigator.pop(context);
                                                                                setState(() {
                                                                                  isLoading = true;
                                                                                });
                                                                                rejectOrder("${Orders[index]["id"]}", _reason);
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
                                      code: "${Orders[index]["code"]}",
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


// SendUssd(String Company, String Code, String Code1, String Code2) async {
//     setState(() {
//       is_loading = true;
//     });
//     print(Company);

//     SqlDb sqldb = SqlDb();

//     String star = "*";
//     String square = "#";
//     String Ussd;
//     if (Code2 == "") {
//       Ussd = star +
//           Code +
//           star +
//           Code1 +
//           star +
//           phoneController.text +
//           star +
//           valueController.text +
//           square;
//     } else {
//       Ussd = star +
//           Code +
//           star +
//           Code1 +
//           star +
//           Code2 +
//           star +
//           phoneController.text +
//           star +
//           valueController.text +
//           square;
//     }
//     print(Ussd);

//     String phone = phoneController.text;
//     String value = valueController.text;
//     String price = priceController.text;

   
//     try {
//       var status = await Permission.phone.status;
//       if (!status.isGranted) {
//         bool isGranted = await Permission.phone.request().isGranted;
//         if (!isGranted) return;
//       }
//       SimData simData = await SimDataPlugin.getSimData();

//       if (Company == "mtn") {
//         for (var s in simData.cards) {
//           if (s.mnc == 2) {
//             sim = s;
//           }
//         }
//       } else if (Company == "syriatel") {
//         SimData simData = await SimDataPlugin.getSimData();
//         for (var s in simData.cards) {
//           if (s.mnc == 1) {
//             sim = s;
//           }
//         }
//       }
//       String? _res = await UssdAdvanced.sendAdvancedUssd(
//           code: Ussd, subscriptionId: sim.subscriptionId);
//          int responseSQL = await sqldb.inserData(
//         "INSERT INTO 'operations' ('phone','value','price','response','company') VALUES ($phone , $value , $price , '$_res','$Company' )");

//     print(responseSQL);

//       setState(() {
//         _response = _res;

//         is_loading = false;
//         phoneController.text = "";
//         valueController.text = "";
//         priceController.text = "";
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }