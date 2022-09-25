import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hawli/widgets/news.dart';
import 'package:hawli/widgets/task_group.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              children: [
                const SizedBox(
                  height: 30,
                ),
                buildGrid(),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
       news(),
      ],
    );
  }

  StaggeredGrid buildGrid() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: const [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: TaskGroupContainer(
            selectedpage: 1,
            color: Colors.red,
            icon: Icons.shopping_cart,
            taskCount: 45,
            taskGroup: "الطلبات",
          ),
        ),
        StaggeredGridTile.count(
          
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TaskGroupContainer(
            selectedpage: 4,
            color: Colors.blue,
            isSmall: true,
            icon: Icons.auto_stories,
            taskCount: 5,
            taskGroup: "ايداعات",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: TaskGroupContainer(
            selectedpage: 3,
            color: Colors.green,
            icon: Icons.person,
            taskCount: 2,
            taskGroup: "المستخدمين",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TaskGroupContainer(
            selectedpage: 0,
            color: Colors.brown,
            isSmall: true,
            icon: Icons.article_rounded,
            taskCount: 9,
            taskGroup: "الاحصائيات",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TaskGroupContainer(
            status: true,
            selectedpage: 2,
            color: Colors.pink,
            icon: Icons.person_add,
            taskCount: 2,
             isSmall: true,
            taskGroup: " مستخدم جديد",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TaskGroupContainer(
            status: true,
            selectedpage: 2,
            color: Colors.orange,
            isSmall: true,
            icon: Icons.money_rounded,
            taskCount: 9,
            taskGroup: "تسديد فواتير",
          ),
        ),
      ],
    );
  }

 
}
