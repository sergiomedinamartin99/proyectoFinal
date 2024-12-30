import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_send_images.dart';
import 'package:swifthome/api/network/network_insert_data.dart';
import 'package:swifthome/page/home.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required String title});
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

  DateTime? _selectedDate;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controllerNombre = TextEditingController();
  final TextEditingController _controllerApellidos = TextEditingController();
  final TextEditingController _controllerCorreo = TextEditingController();
  final TextEditingController _controllerContrasena = TextEditingController();
  final TextEditingController _controllerConfirmarContrasena =
      TextEditingController();
  final TextEditingController _controllerFechaNacimiento =
      TextEditingController();
  final TextEditingController _controllerTelefono = TextEditingController();
  final TextEditingController _controllerBiografia = TextEditingController();
  final _formularioRegistro = GlobalKey<FormState>();

  final List<Imagen?> _imagenes =
      List.filled(9, null); // Lista de 9 imágenes o vacías
  @override
  void initState() {
    ciudades.sort();
    super.initState();
  }

  Future<void> _seleccionarImagen(int indice) async {
    final ImagePicker selector = ImagePicker();
    final XFile? imagenSeleccionada =
        await selector.pickImage(source: ImageSource.gallery);
    if (imagenSeleccionada != null) {
      final Uint8List bytesImagen = await imagenSeleccionada.readAsBytes();
      // Extraer el nombre del archivo e información del tipo
      final String nombreImagen =
          imagenSeleccionada.name.split('.')[0]; // Nombre de la imagen
      String tipoMime = '';
      if (imagenSeleccionada.mimeType != null) {
        tipoMime = imagenSeleccionada.mimeType!.split('/').last;
      } else {
        tipoMime = 'Desconocido';
      }
      setState(() {
        // Buscar la primera posición nula
        int primerIndiceNulo = _imagenes.indexWhere((imagen) => imagen == null);
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
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagenes[index] = null; // Eliminar la imagen de la posición específica
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // Bloquear fechas posteriores a la actual
      locale: const Locale('es', 'ES'), // Españolizar el calendario
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _controllerFechaNacimiento.text =
            DateFormat('dd/MM/yyyy').format(picked);
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
        child: Container(
          color: Colors.grey[200], // Fondo blanco para el contenedor
          padding: const EdgeInsets.only(
              left: 300, right: 300), // Espaciado alrededor del contenedor
          child: Card(
            color: Colors.white, // Fondo blanco para el card
            elevation: 5, // Sombra para el card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bordes redondeados
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Espaciado interno del card
              child: Column(
                children: [
                  Form(
                    key: _formularioRegistro,
                    child: Column(
                      children: [
                        Text(
                          "Regístrate en RoomSwipe",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        _negritaTexto("Apellidos del usuario"),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, introduce tus apellidos';
                            } else if (RegExp(r'\d').hasMatch(value)) {
                              return 'Los apellidos no pueden contener números';
                            }
                            return null;
                          },
                          controller: _controllerApellidos,
                          decoration: const InputDecoration(
                            hintText: "Introduce tus apellidos...",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        _negritaTexto("Correo Electrónico"),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, introduce tu correo electrónico';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Por favor, introduce un correo electrónico válido';
                            }
                            return null;
                          },
                          controller: _controllerCorreo,
                          decoration: const InputDecoration(
                            hintText: "Introduce tu correo electronico...",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _negritaTexto("Contraseña"),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, introduce tu contraseña';
                            } else if (value.length < 8) {
                              return 'La contraseña debe tener al menos 8 caracteres';
                            } else if (!RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$')
                                .hasMatch(value)) {
                              return 'La contraseña debe tener al menos una letra mayúscula, una letra minúscula y un número';
                            }
                            return null;
                          },
                          controller: _controllerContrasena,
                          decoration: const InputDecoration(
                            hintText: "Introduce tu contraseña...",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          obscureText: true,
                        ),
                        _negritaTexto("Confirmar contraseña"),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, introduce tu contraseña';
                            } else if (value.length < 8) {
                              return 'La contraseña debe tener al menos 8 caracteres';
                            } else if (!RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$')
                                .hasMatch(value)) {
                              return 'La contraseña debe tener al menos una letra mayúscula, una letra minúscula y un número';
                            }
                            return null;
                          },
                          controller: _controllerConfirmarContrasena,
                          decoration: const InputDecoration(
                            hintText: "Repite tu contraseña...",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          obscureText: true,
                        ),
                        _negritaTexto("Fecha de nacimiento"),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, selecciona tu fecha de nacimiento';
                            }
                            try {
                              DateTime selectedDate =
                                  DateFormat('dd/MM/yyyy').parse(value);
                              DateTime currentDate = DateTime.now();
                              int age = currentDate.year - selectedDate.year;
                              if (currentDate.month < selectedDate.month ||
                                  (currentDate.month == selectedDate.month &&
                                      currentDate.day < selectedDate.day)) {
                                age--;
                              }
                              if (age < 18) {
                                return 'Debes tener al menos 18 años';
                              }
                            } catch (e) {
                              return 'Formato de fecha inválido';
                            }
                            return null;
                          },
                          controller: _controllerFechaNacimiento,
                          decoration: InputDecoration(
                            hintText: "Selecciona tu fecha de nacimiento...",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                        ),
                        _negritaTexto("Teléfono"),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, introduce tu teléfono';
                            } else if (value.length != 9) {
                              return 'Por favor, introduce un teléfono válido';
                            } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                              return 'Por favor, introduce un teléfono válido';
                            }
                            return null;
                          },
                          controller: _controllerTelefono,
                          decoration: const InputDecoration(
                            hintText: "Introduce tu teléfono...",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, selecciona el tipo de usuario';
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, selecciona el tipo de usuario';
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                        ),
                        _negritaTexto("Imagen de perfil"),
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
                              if (_formularioRegistro.currentState!
                                      .validate() &&
                                  generoSeleccionadoString != null) {
                                Map<String, dynamic>? comprobar =
                                    await insertarDatosUsuario(
                                        _controllerNombre.text,
                                        _controllerApellidos.text,
                                        _controllerCorreo.text,
                                        _controllerContrasena.text,
                                        _controllerConfirmarContrasena.text,
                                        _controllerFechaNacimiento.text,
                                        _controllerTelefono.text,
                                        generoSeleccionadoString.toString(),
                                        cambioTipoUsuario.toString(),
                                        ciudadSeleccionada.toString(),
                                        _controllerBiografia.text,
                                        _imagenes);
                                if (comprobar != null && _imagenes.isNotEmpty) {
                                  if (comprobar['status'] == 1) {
                                    mostrarSnackBar(context,
                                        comprobar['mensaje'].toString());
                                    Map<String, dynamic>? comprobarImagenes =
                                        await insertImagenes(
                                            int.parse(comprobar['usuarioId']),
                                            _imagenes);
                                    if (comprobarImagenes != null) {
                                      if (comprobarImagenes['status'] == 1) {
                                        mostrarSnackBar(
                                            context,
                                            comprobarImagenes['mensaje']
                                                .toString());

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(
                                              idPersona: int.parse(
                                                  comprobar['usuarioId']),
                                            ),
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                      } else {
                                        mostrarSnackBar(
                                            context,
                                            comprobarImagenes['mensaje']
                                                .toString());
                                      }
                                    } else {
                                      mostrarSnackBar(context,
                                          "Error al subir las imagenes");
                                    }
                                  } else {
                                    mostrarSnackBar(context,
                                        comprobar['mensaje'].toString());
                                  }
                                } else {
                                  mostrarSnackBar(
                                      context, "Error al registrarse");
                                }
                              } else {
                                mostrarSnackBar(context,
                                    "Por favor, rellena todos los campos");
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
    'confirmarContrasena': confirmarContrasena,
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

class Imagen {
  String nombre;
  String tipo;
  Uint8List data;

  Imagen(this.nombre, this.tipo, this.data);
}
