import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hawli/widgets/news.dart';
import 'package:hawli/widgets/posination.dart';
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

  SafeArea _buildBody() {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                
                const Posination(),
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
                        
                      ],
                    ),
                  ),
                ),
                news(),
                
                
              ],
            )));
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
            icon: Icons.card_travel,
            
            taskGroup: "الطلبات الجديدة",
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
            
            taskGroup: "الطلبات المنتهية",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: TaskGroupContainer(
            selectedpage: 3,
            color: Colors.green,
            icon: Icons.person,
            
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
            icon: Icons.money,
            
            taskGroup: "تسديد دفعة",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: TaskGroupContainer(
            selectedpage: 1,
            color: Colors.cyan,
            icon: Icons.card_travel,
            
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
            
            isSmall: true,
            taskGroup: " مستخدم جديد",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: TaskGroupContainer(
            selectedpage: 1,
            color: Colors.purple,
            icon: Icons.newspaper,
            
            taskGroup: "الشريط الأخباري",
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
            icon: Icons.store_mall_directory_outlined,
            
            taskGroup: " ايداعات",
          ),
        ),
        
      ],
    );
  }
}




