import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_profile.dart';
import 'package:swifthome/api/network/network_send_images.dart';
import 'package:swifthome/page/leading.dart';
import 'package:swifthome/page/registration_step_third.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';
import 'package:swifthome/widget/footer.dart';
import 'package:swifthome/widget/labelForm.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.idPersona});

  final int idPersona;

  @override
  State<ProfilePage> createState() => _ProfilePagePageState();
}

class _ProfilePagePageState extends State<ProfilePage> {
  List<String> genero = ["Masculino", "Femenino", "No binario"];
  List<String> ciudades = ["Barcelona", "Madrid", "Valladolid"];
  String? generoSeleccionado;
  bool? buscandoPisoSeleccionado;
  String? ciudadSeleccionada;
  final _formularioRegistroStepSecond = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controllerNombre = TextEditingController();
  final TextEditingController _controllerApellidos = TextEditingController();
  final TextEditingController _controllerFechaNacimiento =
      TextEditingController();
  final TextEditingController _controllerTelefono = TextEditingController();
  final TextEditingController _controllerBiografia = TextEditingController();
  bool showValidationText = false;
  String validationMessage = "";
  final List<Imagen?> _imagenes =
      List.filled(9, null); // Lista de 9 imágenes o vacías

  @override
  void initState() {
    ciudades.sort();
    getDatosUsuario(widget.idPersona.toString()).then((value) {
      getImagenesUsuario(widget.idPersona.toString()).then((valueImagenes) {
        if (valueImagenes != null) {
          for (int i = 0; i < valueImagenes['imagenes'].length; i++) {
            _imagenes[valueImagenes['imagenes'][i]['posicionImagen']] = Imagen(
                valueImagenes['imagenes'][i]['nombre'],
                valueImagenes['imagenes'][i]['tipo'],
                base64Decode(valueImagenes['imagenes'][i]['datos']));
          }
        }
      });
      if (value != null) {
        setState(() {
          _controllerNombre.text = value['perfilUsuario']['nombre'];
          _controllerApellidos.text = value['perfilUsuario']['apellidos'];
          _controllerFechaNacimiento.text =
              value['perfilUsuario']['fecha_nacimiento'];
          _controllerTelefono.text =
              value['perfilUsuario']['telefono'].toString();
          generoSeleccionado = value['perfilUsuario']['genero'];
          ciudadSeleccionada = value['perfilUsuario']['ubicacion'];
          buscandoPisoSeleccionado =
              value['perfilUsuario']['buscandoPiso'] == 1;
        });
      }
    });
    super.initState();
  }

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
      // Desplazar cada imagen una posición hacia la izquierda
      // empezando desde la posición que se elimina.
      for (int i = index; i < _imagenes.length - 1; i++) {
        _imagenes[i] = _imagenes[i + 1];
      }
      // Colocar null en la última posición, ya que todas las imágenes
      // se han corrido una posición a la izquierda.
      _imagenes[_imagenes.length - 1] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
        preferredSize: Size(20, 50),
        child: AppbarAlreadyRegistered(
          namePage: 'profile',
          idPersona: widget.idPersona,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: LayoutBuilder(builder: (context, constraints) {
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
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // TabBar agregado
                            TabBar(
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.black,
                              tabs: [
                                Tab(text: 'Información Personal'),
                                Tab(text: 'Gestionar Imágenes'),
                              ],
                            ),
                            Container(
                              height: 1000,
                              child: TabBarView(
                                physics: BouncingScrollPhysics(),
                                children: [
                                  _informacionPersonal(),
                                  _gestionarImagenes()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Footer(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _informacionPersonal() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formularioRegistroStepSecond,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelForm(title: "Nombre"),
            TextFormField(
              enabled: false,
              controller: _controllerNombre,
              decoration: const InputDecoration(
                hintText: "Introduce tu nombre...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.name,
            ),
            labelForm(title: "Apellidos"),
            TextFormField(
              enabled: false,
              controller: _controllerApellidos,
              decoration: const InputDecoration(
                hintText: "Introduce tus apellidos...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.name,
            ),
            labelForm(title: "Fecha de nacimiento"),
            TextFormField(
              enabled: false,
              controller: _controllerFechaNacimiento,
              decoration: InputDecoration(
                hintText: "Selecciona tu fecha de nacimiento...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
            ),
            labelForm(title: "Telefono"),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, introduce tu teléfono';
                } else if (!RegExp(r'^[0-9]*$').hasMatch(value) &&
                    value.length == 9) {
                  return 'Por favor, introduce un teléfono válido';
                }
                return null;
              },
              controller: _controllerTelefono,
              decoration: const InputDecoration(
                hintText: "Introduce tu teléfono...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            labelForm(title: "Genero"),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: generoSeleccionado,
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona tu genero';
                  }
                  return null;
                },
                hint: Text("Selecciona tu genero"),
                items: genero.map((String genero) {
                  return DropdownMenuItem<String>(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      generoSeleccionado = value;
                    }
                  });
                },
              ),
            ),
            labelForm(title: "Ubicación"),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: ciudadSeleccionada,
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona tu ciudad';
                  }
                  return null;
                },
                hint: Text("Selecciona tu ciudad"),
                items: ciudades.map((String ciudad) {
                  return DropdownMenuItem<String>(
                    value: ciudad,
                    child: Text(ciudad),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      ciudadSeleccionada = value;
                    }
                  });
                },
              ),
            ),
            labelForm(title: "¿Qué buscas en SwiftHome?"),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButtonFormField<bool>(
                dropdownColor: Colors.white,
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona el tipo de búsqueda';
                  }
                  return null;
                },
                value: buscandoPisoSeleccionado,
                hint: Text("Selecciona el tipo de búsqueda"),
                items: const [
                  DropdownMenuItem(
                    value: true,
                    child: Text("Busco habitación"),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text("Ofrezco habitación"),
                  ),
                ],
                onChanged: (bool? value) {
                  setState(() {
                    buscandoPisoSeleccionado = value!;
                  });
                },
              ),
            ),
            labelForm(title: "Biografía"),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, introduce tu biografía';
                }
                return null;
              },
              controller: _controllerBiografia,
              decoration: const InputDecoration(
                hintText: "Introduce tu biografía...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (_formularioRegistroStepSecond.currentState!.validate()) {}
                },
                child: Text("Actualizar perfil"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => LeadingPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text("Cerrar sesión"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 0, 0, 0.8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        true, // Permite cerrar el diálogo tocando fuera
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text("Confirmar eliminación"),
                        content: Text(
                            "¿Estás seguro de que deseas eliminar tu cuenta?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cierra el diálogo
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Map<String, dynamic>? comprobarEliminacion =
                                  await deleteUsuario(
                                      widget.idPersona.toString());
                              if (comprobarEliminacion != null) {
                                if (comprobarEliminacion['status'] == 1) {
                                  mostrarSnackBar(
                                      context,
                                      comprobarEliminacion['mensaje']
                                          .toString());
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => LeadingPage(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  mostrarSnackBar(
                                      context,
                                      comprobarEliminacion['mensaje']
                                          .toString());
                                }
                              } else {
                                mostrarSnackBar(
                                    context, "Error al subir las imagenes");
                              }
                              /*SnackbarPersonalized(title: "Cuenta eliminada")
                                  .show(context);
                              */
                            },
                            child: Text(
                              "Sí",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Eliminar cuenta"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gestionarImagenes() {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Espaciado interno del card
      child: Column(
        children: [
          Text(
            "Sube tus imagenes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text("Paso 3 de 3: Añade imagenes a tu perfil"),
          labelForm(
            title: buscandoPisoSeleccionado == true
                ? "Sube imagenes tuyas (máximo 9)"
                : "Sube imagenes de tu vivienda (máximo 9)",
          ),
          SizedBox(
            width: 400,
            height: 400,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Tres columnas
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 9, // Siempre muestra 9 cuadrículas
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
                              _removeImage(index), // Eliminar imagen
                        ),
                      ),
                    ],
                  );
                } else {
                  // Si no hay imagen, mostrar botón para añadir
                  return MaterialButton(
                      onPressed: () => _seleccionarImagen(
                          index), // Añadir imagen en esa posición
                      color: Colors.grey[300], // Color de fondo del botón
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Bordes redondeados
                        side: const BorderSide(color: Colors.black26, width: 1),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () async {
                Map<String, dynamic>? comprobarImagenes = await updateImagenes(
                    int.parse(widget.idPersona.toString()), _imagenes);
                if (comprobarImagenes != null) {
                  if (comprobarImagenes['status'] == 1) {
                    mostrarSnackBar(
                        context, comprobarImagenes['mensaje'].toString());
                  } else {
                    mostrarSnackBar(
                        context, comprobarImagenes['mensaje'].toString());
                  }
                } else {
                  mostrarSnackBar(context, "Error al subir las imagenes");
                }
              },
              child: Text("Actualizar imagenes"),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>?> getDatosUsuario(String idUsuario) async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlContenidoUsuario}';
  final user = {"idUsuario": idUsuario};
  NetworkProfile network = NetworkProfile(url, user);
  return network.fetchProfile();
}

Future<Map<String, dynamic>?> getImagenesUsuario(String idUsuario) async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlImagenesObtener}';
  final user = {"idUsuario": idUsuario};
  NetworkProfile network = NetworkProfile(url, user);
  return network.fetchProfile();
}

Future<Map<String, dynamic>?> updateImagenes(
  int perfilId,
  List<Imagen?> imagenes,
) async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlImagenesActualizar}';

  print(imagenes.toString());
  NetworkEnviarImagenes network = NetworkEnviarImagenes(url, perfilId,
      imagenes); // NetworkEnviarImagenes(url, perfilId, imagenes);
  return network.fetchData();
}

Future<Map<String, dynamic>?> deleteUsuario(String idUsuario) async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlEliminarUsuario}';
  final user = {"idUsuario": idUsuario};
  NetworkProfile network = NetworkProfile(url, user);
  return network.deleteProfile();
}
