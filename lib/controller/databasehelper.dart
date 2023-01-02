import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class DatabaseHelper {
  String serverUrl = "https://abilibackend.herokuapp.com";
  // ignore: prefer_typing_uninitialized_variables
  late bool status;
  var time = false;
  List Users = [];
  String ResponseRegistrer = "";

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
        time = true;

        return Future.error('error');
      },
    );

    status = response.body.contains('error');
    time = false;

    var data = json.decode(response.body);

    if (data["data"] != null) {
      _saveUser('${data["data"]["user"]["name"]}',
          '${data["data"]["user"]["phone"]}', '${data["data"]["token"]}');
    }
  }

  Future acceptOrder(String id) async {
    String url = "$serverUrl/distributor/accept-order";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "order_id": id,
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        status = false;
        time = true;

        return Future.error('error');
      },
    );
    var data = json.decode(response.body);

    status = data["status"];

    print(status);
    time = false;

    print(data);
  }

  Future addNews(String title) async {
    String url = "$serverUrl/distributor/news";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "title": title,
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        status = false;
        time = true;

        return Future.error('error');
      },
    );
    var data = json.decode(response.body);

    status = data["status"];

    print(status);
    time = false;

    print(data);
  }

  Future rejectOrder(String id, String rejectreason) async {
    String url = "$serverUrl/distributor/reject-order";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "order_id": id,
      "reject_reason": rejectreason,
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        status = false;
        time = true;

        return Future.error('error');
      },
    );
    var data = json.decode(response.body);

    status = data["status"];

    print(status);
    time = false;

    print(data);
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

  _saveUser(String name, String phone, String token) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'name';
    final value = name;
    const key1 = 'phone';
    final value1 = phone;
    const key2 = 'token';
    final value2 = token;
    prefs.setString(key2, value2);
    prefs.setString(key, value);
    prefs.setString(key1, value1);

    print(prefs.getString(key));
    print(prefs.getString(key1));
    print(prefs.getString(key2));
  }

  Future RegisterUser(String phone, String password, String name,
      String balance, String address, String ratio, String min_Balance) async {
    String url = "$serverUrl/distributor/user-register";
    final prefs = await SharedPreferences.getInstance();
    const Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": name,
      "phone": phone,
      "balance": balance,
      "address": address,
      "ratio": ratio,
      "min_balance": min_Balance,
      "password": password,
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        status = false;
        time = true;

        return Future.error('error');
      },
    );
    print(response.body);

    status = response.body.contains('success');
    ResponseRegistrer = jsonDecode(response.body);

    time = false;
  }

  Future EditUser(
      String name, String id, String ratio, String min_Balance) async {
    print(id);
    String url = "$serverUrl/distributor/edit-user";
    final prefs = await SharedPreferences.getInstance();
    const Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": name,
      "user_id": id,
      "ratio": ratio,
      "min_balance": min_Balance,
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        status = false;
        time = true;

        return Future.error('error');
      },
    );

    status = response.body.contains('success');

    time = false;
  }

  Future payment(String id, String balance) async {
    String url = "$serverUrl/distributor/payments";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "distributor_user_id": id,
      "value": balance,
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        status = false;
        time = true;

        return Future.error('error');
      },
    );

    status = response.body.contains('success');
    var data = json.decode(response.body);

    print(data);
    time = false;

    print(data);
  }

  Future addDeposit(String id, String value1, String desc) async {
    String url = "$serverUrl/distributor/deposits";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "user_id": id,
      "value": value1,
      "description": desc,
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        status = false;
        time = true;

        return Future.error('error');
      },
    );

    status = response.body.contains('success');
    var data = json.decode(response.body);

    print(data);
    time = false;

    print(data);
  }

  Future changePassword(
      String newPassword, String oldPassword, String confPassword) async {
    String url = "$serverUrl/distributor/change-password";
    final prefs = await SharedPreferences.getInstance();
    final Key = 'token';
    final value = prefs.get(Key);

    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "old_password": oldPassword,
      "new_password": newPassword,
      "new_password_confirmation": confPassword,
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        status = false;
        time = true;

        return Future.error('error');
      },
    );

    status = response.body.contains('successfully');
    print(status);
    var data = json.decode(response.body);

    print(data["message"]);
    time = false;

    print(data);
  }
}
