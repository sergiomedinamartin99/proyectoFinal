import 'dart:convert';
import 'package:http/http.dart';

class NetworkCheck {
  final String url;
  final Map<String, dynamic> mapa;
  NetworkCheck(this.url, this.mapa);

  Future<Map<String, dynamic>?> fetchData() async {
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      return null;
    }
  }
}
