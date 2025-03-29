import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_insert_data.dart';
import 'package:swifthome/api/network/network_send_images.dart';
import 'package:swifthome/page/home.dart';
import 'package:swifthome/widget/appbarStart.dart';
import 'package:swifthome/widget/footer.dart';
import 'package:swifthome/widget/labelForm.dart';

class RegistrationStepThirdPage extends StatefulWidget {
  final String correoElectronico;
  final String contrasena;
  final String nombre;
  final String apellidos;
  final String fechaNacimiento;
  final String telefono;
  final String genero;
  final String ciudad;
  final bool buscandoPiso;
  final String ocupacion;
  final String biografia;
  final String precio;
  final String descripcionVivienda;

  const RegistrationStepThirdPage({
    super.key,
    required this.correoElectronico,
    required this.contrasena,
    required this.nombre,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.telefono,
    required this.genero,
    required this.ciudad,
    required this.buscandoPiso,
    required this.ocupacion,
    required this.biografia,
    required this.precio,
    required this.descripcionVivienda,
  });

  @override
  State<RegistrationStepThirdPage> createState() =>
      _RegistrationStepThirdPageState();
}

class _RegistrationStepThirdPageState extends State<RegistrationStepThirdPage> {
  final ScrollController _scrollController = ScrollController();
  final _formularioRegistroStepThird = GlobalKey<FormState>();
  bool showValidationText = false;
  String validationMessage = "";

  final List<Imagen?> _imagenes = List.filled(9, null);

  Future<void> _seleccionarImagen(int indice) async {
    final ImagePicker selector = ImagePicker();
    final XFile? imagenSeleccionada =
        await selector.pickImage(source: ImageSource.gallery);

    if (imagenSeleccionada != null) {
      // === PASO 1: Abrimos el cropper para recortar/forzar dimensiones ===
      final CroppedFile? imagenRecortada = await ImageCropper().cropImage(
        sourcePath: imagenSeleccionada.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar imagen',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor:
                Colors.black, // Cambia los controles activos
            cropFrameColor: Colors.black, // Color del marco
            cropGridColor: Colors.black, // Color de la cuadrícula
            backgroundColor: Colors.black, // Fondo negro
            dimmedLayerColor: Colors.black, // Capa oscura
          ),
          IOSUiSettings(
            title: 'Recortar imagen',
            aspectRatioLockEnabled: true, // Bloquea la relación de aspecto
            aspectRatioPickerButtonHidden: true,
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(
              width: 500,
              height: 500,
            ),
            cropBoxResizable:
                false, // No permite redimensionar el área de recorte
            dragMode: WebDragMode.move,
            translations: WebTranslations(
              title: "Ajustar imagen",
              rotateLeftTooltip: "Rotar izquierda",
              rotateRightTooltip: "Rotar derecha",
              cancelButton: "Cancelar",
              cropButton: "Recortar",
            ),
            themeData: WebThemeData(
              rotateIconColor: Colors.black,
            ),
          ),
        ],
        aspectRatio:
            const CropAspectRatio(ratioX: 5, ratioY: 7), // Relación 5:7
      );

