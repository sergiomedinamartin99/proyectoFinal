import 'dart:convert';
import 'package:http/http.dart';

class NetworkProfile {
  final String url;
  final Map<String, dynamic> mapa;
  NetworkProfile(this.url, this.mapa);

  Future<Map<String, dynamic>?> fetchProfile() async {
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteProfile() async {
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProfile() async {
    Response response = await post(Uri.parse(url), body: mapa);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      return null;
    }
  }
}
