import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_send_images.dart';
import 'package:swifthome/api/network/network_insert_data.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key, required String title}) : super(key: key);
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

enum Genero {
  Masculino,
  Femenino,
}

class _RegistrationPageState extends State<RegistrationPage> {
  Genero? generoSeleccionado;
  List<String> ciudades = [
    "Barcelona",
    "Madrid",
    "Valladolid",
  ];
  String? generoSeleccionadoString;
  bool? cambioTipoUsuario;
  String? ciudadSeleccionada;

  ScrollController _scrollController = ScrollController();
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerApellidos = TextEditingController();
  TextEditingController _controllerCorreo = TextEditingController();
  TextEditingController _controllerContrasena = TextEditingController();
  TextEditingController _controllerConfirmarContrasena =
      TextEditingController();
  TextEditingController _controllerEdad = TextEditingController();
  TextEditingController _controllerTelefono = TextEditingController();
  TextEditingController _controllerBiografia = TextEditingController();
  final _formularioRegistro = GlobalKey<FormState>();

  final List<Imagen?> _images =
      List.filled(9, null); // Lista de 9 imágenes o vacías
  @override
  void initState() {
    ciudades.sort();
    super.initState();
  }

  Future<void> _pickImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      // Extraer el nombre del archivo e información del tipo
      final String imageName =
          pickedImage.name.split('.')[0]; // Nombre de la imagen
      String mimeType = '';
      if (pickedImage.mimeType != null) {
        mimeType = pickedImage.mimeType!.split('/').last;
      } else {
        mimeType = 'Desconocido';
      }
      setState(() {
        if (_images[index] == null) {
          _images[index] = Imagen('', '', Uint8List(0));
        }
        _images[index]!.data = imageBytes;
        _images[index]!.nombre = imageName;
        _images[index]!.tipo = mimeType;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images[index] = null; // Eliminar la imagen de la posición específica
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Card(
          child: Column(
            children: [
              Form(
                key: _formularioRegistro,
                child: Column(
                  children: [
                    Text(
                      "Regístrate en RoomSwipe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                        "Crea tu cuenta para encontrar tu compañero de piso ideal"),
                    _negritaTexto("Nombre del usuario"),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, introduce tu nombre';
                        } else if (RegExp(r'\d').hasMatch(value)) {
                          return 'El nombre no puede contener números';
                        }
                        return null;
                      },
                      controller: _controllerNombre,
                      decoration: const InputDecoration(
                        hintText: "Introduce tu nombre...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    _negritaTexto("Apellidos del usuario"),
                    TextFormField(
                      controller: _controllerApellidos,
                      decoration: const InputDecoration(
                        hintText: "Introduce tus apellidos...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    _negritaTexto("Correo Electrónico"),
                    TextFormField(
                      controller: _controllerCorreo,
                      decoration: const InputDecoration(
                        hintText: "Introduce tu correo electronico...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _negritaTexto("Contraseña"),
                    TextFormField(
                      controller: _controllerContrasena,
                      decoration: const InputDecoration(
                        hintText: "Introduce tu contraseña...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    _negritaTexto("Confirmar contraseña"),
                    TextFormField(
                      controller: _controllerConfirmarContrasena,
                      decoration: const InputDecoration(
                        hintText: "Repite tu contraseña...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    _negritaTexto("Edad"),
                    TextFormField(
                      controller: _controllerEdad,
                      decoration: const InputDecoration(
                        hintText: "Introduce tu edad...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    _negritaTexto("Teléfono"),
                    TextFormField(
                      controller: _controllerTelefono,
                      decoration: const InputDecoration(
                        hintText: "Introduce tu teléfono...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    _negritaTexto("Genero"),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<Genero>(
                            title: const Text("Hombre"),
                            value: Genero.Masculino,
                            groupValue: generoSeleccionado,
                            onChanged: (Genero? value) {
                              setState(() {
                                generoSeleccionado = value;
                                generoSeleccionadoString = 'Masculino';
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<Genero>(
                            title: const Text("Mujer"),
                            value: Genero.Femenino,
                            groupValue: generoSeleccionado,
                            onChanged: (Genero? value) {
                              setState(() {
                                generoSeleccionado = value;
                                generoSeleccionadoString = 'Femenino';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    _negritaTexto("Tipo de usuario"),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonFormField<bool>(
                        validator: (value) => value == null
                            ? 'Por favor, selecciona el tipo de usuario'
                            : null,
                        value: cambioTipoUsuario,
                        hint: Text("Selecciona el tipo de usuario"),
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
                            cambioTipoUsuario = value!;
                          });
                        },
                      ),
                    ),
                    _negritaTexto("Ubicación"),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonFormField<String>(
                        value: ciudadSeleccionada,
                        validator: (value) => value == null
                            ? 'Por favor, selecciona tu ciudad'
                            : null,
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
                    _negritaTexto("Biografía"),
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
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                    _negritaTexto("Imagen de perfil"),
                    Container(
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
                        itemCount: 9, // Siempre muestra 9 cuadrículas
                        itemBuilder: (context, index) {
                          if (_images[index] != null) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(
                                  _images[index]!.data,
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
                                onPressed: () => _pickImage(
                                    index), // Añadir imagen en esa posición
                                color: Colors
                                    .grey[300], // Color de fondo del botón
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // Bordes redondeados
                                  side: const BorderSide(
                                      color: Colors.black26, width: 1),
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
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formularioRegistro.currentState!.validate() &&
                              generoSeleccionadoString != null) {
                            Map<String, dynamic>? comprobar =
                                await insertarDatosUsuario(
                                    _controllerNombre.text,
                                    _controllerApellidos.text,
                                    _controllerCorreo.text,
                                    _controllerContrasena.text,
                                    _controllerConfirmarContrasena.text,
                                    _controllerEdad.text,
                                    _controllerTelefono.text,
                                    generoSeleccionadoString.toString(),
                                    cambioTipoUsuario.toString(),
                                    ciudadSeleccionada.toString(),
                                    _controllerBiografia.text,
                                    _images);
                            if (comprobar != null && _images.length > 0) {
                              if (comprobar['status'] == 1) {
                                mostrarSnackBar(
                                    context, comprobar['mensaje'].toString());
                              } else {
                                mostrarSnackBar(
                                    context, comprobar['mensaje'].toString());
                              }
                            } else {
                              mostrarSnackBar(context, "Error al registrarse");
                            }
                          } else {
                            mostrarSnackBar(
                                context, "Por favor, rellena todos los campos");
                          }
                        },
                        child: const Text("Registrarse"),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic>? comprobar =
                              await insertImagenes(5, _images);
                          if (comprobar != null) {
                            if (comprobar['status'] == 1) {
                              mostrarSnackBar(
                                  context, comprobar['mensaje'].toString());
                            } else {
                              mostrarSnackBar(
                                  context, comprobar['mensaje'].toString());
                            }
                          } else {
                            mostrarSnackBar(
                                context, "Error al subir las imagenes");
                          }
                        },
                        child: Text('prueba'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _negritaTexto(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
          text: texto,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: [
            TextSpan(
              text: "\t*",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        )),
      ),
    );
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
}

Future<Map<String, dynamic>?> insertarDatosUsuario(
  String nombre,
  String apellidos,
  String correo,
  String contrasena,
  String confirmarContrasena,
  String edad,
  String telefono,
  String genero,
  String buscandoPiso,
  String ciudad,
  String biografia,
  List<Imagen?> imagenes,
) {
  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlRegistro}';
  final useroomswift = {
    'nombre': nombre,
    'apellidos': apellidos,
    'correo': correo,
    'contrasena': contrasena,
    'confirmarContrasena': confirmarContrasena,
    'edad': edad,
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

class Imagen {
  String nombre;
  String tipo;

  Uint8List data;

  Imagen(this.nombre, this.tipo, this.data);
}