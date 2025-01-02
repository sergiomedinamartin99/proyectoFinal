import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkValidationEmail {
  final String url;
  final Map<String, String> mapa;
  NetworkValidationEmail(this.url, this.mapa);

  Future<bool> fetchEmail() async {
    debugPrint(url);
    debugPrint("$mapa");
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      var responseJson = json.decode(response.body);
      if (responseJson['status'] == 1) {
        debugPrint("Correcto, no existe el correo en la base de datos");
        return false;
      } else {
        debugPrint("Correcto, no existe el correo en la base de datos");
        return true;
      }
    } else {
      debugPrint("Error: ${response.statusCode}");
      return false;
    }
  }
}
