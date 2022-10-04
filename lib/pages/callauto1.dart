import 'package:flutter/material.dart';

import 'package:hover_ussd/hover_ussd.dart';

class favorityPage extends StatefulWidget {
  @override
  _favorityPageState createState() => _favorityPageState();
}

class _favorityPageState extends State<favorityPage> {
  final HoverUssd _hoverUssd = HoverUssd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Row(
          children: [
            FlatButton(
              onPressed: () {
                _hoverUssd
                    .sendUssd(actionId: "368461a5", extras: {"PhoneNumber": "*999*3*1*1*2*2#"  });
              },
              child: Text("Start Trasaction"),
            ),
            StreamBuilder(
              stream: _hoverUssd.getUssdTransactionState,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == TransactionState.succesfull) {
                  return Text("succesfull");
                } else if (snapshot.data ==
                    TransactionState.actionDowaloadFailed) {
                  return Text("action download failed");
                } else if (snapshot.data == TransactionState.failed) {
                  return Text("failed");
                }
                return Text("no transaction");
              },
            ),
          ],
        ),
      ),
    );
  }
}
