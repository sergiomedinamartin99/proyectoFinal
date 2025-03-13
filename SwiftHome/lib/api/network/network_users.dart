import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkUserProfile {
  final String url;
  final Map<String, dynamic>? mapa;
  NetworkUserProfile(this.url, [this.mapa]);

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

  Future<String> unlockUser() async {
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        return responseData['mensaje'];
      } else {
        return responseData['mensaje'];
      }
    } else {
      debugPrint("Error: ${response.statusCode}");
      return "Ha ocurrido un error al desbloquear el usuario";
    }
  }

  Future<String> deleteUser() async {
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        return responseData['mensaje'];
      } else {
        return responseData['mensaje'];
      }
    } else {
      debugPrint("Error: ${response.statusCode}");
      return "Ha ocurrido un error al eliminar el usuario";
    }
  }

  Future<String> blockUser() async {
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        return responseData['mensaje'];
      } else {
        return responseData['mensaje'];
      }
    } else {
      debugPrint("Error: ${response.statusCode}");
      return "Ha ocurrido un error al bloquear el usuario";
    }
  }
}
