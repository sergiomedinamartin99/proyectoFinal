import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkCheck {
  final String url;
  final Map<String, dynamic> mapa;
  NetworkCheck(this.url, this.mapa);

  Future<Map<String, dynamic>?> fetchData() async {
    debugPrint(url);
    debugPrint("$mapa");
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      debugPrint("Response: $responseData");
      return responseData;
    } else {
      debugPrint("Error: ${response.statusCode}");
      return null;
    }
  }
}
