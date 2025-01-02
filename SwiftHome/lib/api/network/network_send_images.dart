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
        var multipartFile = http.MultipartFile.fromBytes(
          'imagenes[]', // Nombre del campo para las imágenes
          imagen.data,
          filename: imagen.nombre,
          contentType: MediaType('image', imagen.tipo),
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
