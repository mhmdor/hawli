import 'package:flutter/material.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
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
      backgroundColor: const Color.fromARGB(255, 204, 228, 248),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: const Color.fromARGB(255, 3, 14, 50),
        toolbarHeight: 60,
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: const SignUpForm()),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();
  DatabaseHelper databaseHelper = DatabaseHelper();

  String _name = '';
  String _mobile = '';
  String _Address = '';
  String _balance = '0';
  String _ratio = '0';
  String _minBalance = '';
  String _password = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // loadGenderList();
    // Build a Form widget using the _formKey we created above
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SingleChildScrollView(
              child: Column(
                children: getFormWidget(),
              ),
            ),
          ),
        ),
      ),
    );
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
          '???????? ????????',
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
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelText: '???????? ?????? ????????????',

          hintText: '??????????'),
      validator: (value) {
        if (value!.isEmpty) {
          return '?????????? ??????????';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _name = value.toString();
        });
      },
    ));
    formWidget.add(const SizedBox(
      height: 10,
    ));

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelText: '???????? ?????????? ????????????',
          hintText: '??????????????'),
      validator: (value) {
        if (value!.isEmpty) {
          return '?????????????? ??????????';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _Address = value.toString();
        });
      },
    ));
    formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelText: '???????? ?????? ????????????????',
          hintText: '????????????????'),
      keyboardType: TextInputType.phone,
      validator: ((value) {
        if (value!.isEmpty) {
          return '???????????????? ??????????';
        } else {
          return null;
        }
      }),
      onSaved: (value) {
        setState(() {
          _mobile = value.toString();
        });
      },
    ));
    formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          hintText: '????????????',
          labelText: '???????? ???????????? '),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return '???????????? ?????????? ';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _balance = value.toString();
        });
      },
    ));
    formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          hintText: '??????????????',
          labelText: '???????? ?????????????? '),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return '?????????????? ???????????? ';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _ratio = value.toString();
        });
      },
    ));
    formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          hintText: '?????? ???????? ????????????',
          labelText: ' ???????? ???????? ???????????? ???????????? ???????????????? '),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return '???????? ???????????? ?????????? ';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _minBalance = value.toString();
        });
      },
    ));
    formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(
      TextFormField(
          key: _passKey,
          obscureText: true,
          decoration: const InputDecoration(
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              hintText: '???????? ????????',
              labelText: '???????? ???????? ????????'),
          validator: (value) {
            if (value!.isEmpty) {
              return '???????? ???????? ????????????';
            } else if (value.length < 8) {
              return '???????? ???????? ?????? ???? ???????? ?????? ?????????? 8 ??????????';
            } else {
              return null;
            }
          }),
    );
    formWidget.add(const SizedBox(
      height: 8,
    ));

    formWidget.add(
      TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              hintText: '?????????? ???????? ????????',
              labelText: '???????? ???????? ???????? ?????? ????????'),
          validator: (confirmPassword) {
            if (confirmPassword != null && confirmPassword.isEmpty) {
              return '?????????? ???????? ???????? ??????????';
            }
            var password = _passKey.currentState?.value;
            if (confirmPassword != null &&
                confirmPassword.compareTo(password) != 0) {
              return '???????? ???????? ?????? ????????????';
            } else {
              return null;
            }
          },
          onSaved: (value) {
            setState(() {
              _password = value.toString();
            });
          }),
    );
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


        databaseHelper.RegisterUser(_mobile, _password, _name, _balance,
                _Address, _ratio, _minBalance)
            .whenComplete(() {
          if (!databaseHelper.status) {
            setState(() {
              isLoading = false;
            });
            if (databaseHelper.time) {
              
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  '?????? ???????????????? ???????????????? ???????? ???????????????? ??????????',
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
                    '???? ?????????? ???????????? ??????????',
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
                  '?????????? ????????????',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, height: 2),
                )),
          ));

          formWidget.add(const SizedBox(
            height: 10,
          ));

    return formWidget;
  }
}




// formWidget.add(DropdownButton(
    //   hint: const Text('Select Gender'),
    //   items: genderList,
    //   value: _selectedGender,
    //   onChanged: (value) {
    //     setState(() {
    //       _selectedGender = int.parse(value.toString());
    //     });
    //   },
    //   isExpanded: true,
    // ));

    // formWidget.add(Column(
    //   children: <Widget>[
    //     RadioListTile<String>(
    //       title: const Text('Single'),
    //       value: 'single',
    //       groupValue: _maritalStatus,
    //       onChanged: (value) {
    //         setState(() {
    //           _maritalStatus = value.toString();
    //         });
    //       },
    //     ),
    //     RadioListTile<String>(
    //       title: const Text('Married'),
    //       value: 'married',
    //       groupValue: _maritalStatus,
    //       onChanged: (value) {
    //         setState(() {
    //           _maritalStatus = value.toString();
    //         });
    //       },
    //     ),
    //   ],
    // ));



    // List<DropdownMenuItem<int>> genderList = [];

  // void loadGenderList() {
  //   genderList = [];
  //   genderList.add(const DropdownMenuItem(
  //     value: 0,
  //     child: Text('Male'),
  //   ));
  //   genderList.add(const DropdownMenuItem(
  //     value: 1,
  //     child: Text('Female'),
  //   ));
  //   genderList.add(const DropdownMenuItem(
  //     value: 2,
  //     child: Text('Others'),
  //   ));
  // }
