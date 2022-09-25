import 'package:flutter/material.dart';

class OnGoingTask1 extends StatelessWidget {
  const OnGoingTask1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "مركز أبو العبد التجاري",
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
                 Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 184, 214, 228),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "20000 ",
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Icon(
                      Icons.hourglass_bottom,
                      color: Color.fromARGB(255, 20, 29, 34),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "2022/12/12 3:45",
                      style: TextStyle(
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
               
              ],
            ),
          ),
          const Icon(
            Icons.add_task,
            size: 60,
            color: Color.fromARGB(255, 221, 95, 23),
          )
        ],
      ),
    );
  }
}
