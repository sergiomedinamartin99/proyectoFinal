import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:swifthome/page/registration_step_third.dart';

class NetworkEnviarImagenes {
  String url;
  int perfilId;
  List<Imagen?> imagenes;
  NetworkEnviarImagenes(this.url, this.perfilId, this.imagenes);

  Future<Map<String, dynamic>?> fetchData() async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Agregar el perfilId
    request.fields['perfilId'] = perfilId.toString();

    // Agregar las imágenes
    for (var imagen in imagenes) {
      if (imagen != null) {
        // Split por '/' y nos quedamos con la última parte (ej. "png", "jpeg", etc.)
        final String extension = imagen.tipo.split('/').last;

        // Construimos el MediaType
        final contentType = MediaType('image', extension);

        final multipartFile = http.MultipartFile.fromBytes(
          'imagenes[]',
          imagen.data,
          filename: imagen.nombre,
          contentType: contentType,
        );

        request.files.add(multipartFile);
      }
    }

    // Enviar la solicitud
    var response = await request.send();

    // Obtener la respuesta
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } else {
      return null;
    }
  }
}
