import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkCheck {
  final String url;
  final Map<String, String> user;
  NetworkCheck(this.url, this.user);

  Future<bool> fetchData() async {
    debugPrint("$url\n ${json.encode(user)}");
    Response response = await post(Uri.parse(url), body: user);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      var responseJson = json.decode(response.body);
      if (responseJson['status'] == 1) {
        debugPrint("Correcto");
        return true;
      } else {
        return false;
      }
    } else {
      debugPrint("Error: ${response.statusCode}");
    }
    return false;
  }
}
