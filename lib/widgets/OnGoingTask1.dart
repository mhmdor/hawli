import 'package:flutter/material.dart';

class OnGoingTask1 extends StatelessWidget {
  final String name;
  final String id;
  final String value;
  final String sim;
  final String totalvalue;
  final String date;
  final String phone;
  final IconData icon;
  final Color color;
  final String reason;
  final String code;

  const OnGoingTask1({
    Key? key,
    required this.name,
    required this.value,
    required this.sim,
    required this.totalvalue,
    required this.date,
    required this.phone,
    required this.id,
    this.reason = "",
    required this.code,
    required this.icon,
    required this.color,
  }) : super(key: key);
  Widget text() {
    // ignore: unnecessary_null_comparison
    if (phone == 'null') {
      return Text(
        code,
        style: const TextStyle(
          color: Color.fromARGB(255, 138, 138, 138),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      // ignore: unnecessary_null_comparison
    } else if (code == 'null') {
      return Text(
        phone,
        style: const TextStyle(
          color: Color.fromARGB(255, 138, 138, 138),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            phone,
            style: const TextStyle(
              color: Color.fromARGB(255, 138, 138, 138),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            code,
            style: const TextStyle(
              color: Color.fromARGB(255, 138, 138, 138),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (reason != "" && reason != "null") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "سبب الرفض",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          reason,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(
          10,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: const Color.fromARGB(255, 35, 35, 35)),
                  borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.phone_android_outlined,
                          color: Color.fromARGB(255, 20, 29, 34),
                        ),
                        text(),
                        Text(
                          sim,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 138, 138, 138),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 184, 214, 228),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              totalvalue,
                              style: TextStyle(
                                  color: Colors.blueGrey[900],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            date.substring(0, 10),
                            style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            date.substring(11, 16),
                            style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  id,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Icon(
                  icon,
                  size: 50,
                  color: color,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
