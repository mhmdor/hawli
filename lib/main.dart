import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:hawli/NavBar.dart';
import 'package:hawli/pages/finishedOrders.dart';
import 'package:hawli/pages/home.dart';
import 'package:hawli/pages/orders.dart';
import 'package:hawli/pages/payment.dart';
import 'package:hawli/pages/splashscreen.dart';
import 'package:hawli/pages/users.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void  main() async {

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: <String,WidgetBuilder>{
        '/home' :(context) => (const MyHomePage(selectedpage: 2))
      }
      // home: const MyHomePage(selectedpage: 2),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int selectedpage;
  const MyHomePage({
    Key? key,
    required this.selectedpage,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() =>
      // ignore: no_logic_in_create_state
      _MyHomePageState(selectedpage: selectedpage);
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedpage = 2;

  final _pageNo = [
     Payment(),
    const Orders(),
    const Home(),
    const Users(),
    const finishedOrders(),
  ];
  _MyHomePageState({
    required this.selectedpage,
  });
  var name = '';
  

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      
      
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
       drawer:  NavBar(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: const Color.fromARGB(255, 48, 53, 69),
        toolbarHeight: 60,
        title:  Text(
         name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          padding: EdgeInsets.only(bottom: 12, top: 12),
          content: Text('أضغط مجددا للخروج'),
        ),
        child: _pageNo[selectedpage],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.blue,
        height: 70,
        curveSize: 120,
        items: const [
          TabItem(icon: Icons.article_rounded, title: 'تسديد'),
          TabItem(icon: Icons.shopping_cart, title: 'الطلبات '),
          TabItem(icon: Icons.home, title: 'الرئيسية'),
          TabItem(icon: Icons.person, title: 'المستخدمين'),
          TabItem(icon: Icons.auto_stories, title: 'المنتهية'),
        ],
        initialActiveIndex: selectedpage,
        onTap: (int index) {
          setState(() {
            selectedpage = index;
          });
        },
      ),
    );
  }
}


// child: ElevatedButton(
        //   onPressed: () {
        //     showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             content: Stack(
        //               children: <Widget>[
        //                 Positioned(
        //                   right: -40.0,
        //                   top: -40.0,
        //                   child: InkResponse(
        //                     onTap: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                     child: const CircleAvatar(
        //                       child: Icon(Icons.close),
        //                       backgroundColor: Colors.red,
        //                     ),
        //                   ),
        //                 ),
        //                 Form(
        //                   key: _formKey,
        //                   child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: <Widget>[
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: TextFormField(),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: TextFormField(),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: ElevatedButton(
        //                           child: Text("Submitß"),
        //                           onPressed: () {
        //                             if (_formKey.currentState!.validate()) {
        //                               _formKey.currentState!.save();
        //                             }
        //                           },
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           );
        //         });
        //   },
        //   child: Text("Open Popup"),
        // ),