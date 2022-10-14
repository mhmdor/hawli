import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';


class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool _isLoading = true;
  SimData? _simData;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SimData simData;
    try {
      var status = await Permission.phone.status;
      if (!status.isGranted) {
        bool isGranted = await Permission.phone.request().isGranted;
        if (!isGranted) return;
      }
      simData = await SimDataPlugin.getSimData();
      setState(() {
        _isLoading = false;
        _simData = simData;
      });
      void printSimCardsData() async {
        try {
          SimData simData = await SimDataPlugin.getSimData();
          for (var s in simData.cards) {
            // ignore: avoid_print
            print('Serial number: ${s.serialNumber}');
          }
        } on PlatformException catch (e) {
          debugPrint("error! code: ${e.code} - message: ${e.message}");
        }
      }

      printSimCardsData();
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
        _simData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cards = _simData?.cards;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Sim data demo')),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: cards != null
                    ? cards.isEmpty
                        ? [const Text('No sim card present')]
                        : cards
                            .map(
                              (SimCard card) => ListTile(
                                leading: const Icon(Icons.sim_card),
                                title: Text('Card ${card.slotIndex}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('carrierName: ${card.carrierName}'),
                                    Text('countryCode: ${card.countryCode}'),
                                    Text('displayName: ${card.displayName}'),
                                    Text(
                                        'isDataRoaming: ${card.isDataRoaming}'),
                                    Text(
                                        'isNetworkRoaming: ${card.isNetworkRoaming}'),
                                    Text('mcc: ${card.mcc}'),
                                    Text('mnc: ${card.mnc}'),
                                    Text('slotIndex: ${card.slotIndex}'),
                                    Text('serialNumber: ${card.serialNumber}'),
                                    Text(
                                        'subscriptionId: ${card.subscriptionId}'),
                                  ],
                                ),
                              ),
                            )
                            .toList()
                    : [
                        Center(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Failed to load data'),
                        )
                      ],
              ),
            )
          ],
        ),
      ),
    );
  }
}






















// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sim_data/sim_data.dart';
// import 'package:ussd_service/ussd_service.dart';
// import 'package:flutter/material.dart';

// class Favorite extends StatefulWidget {
//   const Favorite({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _FavoriteState createState() => _FavoriteState();
// }

// enum RequestState {
//   ongoing,
//   success,
//   error,
// }

// class _FavoriteState extends State<Favorite> {

//   RequestState? _requestState;
//   String _requestCode = "*100#";
//   String _responseCode = "";
//   String _responseMessage = "";

 

//   Future<void> sendUssdRequest() async {
//     setState(() {
//       _requestState = RequestState.ongoing;
//     });
//     try {
//       String responseMessage;
//       await Permission.phone.request();
//       if (!await Permission.phone.isGranted) {
//         throw Exception("permission missing");
//       }

     
//       var sim;
//       try {
//         SimData simData = await SimDataPlugin.getSimData();
//         for (var s in simData.cards) {
          
//           if (s.slotIndex == 0) {
//             sim = s;
//           }
//         }
//       } on PlatformException catch (e) {
//         debugPrint("error! code: ${e.code} - message: ${e.message}");
//       }

//       responseMessage =
//           await UssdService.makeRequest(sim.subscriptionId, _requestCode);
//       setState(() {
//         _requestState = RequestState.success;
//         _responseMessage = responseMessage;
//       });
//     } on PlatformException catch (e) {
//       setState(() {
//         _requestState = RequestState.error;
//         // ignore: unnecessary_type_check
//         _responseCode = e is PlatformException ? e.code : "";
//         _responseMessage = e.message ?? '';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
  
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Sim data demo')),
//         body: Column(
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[
//                     // TextFormField(
//                     //   decoration: const InputDecoration(
//                     //     labelText: 'Enter Code',
//                     //   ),
//                     //   onChanged: (newValue) {
//                     //     setState(() {
//                     //       _requestCode = newValue;
//                     //     });
//                     //   },
//                     // ),
//                     const SizedBox(height: 20),
//                     MaterialButton(
//                       color: Colors.blue,
//                       textColor: Colors.white,
//                       onPressed: _requestState == RequestState.ongoing
//                           ? null
//                           : () {
//                               sendUssdRequest();
//                             },
//                       child: const Text('Send Ussd request'),
//                     ),
//                     const SizedBox(height: 20),
//                     if (_requestState == RequestState.ongoing)
//                       Row(
//                         children: const <Widget>[
//                           SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(),
//                           ),
//                           SizedBox(width: 24),
//                           Text('Ongoing request...'),
//                         ],
//                       ),
//                     if (_requestState == RequestState.success) ...[
//                       const Text('Last request was successful.'),
//                       const SizedBox(height: 10),
//                       const Text('Response was:'),
//                       Text(
//                         _responseMessage,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                     if (_requestState == RequestState.error) ...[
//                       const Text('Last request was not successful'),
//                       const SizedBox(height: 10),
//                       const Text('Error code was:'),
//                       Text(
//                         _responseCode,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text('Error message was:'),
//                       Text(
//                         _responseMessage,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ]
//                   ]),
//             ),

//             // Padding(
//             //   padding: const EdgeInsets.all(20.0),
//             //   child: Column(
//             //     children: cards != null
//             //         ? cards.isEmpty
//             //             ? [const Text('No sim card present')]
//             //             : cards
//             //                 .map(
//             //                   (SimCard card) => ListTile(
//             //                     leading: const Icon(Icons.sim_card),
//             //                     title: Text('Card ${card.slotIndex}'),
//             //                     subtitle: Column(
//             //                       crossAxisAlignment: CrossAxisAlignment.start,
//             //                       children: <Widget>[
//             //                         Text('displayName: ${card.displayName}'),
//             //                         Text('slotIndex: ${card.slotIndex}'),
//             //                         Text(
//             //                             'subscriptionId: ${card.subscriptionId}'),
//             //                       ],
//             //                     ),
//             //                   ),
//             //                 )
//             //                 .toList()
//             //         : [
//             //             Center(
//             //               child: _isLoading
//             //                   ? const CircularProgressIndicator()
//             //                   : const Text('Failed to load data'),
//             //             )
//             //           ],
//             //   ),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }

// _makeMyRequest() async {
//   int subscriptionId = 2; // sim card subscription Id
//   String code = "*100#"; // ussd code payload
//   try {
//     String ussdSuccessMessage =
//         await UssdService.makeRequest(subscriptionId, code);

//     print("succes! message: $ussdSuccessMessage");
//   } on PlatformException catch (e) {
//     print("error! code: ${e.code} - message: ${e.message}");
//   }
// }

// _printSimCardsData() async {
//   try {
//     SimData simData = await SimDataPlugin.getSimData();
//     for (var s in simData.cards) {
//       print('subscriptionId: ${s.subscriptionId}');
//       print('countryCode: ${s.countryCode}');
//       print('displayName: ${s.displayName}');
//     }
//   } on PlatformException catch (e) {
//     debugPrint("error! code: ${e.code} - message: ${e.message}");
//   }
// }
