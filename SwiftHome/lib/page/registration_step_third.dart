import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  final String biografia;

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
    required this.biografia,
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
  final List<Imagen?> _imagenes =
      List.filled(9, null); // Lista de 9 imágenes o vacías

  Future<void> _seleccionarImagen(int indice) async {
    final ImagePicker selector = ImagePicker();
    final XFile? imagenSeleccionada =
        await selector.pickImage(source: ImageSource.gallery);
    if (imagenSeleccionada != null) {
      // Extraer el nombre del archivo e información del tipo
      final String nombreImagen =
          imagenSeleccionada.name.split('.')[0]; // Nombre de la imagen
      String tipoMime = '';
      String extensionImagen = '';
      if (imagenSeleccionada.mimeType != null) {
        tipoMime = imagenSeleccionada.mimeType!.split('/').last;
        extensionImagen = imagenSeleccionada.mimeType!;
      } else {
        tipoMime = 'Desconocido';
      }
      if (extensionImagen != '' && extensionImagen.startsWith('image/')) {
        final Uint8List bytesImagen = await imagenSeleccionada.readAsBytes();
        setState(() {
          // Buscar la primera posición nula
          int primerIndiceNulo =
              _imagenes.indexWhere((imagen) => imagen == null);
          if (primerIndiceNulo != -1) {
            indice = primerIndiceNulo;
          }
          if (_imagenes[indice] == null) {
            _imagenes[indice] = Imagen('', '', Uint8List(0));
          }
          _imagenes[indice]!.data = bytesImagen;
          _imagenes[indice]!.nombre = nombreImagen;
          _imagenes[indice]!.tipo = tipoMime;
        });
      } else {
        setState(() {
          showValidationText = true;
          validationMessage = "Por favor, selecciona un archivo de imagen.";
        });
        return;
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagenes[index] = null; // Eliminar la imagen de la posición específica
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(preferredSize: Size(20, 50), child: AppbarStart()),
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
                        padding: const EdgeInsets.all(
                            16.0), // Espaciado interno del card
                        child: Column(
                          children: [
                            Form(
                              key: _formularioRegistroStepThird,
                              child: Column(
                                children: [
                                  Text(
                                    "Sube tus imagenes",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                      "Paso 3 de 3: Añade imagenes a tu perfil"),
                                  labelForm(
                                    title: widget.buscandoPiso
                                        ? "Sube imagenes tuyas (máximo 9)"
                                        : "Sube imagenes de tu vivienda (máximo 9)",
                                  ),
                                  SizedBox(
                                    width: 400,
                                    height: 400,
                                    child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3, // Tres columnas
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount:
                                          9, // Siempre muestra 9 cuadrículas
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
                                                  onPressed: () => _removeImage(
                                                      index), // Eliminar imagen
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          // Si no hay imagen, mostrar botón para añadir
                                          return MaterialButton(
                                              onPressed: () => _seleccionarImagen(
                                                  index), // Añadir imagen en esa posición
                                              color: Colors.grey[
                                                  300], // Color de fondo del botón
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5), // Bordes redondeados
                                                side: const BorderSide(
                                                    color: Colors.black26,
                                                    width: 1),
                                              ),
                                              child: const Center(
                                                  child: Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              )));
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
                                        style: TextStyle(color: Colors.red),
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
                                        minimumSize: Size(double.infinity, 50),
                                      ),
                                      onPressed: () async {
                                        // Comprobar si todas las imágenes son nulas - Si un campo no es nulo se puede registrar
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

                                        // Validar el tamaño de las imágenes (5 MB = 5 * 1024 * 1024 bytes)
                                        bool hasLargeImages = _imagenes.any(
                                            (image) =>
                                                image != null &&
                                                image!.data.lengthInBytes >
                                                    5 * 1024 * 1024);

                                        if (hasLargeImages) {
                                          setState(() {
                                            showValidationText = true;
                                            validationMessage =
                                                "Cada imagen debe tener un tamaño menor a 5 MB";
                                          });
                                          return;
                                        }

                                        // Si todo es válido, oculta el mensaje de validación
                                        setState(() {
                                          showValidationText = false;
                                        });

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
                                                  widget.buscandoPiso
                                                      .toString(),
                                                  widget.ciudad.toString(),
                                                  widget.biografia,
                                                  _imagenes);
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
                                                    "Error al subir las imagenes");
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
                                      child: Text("Registrarse"),
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
  String buscandoPiso,
  String ciudad,
  String biografia,
  List<Imagen?> imagenes,
) {
  // Parse the input date string
  DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(fechaNacimiento);

  // Format the date to the desired format
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
    'buscandoPiso': buscandoPiso,
    'ciudad': ciudad,
    'biografia': biografia,
  };
  print(imagenes.toString());
  NetworkInsertData network = NetworkInsertData(url, useroomswift);
  return network.fetchData();
}

Future<Map<String, dynamic>?> insertImagenes(
  int perfilId,
  List<Imagen?> imagenes,
) {
  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlArchivo}';

  print(imagenes.toString());
  NetworkEnviarImagenes network = NetworkEnviarImagenes(url, perfilId,
      imagenes); // NetworkEnviarImagenes(url, perfilId, imagenes);
  return network.fetchData();
}

void mostrarSnackBar(BuildContext context, String mensaje) {
  final snackBar = SnackBar(
    content: Text(mensaje),
    action: SnackBarAction(
      label: 'Cerrar',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
