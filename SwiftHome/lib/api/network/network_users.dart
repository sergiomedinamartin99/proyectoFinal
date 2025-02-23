import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkUserProfile {
  final String url;
  NetworkUserProfile(this.url);

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    debugPrint(url);
    Response response = await post(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      debugPrint("Error: ${response.statusCode}");
      return null;
    }
  }
}
