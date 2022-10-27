import 'package:flutter/material.dart';

class staticsBlock extends StatelessWidget {
  final String title;
  final IconData icon;
  const staticsBlock({
    Key? key,
    required this.title, required this.icon,
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
                
                
                
                Container(
                 
                  
                  child: Center(
                    child: Text(
                       title,
                       textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueGrey[900],

                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
           Icon(
            icon,
            size: 60,
            color: Color.fromARGB(255, 221, 95, 23),
          )
        ],
      ),
    );
  }
}
