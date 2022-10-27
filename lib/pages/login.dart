import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawli/controller/databasehelper.dart';
import 'package:hawli/widgets/posination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
 
  DatabaseHelper databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String _mobile = '';
  String _password = '';
  bool isLoading = false;

  void onPressedSubmit() {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      databaseHelper.loginDistributor(_mobile, _password).whenComplete(() {
        if (databaseHelper.status) {
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
                bottom: MediaQuery.of(context).size.height - 100,
                right: 20,
                left: 20),
          ));
            
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'رقم الموبايل أو كلمة السر غير صحيحين',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 100,
                right: 20,
                left: 20),
          ));
          }

          

          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Check phone or password')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
                content: const Text('أهلا و سهلا بك ',
                textAlign: TextAlign.center,),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 100,
                    right: 20,
                    left: 20),
              ))
              .closed
              .then(
                  (value) => Navigator.pushReplacementNamed(context, '/home'));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              const Posination(),

              //card and footer ui
              Positioned(
                bottom: 20.0,
                child: Column(
                  children: <Widget>[
                    buildCard(size),
                    buildFooter(size),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Form(
      key: _formKey,
      child: Container(
        alignment: Alignment.center,
        width: size.width * 0.9,
        height: size.height * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo & text
            logo(size.height / 8, size.height / 8),
            SizedBox(
              height: size.height * 0.03,
            ),
            richText(24),
            SizedBox(
              height: size.height * 0.05,
            ),

            //phone & password TextFormField
            phoneTextFormField(size),
            SizedBox(
              height: size.height * 0.02,
            ),
            passwordTextFormField(size),

            //remember & forget text

            SizedBox(
              height: size.height * 0.04,
            ),

            //sign in button
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : signInButton(size),
          ],
        ),
      ),
    );
  }

  Widget buildFooter(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.08,
        ),
        Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: Colors.white,
            ),
            children: const [
              TextSpan(
                text: 'جميع الحقوق محفوظة لتطبيق حولي',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget logo(double height_, double width_) {
    return SvgPicture.asset(
      'assets/logo.svg',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Color.fromARGB(255, 55, 111, 138),
        ),
        children: const [
          TextSpan(
            text: ' تسجيل',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: ' دخول ',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneTextFormField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: phoneController,
            style: GoogleFonts.inter(
              fontSize: 18.0,
              color: const Color(0xFF151624),
            ),
            maxLines: 1,
            keyboardType: TextInputType.phone,
            cursorColor: const Color(0xFF151624),
            decoration: InputDecoration(
              hintText: ' رقم الموبايل',
              hintStyle: GoogleFonts.inter(
                fontSize: 16.0,
                color: const Color(0xFF151624).withOpacity(0.5),
              ),
              filled: true,
              fillColor: phoneController.text.isEmpty
                  ? const Color.fromRGBO(248, 247, 251, 1)
                  : Colors.transparent,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(
                    color: phoneController.text.isEmpty
                        ? Colors.transparent
                        : const Color.fromRGBO(44, 185, 176, 1),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(44, 185, 176, 1),
                  )),
              prefixIcon: Icon(
                Icons.phone_android_rounded,
                color: phoneController.text.isEmpty
                    ? const Color(0xFF151624).withOpacity(0.5)
                    : const Color.fromRGBO(44, 185, 176, 1),
                size: 16,
              ),
              suffix: Container(
                alignment: Alignment.center,
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: const Color.fromRGBO(44, 185, 176, 1),
                ),
                child: phoneController.text.isEmpty
                    ? const Center()
                    : const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 13,
                      ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                setState(() {
                  isLoading = false;
                });
                return 'أدخل رقم الموبايل';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              setState(() {
                _mobile = value.toString();
              });
            },
          ),
        ),
      ),
    );
  }

  Widget passwordTextFormField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
              controller: passController,
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: const Color(0xFF151624),
              ),
              cursorColor: const Color(0xFF151624),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: ' كلمة السر',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: const Color(0xFF151624).withOpacity(0.5),
                ),
                filled: true,
                fillColor: passController.text.isEmpty
                    ? const Color.fromRGBO(248, 247, 251, 1)
                    : Colors.transparent,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: passController.text.isEmpty
                          ? Colors.transparent
                          : const Color.fromRGBO(44, 185, 176, 1),
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(44, 185, 176, 1),
                    )),
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: passController.text.isEmpty
                      ? const Color(0xFF151624).withOpacity(0.5)
                      : const Color.fromRGBO(44, 185, 176, 1),
                  size: 16,
                ),
                suffix: Container(
                  alignment: Alignment.center,
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: const Color.fromRGBO(44, 185, 176, 1),
                  ),
                  child: passController.text.isEmpty
                      ? const Center()
                      : const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 13,
                        ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  setState(() {
                    isLoading = false;
                  });
                  return 'أدخل كلمة السر';
                } else if (value.length < 8) {
                  setState(() {
                    isLoading = false;
                  });
                  return 'كلمة السر يجب أن تكون أطول من 8 محارف';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                setState(() {
                  _password = value.toString();
                });
              }),
        ),
      ),
    );
  }

  Widget signInButton(Size size) {
    return GestureDetector(
      onTap: onPressedSubmit,
      child: Container(
        alignment: Alignment.center,
        height: size.height / 13,
        width: size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: const Color(0xFF21899C),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: Text(
          'تسجيل دخول',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
