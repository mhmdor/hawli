import 'package:flutter/material.dart';
import 'package:hawli/widgets/news.dart';
import '../widgets/OnGoingTask.dart';


class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      
       backgroundColor: Colors.blueGrey[800],
        extendBody: true,
        body: _buildBody());
  }

  Stack _buildBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 65,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                
                 SizedBox(
                  height: 30,
                ),
                 OnGoingTask(),
                 SizedBox(
                  height: 30,
                ),
                 OnGoingTask(),
                 SizedBox(
                  height: 30,
                ),
                 OnGoingTask(),
                 SizedBox(
                  height: 30,
                ),
                 OnGoingTask(),
                 SizedBox(
                  height: 30,
                ),
                 OnGoingTask(),
                 SizedBox(
                  height: 30,
                ),

                
              ],
            ),
          ),
        ),
        news(),
      ],
    );
  }


}


