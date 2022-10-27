import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class DatabaseHelper {
  String serverUrl = "https://abilibackend.herokuapp.com";
  // ignore: prefer_typing_uninitialized_variables
  var status;
  var time = false;

  Future loginDistributor(String phone, String password) async {
    String url = "$serverUrl/distributor/login";
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json'
    }, body: {
      "phone": phone,
      "password": password,
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        status = true;
        time ;

        return Future.error('error');
      },
    );

    status = response.body.contains('error');
    time = false;

    var data = json.decode(response.body);

    if (data["data"] != null) {
      _saveToken('${data["data"]["token"]}');
    }
  }

  logout() async {
    String url = "$serverUrl/distributor/logout";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );
    status = json.decode(response.body)["message"];
    print(status);
    _saveToken('0');
  }

  _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = token;
    prefs.setString(key, value);
  }
}
