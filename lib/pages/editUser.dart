import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUser extends StatefulWidget {
  final String name;

  final String minBalance;
  final String id;
  final String ratio;
  final String address;

  const EditUser(
      {Key? key,
      required this.name,
      required this.minBalance,
      required this.id,
      required this.ratio, required this.address})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _EditUserState createState() => _EditUserState(name, minBalance, id, ratio,address);
}

class _EditUserState extends State<EditUser> {
  var name1 = '';
  final String name;
final String address;
  final String minBalance;
  final String id;
  final String ratio;

  _EditUserState(this.name, this.minBalance, this.id, this.ratio, this.address);

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name1 = prefs.getString('name')!;
    });
  }

  final _formKey = GlobalKey<FormState>();

  DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _ratio = TextEditingController();
  final TextEditingController _minBalance = TextEditingController();
  final TextEditingController _address = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUser();
    _name.value = TextEditingValue(text: name);
    _ratio.value = TextEditingValue(text: ratio);
    _address.value = TextEditingValue(text: address);
    _minBalance.value = TextEditingValue(text: minBalance);
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];
    formWidget.add(Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.blue),
          borderRadius: BorderRadius.circular(10)),
      child: const Center(
        child: Text(
          'تعديل العميل',
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 4, 13, 34),
          ),
        ),
      ),
    ));
    formWidget.add(TextFormField(
      controller: _name,
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelText: ' أسم العميل',
          hintText: 'الأسم'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'الأسم مطلوب';
        } else {
          return null;
        }
      },
    ));

    formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(TextFormField(
      controller: _ratio,
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          hintText: 'العمولة',
          labelText: ' العمولة '),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'العمولة مطلوبة ';
        } else {
          return null;
        }
      },
    ));
    formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(TextFormField(
      controller: _minBalance,
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          hintText: 'الحد الأدنى  للدخول',
          labelText: '  الحد الأدنى '),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'الحد الأدنى مطلوب ';
        } else {
          return null;
        }
      },
    ));

     formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(TextFormField(
      controller: _address,
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          hintText: 'العنوان',
          labelText: '  العنوان '),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'العنوان مطلوب ';
        } else {
          return null;
        }
      },
    ));
    

    formWidget.add(const SizedBox(
      height: 50,
    ));

    void onPressedSubmit() {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        _formKey.currentState?.save();
        FocusManager.instance.primaryFocus?.unfocus();

        databaseHelper.EditUser(_name.text, id, _ratio.text, _minBalance.text)
            .whenComplete(() {
          if (!databaseHelper.status) {
            setState(() {
              isLoading = false;
            });
            if (databaseHelper.time) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'خطأ بالأتصال بالسيرفر يرجى المحاولة لاحقا',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 160,
                    right: 40,
                    left: 40),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  databaseHelper.ResponseRegistrer.toString(),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 160,
                    right: 40,
                    left: 40),
              ));
            }

            // ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text('Check phone or password')));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                  content: const Text(
                    'تم تعديل العميل بنجاح',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 160,
                      right: 40,
                      left: 40),
                ))
                .closed
                .then((value) =>
                    Navigator.pushReplacementNamed(context, '/home'));
          }
        });
      }
    }

    formWidget.add(isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
                onPressed: onPressedSubmit,
                child: const Text(
                  'تعديل العميل',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, height: 2),
                )),
          ));

    return formWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 228, 248),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: const Color.fromARGB(255, 48, 53, 69),
        toolbarHeight: 60,
        title: Text(
          name1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Card(
              elevation: 5,
              color: const Color.fromARGB(255, 237, 241, 243),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListView(
                      children: getFormWidget(),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
