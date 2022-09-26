import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class favorityPage extends StatefulWidget {
 
  const favorityPage({Key? key}) : super(key: key);

  

  @override
  _favorityPageState createState() => _favorityPageState();
}

class _favorityPageState extends State<favorityPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  static const _hover = const MethodChannel('kikoba.co.tz/hover');
  String _ActionResponse = 'Waiting for Response...';
  Future<dynamic> sendMoney(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'phoneNumber': "phoneNumber",
      'amount': amount,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result = await _hover.invokeMethod('sendMoney', sendMap);
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    _ActionResponse = response;
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildNumberTextField() {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            controller: phoneNumberController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phone Number',
      
              suffixIcon: Icon(Icons.dialpad),
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ));
    }

    Widget _buildAmountTextField() {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: TextFormField(
            controller: amountController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter amount';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
         
              labelText: 'Amount',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ));
    }

    Widget _buildTuma() {
      return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildNumberTextField(),
              _buildAmountTextField(),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendMoney(
                        phoneNumberController.text, amountController.text);
                  }
                },
                child: Text("send Money"),
              ),
              Text(_ActionResponse),
            ],
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("xx"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTuma(),
          ],
        ),
      ),
    );
  }
}
