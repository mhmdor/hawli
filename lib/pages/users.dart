import 'package:flutter/material.dart';
import 'package:hawli/pages/entrustingUser.dart';
import 'package:hawli/widgets/news.dart';

// import 'package:sizer/sizer.dart';

class User {
  String name;
  int age;
  String role;
  String role1;
  String role2;
  String role3;

  User(
      {required this.name,
      required this.age,
      required this.role,
      required this.role3,
      required this.role1,
      required this.role2});
}

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Users> {
  int? sortColumnIndex;
  bool isAscending = false;
  List<User> users = [
    User(
        name: "Sarah Sarah Sarah",
        age: 19,
        role: "Student",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "Janine",
        age: 43,
        role: "Professor",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "Sarhah",
        age: 59,
        role: "hh",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "wesaam",
        age: 23,
        role: "gg",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "wesaam",
        age: 20,
        role: "gg",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "wesaam",
        age: 17,
        role: "gg",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "wesaam",
        age: 17,
        role: "gg",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "wesaam",
        age: 17,
        role: "gg",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "wesaam",
        age: 18,
        role: "gg",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "wesaam",
        age: 79,
        role: "gg",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
    User(
        name: "wesaam",
        age: 12,
        role: "gg",
        role1: "Student",
        role2: "Student",
        role3: "Student"),
  ];

  List<User> usersFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  @override
  void initState() {
    super.initState();
    usersFiltered = users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[800],
        extendBody: true,
        body: _buildBody());
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
           news(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Card(
                color: const Color.fromARGB(255, 247, 246, 246),
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          _searchResult = value;
                          usersFiltered = users
                              .where((user) =>
                                  user.name.contains(_searchResult) ||
                                  user.role.contains(_searchResult) ||
                                  user.age.toString().contains(_searchResult))
                              .toList();
                        });
                      }),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                        _searchResult = '';
                        usersFiltered = users;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: const Color.fromARGB(255, 42, 41, 41),
                            ),
                          ),
                          child: DataTable(
                            sortAscending: isAscending,
                            sortColumnIndex: sortColumnIndex,
                            border: TableBorder.symmetric(
                              inside: const BorderSide(width: 1.5),
                            ),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blueGrey),
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    const Color.fromARGB(255, 247, 246, 246)),
                            columns: <DataColumn>[
                              DataColumn(
                                label: const Text(
                                  'الاسم',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                onSort: onSort,
                              ),
                              DataColumn(
                                label: const Text(
                                  'رصيد',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                onSort: onSort,
                              ),
                              DataColumn(
                                label: const Text(
                                  'عمليات',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                onSort: onSort,
                              ),
                              DataColumn(
                                label: const Text(
                                  'اضافي',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                onSort: onSort,
                              ),
                              DataColumn(
                                label: const Text(
                                  'اضافي',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                onSort: onSort,
                              ),
                              DataColumn(
                                label: const Text(
                                  'اضافي',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                onSort: onSort,
                              ),
                              DataColumn(
                                label: const Text(
                                  'Role3',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                onSort: onSort,
                              ),
                            ],
                            rows: List.generate(
                              usersFiltered.length,
                              (index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    usersFiltered[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  DataCell(Text(
                                    usersFiltered[index].age.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  DataCell(
                                    ElevatedButton(
                                      child: const Text('عمليات التحويل'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,MaterialPageRoute(builder: (context) => const EntrustingUser())
                                        );

                                        
                                      },
                                    ),
                                  ),
                                  DataCell(Text(
                                    usersFiltered[index].role,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  DataCell(Text(
                                    usersFiltered[index].role1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  DataCell(Text(
                                    usersFiltered[index].role2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  DataCell(Text(
                                    usersFiltered[index].role3,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      users.sort(
          (user1, user2) => compareString(ascending, user1.name, user2.name));
    } else if (columnIndex == 1) {
      users.sort((user1, user2) =>
          compareString(ascending, '${user1.age}', '${user2.age}'));
    } else if (columnIndex == 2) {
      users.sort(
          (user1, user2) => compareString(ascending, user1.role, user2.role));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
