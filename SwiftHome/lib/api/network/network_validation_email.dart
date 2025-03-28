import 'dart:convert';
import 'package:http/http.dart';

class NetworkValidationEmail {
  final String url;
  final Map<String, String> mapa;
  NetworkValidationEmail(this.url, this.mapa);

  Future<String> fetchEmail() async {
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      if (responseJson['status'] == 1) {
        return "dontExist";
      } else if (responseJson['status'] == 0) {
        return "exist";
      } else {
        return "block";
      }
    } else {
      return "error";
    }
  }
}
