import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_profile.dart';
import 'package:swifthome/api/network/network_send_images.dart';
import 'package:swifthome/page/leading.dart';
import 'package:swifthome/page/registration_step_third.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';
import 'package:swifthome/widget/footer.dart';
import 'package:swifthome/widget/labelForm.dart';
import 'package:image/image.dart' as img;

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key,
      required this.idPersona,
      required this.buscandoPiso,
      required this.isAdmin});

  final int idPersona;
  final bool buscandoPiso;
  final bool isAdmin;

  @override
  State<ProfilePage> createState() => _ProfilePagePageState();
}

class _ProfilePagePageState extends State<ProfilePage> {
  List<String> genero = ["Masculino", "Femenino", "No binario"];
  List<String> ciudades = ["Barcelona", "Madrid", "Valladolid"];
  String? generoSeleccionado;
  bool? buscandoPisoSeleccionado;
  String? ciudadSeleccionada;
  String? ocupacionSeleccionada;
  List<String> ocupaciones = [
    "Médico",
    "Ingeniero",
    "Profesor",
    "Diseñador Gráfico",
    "Informático",
    "Abogado",
    "Contador",
    "Electricista",
    "Chef",
    "Arquitecto"
  ];
  final _formularioActualizacion = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controllerNombre = TextEditingController();
  final TextEditingController _controllerApellidos = TextEditingController();
  final TextEditingController _controllerFechaNacimiento =
      TextEditingController();
  final TextEditingController _controllerTelefono = TextEditingController();
  final TextEditingController _controllerBiografia = TextEditingController();
  final TextEditingController _controllerPrecio = TextEditingController();
  final TextEditingController _controllerDescripcionVivienda =
      TextEditingController();
  bool showValidationText = false;
  String validationMessage = "";
  final List<Imagen?> _imagenes =
      List.filled(9, null); // Lista de 9 imágenes o vacías

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // Bloquear fechas posteriores a la actual
      locale: const Locale('es', 'ES'), // Españolizar el calendario
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Color de selección
              onPrimary: Colors.white, // Texto sobre el color de selección
              surface: Colors.white, // Fondo de los elementos
              onSurface: Colors.black, // Texto general
            ),
            dialogBackgroundColor:
                Colors.white, // Fondo blanco del cuadro de diálogo
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(
        () {
          _selectedDate = picked;
          _controllerFechaNacimiento.text =
              DateFormat('dd/MM/yyyy').format(picked);
        },
      );
    }
  }

  @override
  void initState() {
    print("EL TIO CON SU DESCRIPCION DE LA BUSCACION ${widget.buscandoPiso}");
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
          _controllerFechaNacimiento.text = DateFormat('dd/MM/yyyy').format(
            DateTime.parse(value['perfilUsuario']['fecha_nacimiento']),
          );
          _controllerTelefono.text =
              value['perfilUsuario']['telefono'].toString();
          generoSeleccionado = value['perfilUsuario']['genero'];
          ciudadSeleccionada = value['perfilUsuario']['ubicacion'];
          buscandoPisoSeleccionado =
              value['perfilUsuario']['buscandoPiso'] == 1 ? true : false;
          if (buscandoPisoSeleccionado!) {
            ocupacionSeleccionada = value['perfilUsuario']['ocupacion'];
            _controllerBiografia.text = value['perfilUsuario']['biografia'];
          } else {
            _controllerPrecio.text =
                (double.parse(value['perfilUsuario']['precio']))
                    .toStringAsFixed(0);
            _controllerDescripcionVivienda.text =
                value['perfilUsuario']['descripcionVivienda'];
          }
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
            size: CropperSize(
              width: 500,
              height: MediaQuery.of(context).size.height <= 1200 ? 300 : 500,
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
    final screenHeight = MediaQuery.of(context).size.height;
    // Elegimos el mayor de los dos porcentajes para que TabBarView tenga una altura fija.
    final tabViewHeight = screenHeight * 0.78;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppbarAlreadyRegistered(
          namePage: 'profile',
          idPersona: widget.idPersona,
          buscandoPiso: widget.buscandoPiso,
          isAdmin: widget.isAdmin,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          // Columna Principal
          children: [
            // TARJETA CON TAB BAR Y TAB BAR VIEW
            // Haz que esta sección (Padding + Card) se expanda
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 50.0, right: 50.0, top: 50),
                child: Card(
                  // Es importante que la Card no fuerce una altura intrínseca grande
                  // Si Card tiene padding interno, está bien.
                  child: Column(
                    // Columna dentro de la Card
                    // crossAxisAlignment: CrossAxisAlignment.stretch, // Opcional
                    children: [
                      TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        tabs: const [
                          Tab(text: 'Información Personal'),
                          Tab(text: 'Gestionar Imágenes'),
                        ],
                      ),
                      // Haz que el TabBarView ocupe el espacio restante DENTRO de la Card
                      Expanded(
                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // El SingleChildScrollView permite scroll si el contenido es más grande
                            // que el espacio que le da el Expanded.
                            // El ConstrainedBox con minHeight puede ser problemático aquí.
                            // Considera quitarlo a menos que sea estrictamente necesario
                            // asegurar un tamaño mínimo visual incluso con poco contenido.
                            SingleChildScrollView(
                              // Opcional: Añade padding interno si es necesario
                              // padding: const EdgeInsets.all(16.0),
                              child:
                                  _informacionPersonal(), // Tu widget de contenido
                            ),
                            SingleChildScrollView(
                              // padding: const EdgeInsets.all(16.0), // Opcional
                              child:
                                  _gestionarImagenes(), // Tu widget de contenido
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Ya no necesitas Spacer, Expanded se encarga de llenar el espacio
            // Spacer(),
            // FOOTER AL FINAL
            Footer(), // Footer se coloca después del contenido expandido
          ],
        ),
      ),
    );
  }

  Widget _informacionPersonal() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formularioActualizacion,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelForm(title: "Nombre"),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, introduce tu nombre';
                } else if (RegExp(r'\d').hasMatch(value)) {
                  return 'El nombre no puede contener números';
                }
                return null;
              },
              enabled: widget.isAdmin ? true : false,
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, introduce tus apellidos';
                } else if (RegExp(r'\d').hasMatch(value)) {
                  return 'Los apellidos no pueden contener números';
                }
                return null;
              },
              enabled: widget.isAdmin ? true : false,
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
              enabled: widget.isAdmin ? true : false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, selecciona tu fecha de nacimiento';
                }
                try {
                  DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(value);
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
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
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
              enabled: widget.isAdmin ? true : false,
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
            labelForm(title: "¿Qué buscas en RoomSwipe?"),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButtonFormField<bool>(
                dropdownColor: Colors.white,
                isExpanded: true,
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
            buscandoPisoSeleccionado == true
                ? Column(
                    children: [
                      labelForm(title: "Ocupación"),
                      // EDITAR
                      Align(
                        alignment: Alignment.topLeft,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                          value: ocupacionSeleccionada,
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, selecciona tu ocupaación';
                            }
                            return null;
                          },
                          hint: Text("Selecciona tu ocupación"),
                          items: ocupaciones.map((String ocupaciones) {
                            return DropdownMenuItem<String>(
                              value: ocupaciones,
                              child: Text(ocupaciones),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              if (value != null) {
                                ocupacionSeleccionada = value;
                              }
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
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      ),
                    ],
                  )
                : buscandoPisoSeleccionado == false
                    ? Column(
                        children: [
                          // AÑADIR CAMPOS PARA OFRECER HABITACIÓN
                          labelForm(title: "Precio"),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, introduce el precio de la vivienda';
                              } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                                return 'Por favor, introduce un precio válido sin puntos ni decimales';
                              }
                              return null;
                            },
                            controller: _controllerPrecio,
                            decoration: const InputDecoration(
                              hintText: "Introduce el precio de la vivienda...",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          labelForm(title: "Descripción de la vivienda"),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, introduce la descripción de la vivienda';
                              }
                              return null;
                            },
                            controller: _controllerDescripcionVivienda,
                            decoration: const InputDecoration(
                              hintText:
                                  "Introduce la descripción de la vivienda...",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                          ),
                        ],
                      )
                    : SizedBox(),
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
                  if (_formularioActualizacion.currentState!.validate()) {
                    Map<String, dynamic>? actualizacion =
                        await updateDatosUsuario(
                            widget.idPersona,
                            _controllerNombre.text,
                            _controllerApellidos.text,
                            _controllerFechaNacimiento.text,
                            _controllerTelefono.text,
                            generoSeleccionado.toString(),
                            ciudadSeleccionada.toString(),
                            buscandoPisoSeleccionado.toString(),
                            ocupacionSeleccionada.toString(),
                            _controllerBiografia.text,
                            _controllerPrecio.text,
                            _controllerDescripcionVivienda.text);
                    if (actualizacion!["status"] == 1) {
                      // aqui snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(actualizacion["mensaje"]),
                          action: SnackBarAction(
                            label: 'Cerrar',
                            onPressed: () {},
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(actualizacion["mensaje"]),
                          action: SnackBarAction(
                            label: 'Cerrar',
                            onPressed: () {},
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text("Actualizar perfil"),
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
            padding: const EdgeInsets.only(top: 50.0),
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

Future<Map<String, dynamic>?> updateDatosUsuario(
  int idUsuario,
  String nombre,
  String apellidos,
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

  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlUpdateUserRoomSwipe}';
  final useroomswift = {
    "idUsuario": idUsuario.toString(),
    'nombre': nombre,
    'apellidos': apellidos,
    'fechaNacimiento': formattedDate,
    'telefono': telefono,
    'genero': genero,
    'ciudad': ciudad,
    'buscandoPiso': buscandoPiso,
    'ocupacion': ocupacion.isEmpty ? 'No hay ocupacion' : ocupacion,
    'biografia': biografia.isEmpty ? 'No hay biografia' : biografia,
    'precio': precio.isEmpty ? '0' : precio,
    'descripcionVivienda': descripcionVivienda.isEmpty
        ? 'No hay descripcion'
        : descripcionVivienda,
  };

  NetworkProfile network = NetworkProfile(url, useroomswift);
  return network.updateProfile();
}
