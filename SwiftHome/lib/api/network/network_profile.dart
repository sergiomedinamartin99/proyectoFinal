import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkProfile {
  final String url;
  final Map<String, dynamic> mapa;
  NetworkProfile(this.url, this.mapa);

  Future<Map<String, dynamic>?> fetchProfile() async {
    debugPrint(url);
    debugPrint("$mapa");
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      debugPrint("Contenido: $responseData");
      return responseData;
    } else {
      debugPrint("Error: ${response.statusCode}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteProfile() async {
    debugPrint(url);
    debugPrint("$mapa");
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      debugPrint("Usuario eliminado: $responseData");
      return responseData;
    } else {
      debugPrint("Error: ${response.statusCode}");
      return null;
    }
  }
}