      // === PASO 2: Si el recorte no se canceló, redimensionamos a 500x700 ===
      if (imagenRecortada != null) {
        final Uint8List bytesImagen = await imagenRecortada.readAsBytes();
        final img.Image? imagenOriginal = img.decodeImage(bytesImagen);

        if (imagenOriginal != null) {
          // Redimensionamos la imagen a 500x700
          final img.Image imagenRedimensionada =
              img.copyResize(imagenOriginal, width: 500, height: 700);

          // Convertimos la imagen redimensionada a bytes
          final Uint8List bytesRedimensionados =
              Uint8List.fromList(img.encodeJpg(imagenRedimensionada));

          // Extraemos nombre y tipo MIME
          final String nombreImagen =
              imagenSeleccionada.name.split('.')[0]; // nombre base
          String tipoMime =
              imagenSeleccionada.mimeType?.split('/').last ?? 'jpg';

          // Actualizamos el estado
          setState(() {
            int primerIndiceNulo =
                _imagenes.indexWhere((imagen) => imagen == null);
            if (primerIndiceNulo != -1) {
              indice = primerIndiceNulo;
            }
            if (_imagenes[indice] == null) {
              _imagenes[indice] = Imagen('', '', Uint8List(0));
            }
            _imagenes[indice]!.data = bytesRedimensionados;
            _imagenes[indice]!.nombre = nombreImagen;
            _imagenes[indice]!.tipo = tipoMime;
          });
        }
      } else {
        debugPrint("Recorte cancelado por el usuario");
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagenes[index] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
        preferredSize: const Size(20, 50),
        child: AppbarStart(page: 'registration'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 32,
                      bottom: constraints.maxWidth > 1200 ? 0 : 16,
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: Card(
                      color: Colors.white, // Fondo blanco para el card
                      elevation: 5, // Sombra para el card
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Form(
                              key: _formularioRegistroStepThird,
                              child: Column(
                                children: [
                                  const Text(
                                    "Sube tus imágenes",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const Text(
                                      "Paso 3 de 3: Añade imágenes a tu perfil"),
                                  labelForm(
                                    title: widget.buscandoPiso
                                        ? "Sube imágenes tuyas (máximo 9)"
                                        : "Sube imágenes de tu vivienda (máximo 9)",
                                  ),
                                  SizedBox(
                                    width: 400,
                                    height: 400,
                                    child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3, // Tres columnas
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount: 9, // Siempre 9 casillas
                                      itemBuilder: (context, index) {
                                        if (_imagenes[index] != null) {
                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Image.memory(
                                                _imagenes[index]!.data,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () =>
                                                      _removeImage(index),
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return MaterialButton(
                                            onPressed: () =>
                                                _seleccionarImagen(index),
                                            color: Colors.grey[300],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: const BorderSide(
                                                  color: Colors.black26,
                                                  width: 1),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Visibility(
                                      visible: showValidationText,
                                      child: Text(
                                        validationMessage,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                      ),
                                      onPressed: () async {
                                        // Comprobar si todas las imágenes son nulas
                                        bool allImagesNull = _imagenes
                                            .every((image) => image == null);
                                        if (allImagesNull) {
                                          setState(() {
                                            showValidationText = true;
                                            validationMessage =
                                                "Debes subir al menos una imagen";
                                          });
                                          return;
                                        }

                                        // Validar el tamaño de las imágenes (5 MB)
                                        bool hasLargeImages = _imagenes.any(
                                          (image) =>
                                              image != null &&
                                              image.data.lengthInBytes >
                                                  5 * 1024 * 1024,
                                        );
                                        if (hasLargeImages) {
                                          setState(() {
                                            showValidationText = true;
                                            validationMessage =
                                                "Cada imagen debe tener un tamaño menor a 5 MB";
                                          });
                                          return;
                                        }

                                        // Todo OK, ocultamos el mensaje si estaba visible.
                                        setState(() {
                                          showValidationText = false;
                                        });

                                        // Llamamos a la inserción en BD:
                                        if (!showValidationText) {
                                          Map<String, dynamic>? comprobar =
                                              await insertarDatosUsuario(
                                            widget.nombre,
                                            widget.apellidos,
                                            widget.correoElectronico,
                                            widget.contrasena,
                                            widget.fechaNacimiento,
                                            widget.telefono,
                                            widget.genero,
                                            widget.ciudad.toString(),
                                            widget.buscandoPiso.toString(),
                                            widget.ocupacion,
                                            widget.biografia,
                                            widget.precio,
                                            widget.descripcionVivienda,
                                          );

                                          if (comprobar != null &&
                                              _imagenes.isNotEmpty) {
                                            if (comprobar['status'] == 1) {
                                              mostrarSnackBar(
                                                  context,
                                                  comprobar['mensaje']
                                                      .toString());
                                              Map<String, dynamic>?
                                                  comprobarImagenes =
                                                  await insertImagenes(
                                                      int.parse(comprobar[
                                                          'usuarioId']),
                                                      _imagenes);
                                              if (comprobarImagenes != null) {
                                                if (comprobarImagenes[
                                                        'status'] ==
                                                    1) {
                                                  mostrarSnackBar(
                                                      context,
                                                      comprobarImagenes[
                                                              'mensaje']
                                                          .toString());
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(
                                                        idPersona: int.parse(
                                                            comprobar[
                                                                'usuarioId']),
                                                        buscandoPiso: comprobar[
                                                            'buscandoPiso'],
                                                        isAdmin: false,
                                                      ),
                                                    ),
                                                    (Route<dynamic> route) =>
                                                        false,
                                                  );
                                                } else {
                                                  mostrarSnackBar(
                                                      context,
                                                      comprobarImagenes[
                                                              'mensaje']
                                                          .toString());
                                                }
                                              } else {
                                                mostrarSnackBar(context,
                                                    "Error al subir las imágenes");
                                              }
                                            } else {
                                              mostrarSnackBar(
                                                  context,
                                                  comprobar['mensaje']
                                                      .toString());
                                            }
                                          } else {
                                            mostrarSnackBar(context,
                                                "Error al registrarse");
                                          }
                                        }
                                      },
                                      child: const Text("Registrarse"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Footer()
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// Clase para manejar imágenes
class Imagen {
  String nombre;
  String tipo;
  Uint8List data;

  Imagen(this.nombre, this.tipo, this.data);
}

Future<Map<String, dynamic>?> insertarDatosUsuario(
  String nombre,
  String apellidos,
  String correo,
  String contrasena,
  String fechaNacimiento,
  String telefono,
  String genero,
  String ciudad,
  String buscandoPiso,
  String ocupacion,
  String biografia,
  String precio,
  String descripcionVivienda,
) {
  // Parseamos la fecha recibida
  DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(fechaNacimiento);
  // Formateamos a 'yyyy-MM-dd'
  String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlRegistro}';
  final useroomswift = {
    'nombre': nombre,
    'apellidos': apellidos,
    'correo': correo,
    'contrasena': contrasena,
    'fechaNacimiento': formattedDate,
    'telefono': telefono,
    'genero': genero,
    'ciudad': ciudad,
    'buscandoPiso': buscandoPiso,
    'ocupacion': ocupacion,
    'biografia': biografia,
    'precio': precio,
    'descripcionVivienda': descripcionVivienda,
  };

  NetworkInsertData network = NetworkInsertData(url, useroomswift);
  return network.fetchData();
}

Future<Map<String, dynamic>?> insertImagenes(
  int perfilId,
  List<Imagen?> imagenes,
) {
  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlArchivo}';
  NetworkEnviarImagenes network = NetworkEnviarImagenes(
    url,
    perfilId,
    imagenes,
  );
  return network.fetchData();
}

void mostrarSnackBar(BuildContext context, String mensaje) {
  final snackBar = SnackBar(
    content: Text(mensaje),
    action: SnackBarAction(
      label: 'Cerrar',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
