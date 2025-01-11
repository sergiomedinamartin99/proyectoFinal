import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkInsertData {
  final String url;
  final Map<String, dynamic> mapa;
  NetworkInsertData(this.url, this.mapa);

  Future<Map<String, dynamic>?> fetchData() async {
    debugPrint(url);
    debugPrint("$mapa");
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      print("ENTRALOOOOOOOOOOOO");
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } else {
      print("ERRORAZOOOOOOOOOO");
      debugPrint("Error: ${response.statusCode}");
      return null;
    }
  }
}
