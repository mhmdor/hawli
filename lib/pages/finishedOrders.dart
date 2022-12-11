import 'package:flutter/material.dart';
import 'package:hawli/pages/orders/acceptedOrders.dart';
import 'orders/rejectedOrders.dart';



class finishedOrders extends StatelessWidget {
  const finishedOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[800],
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 252, 253, 253),
          toolbarHeight: 80,
          title:  const Padding(
            padding:  EdgeInsets.only(top: 0),
            child:  TabBar(
             indicatorColor: Color.fromARGB(255, 47, 52, 54),
              tabs: [

                
                
                Tab(
                  icon: Icon(Icons.task_alt,
                  size: 40,
                  color: Color.fromARGB(255, 6, 201, 12),),
                ),
                
                Tab(
                  icon: Icon(Icons.cancel_sharp,
                  size: 40,
                  color: Color.fromARGB(255, 177, 29, 18),),
                )
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
          
            AcceptedOrders(),
            RejectedOrders(),
            
          ],
        ),
      ),
    );

   
  }
}

