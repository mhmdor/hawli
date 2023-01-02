import 'package:flutter/material.dart';
import 'package:hawli/pages/orders/orderBetweenDate.dart';
import 'package:hawli/pages/orders/orderById.dart';
import 'package:intl/intl.dart';

class orderbetween extends StatelessWidget {
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateoutput = TextEditingController();
  TextEditingController idinput = TextEditingController();
  late String formattedDate1;
  late String formattedDate;
  late String id;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              tooltip: "بحث",
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Stack(
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close),
                                ),
                              ),
                            ),
                            Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    "الطلبات خلال فترة معينة",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: dateoutput,
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.calendar_today),
                                            labelText: "ادخل تاريخ البداية"),
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2022),
                                                  lastDate: DateTime.now());

                                          if (pickedDate != null) {
                                            formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                            print(
                                                formattedDate); //formatted date output using intl package =>  2021-03-16
                                            //you can implement different kind of Date Format here according to your requirement

                                            //set output date to TextField value.
                                            dateoutput.text = formattedDate;
                                          } else {
                                            print("Date is not selected");
                                          }
                                        },
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: dateinput,
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.calendar_today),
                                            //icon of text field
                                            labelText:
                                                "ادخل تاريخ النهاية" //label text of field
                                            ),
                                        readOnly:
                                            true, //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          DateTime? pickedDate1 =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2022),
                                                  lastDate: DateTime.now());

                                          if (pickedDate1 != null) {
                                            formattedDate1 =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate1);
                                            print(
                                                formattedDate1); //formatted date output using intl package =>  2021-03-16

                                            dateinput.text =
                                                formattedDate1; //set output date to TextField value.
                                          } else {
                                            print("Date is not selected");
                                          }
                                        },
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        child: const Text("بحث عن طلبات"),
                                        onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      orderBetweenDate(
                                                          start: formattedDate,
                                                          end: formattedDate1)),
                                            )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.date_range,
                size: 40,
                color: Color.fromARGB(255, 8, 94, 164),
              )),
          IconButton(
              tooltip: "بحث",
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Stack(
                          children: <Widget>[
                            Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    "طلب عن طريق الرقم",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: idinput,
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.search),
                                            labelText:
                                                "ادخل رقم الطلب المطلوب "),
                                        onChanged: (value) {
                                          id = idinput.text;
                                        },
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        child: const Text("بحث عن الطلب"),
                                        onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      orderById(
                                                        id: id,
                                                      )),
                                            )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.search_rounded,
                size: 40,
                color: Color.fromARGB(255, 8, 94, 164),
              ))
        ],
      ),
    );
  }
}
