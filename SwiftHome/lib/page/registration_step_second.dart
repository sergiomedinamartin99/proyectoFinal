import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swifthome/page/registration_step_third.dart';
import 'package:swifthome/widget/appbarStart.dart';
import 'package:swifthome/widget/footer.dart';
import 'package:swifthome/widget/labelForm.dart';

class RegistrationStepSecondPage extends StatefulWidget {
  const RegistrationStepSecondPage(
      {super.key, required this.correoElectronico, required this.contrasena});

  final String correoElectronico;
  final String contrasena;

  @override
  State<RegistrationStepSecondPage> createState() =>
      _RegistrationStepSecondPageState();
}

class _RegistrationStepSecondPageState
    extends State<RegistrationStepSecondPage> {
  List<String> genero = [
    "Masculino",
    "Femenino",
    "No binario",
  ];
  List<String> ciudades = [
    "Barcelona",
    "Madrid",
    "Valladolid",
  ];
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
  String? generoSeleccionado;
  bool? buscandoPisoSeleccionado;
  String? ciudadSeleccionada;
  DateTime? _selectedDate;
  String? ocupacionSeleccionada;

  final _formularioRegistroStepSecond = GlobalKey<FormState>();
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

  @override
  void initState() {
    ciudades.sort();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
          preferredSize: Size(20, 50),
          child: AppbarStart(
            page: 'registration',
          )),
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
                              key: _formularioRegistroStepSecond,
                              child: Column(
                                children: [
                                  Text(
                                    "Completa tu perfil",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text("Paso 2 de 3: Información personal"),
                                  labelForm(title: "Nombre"),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Por favor, introduce tu nombre';
                                      } else if (RegExp(r'\d')
                                          .hasMatch(value)) {
                                        return 'El nombre no puede contener números';
                                      }
                                      return null;
                                    },
                                    controller: _controllerNombre,
                                    decoration: const InputDecoration(
                                      hintText: "Introduce tu nombre...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
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
                                    keyboardType: TextInputType.name,
                                  ),
                                  labelForm(title: "Apellidos"),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Por favor, introduce tus apellidos';
                                      } else if (RegExp(r'\d')
                                          .hasMatch(value)) {
                                        return 'Los apellidos no pueden contener números';
                                      }
                                      return null;
                                    },
                                    controller: _controllerApellidos,
                                    decoration: const InputDecoration(
                                      hintText: "Introduce tus apellidos...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
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
                                    keyboardType: TextInputType.name,
                                  ),
                                  labelForm(title: "Fecha de nacimiento"),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Por favor, selecciona tu fecha de nacimiento';
                                      }
                                      try {
                                        DateTime selectedDate =
                                            DateFormat('dd/MM/yyyy')
                                                .parse(value);
                                        DateTime currentDate = DateTime.now();
                                        int age = currentDate.year -
                                            selectedDate.year;
                                        if (currentDate.month <
                                                selectedDate.month ||
                                            (currentDate.month ==
                                                    selectedDate.month &&
                                                currentDate.day <
                                                    selectedDate.day)) {
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
                                      hintText:
                                          "Selecciona tu fecha de nacimiento...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
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
                                      } else if (!RegExp(r'^[0-9]*$')
                                              .hasMatch(value) &&
                                          value.length == 9) {
                                        return 'Por favor, introduce un teléfono válido';
                                      }
                                      return null;
                                    },
                                    controller: _controllerTelefono,
                                    decoration: const InputDecoration(
                                      hintText: "Introduce tu teléfono...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
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
                                    keyboardType: TextInputType.phone,
                                  ),
                                  labelForm(title: "Genero"),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
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
                                    alignment: Alignment.topLeft,
                                    child: DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
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
                                    alignment: Alignment.topLeft,
                                    child: DropdownButtonFormField<bool>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
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
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Por favor, selecciona el tipo de búsqueda';
                                        }
                                        return null;
                                      },
                                      value: buscandoPisoSeleccionado,
                                      hint: Text(
                                          "Selecciona el tipo de búsqueda"),
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

                                  // AQUI ES METER NUEVAS COSAS
                                  buscandoPisoSeleccionado == true
                                      ? Column(
                                          children: [
                                            labelForm(title: "Ocupación"),
                                            // EDITAR
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: DropdownButtonFormField<
                                                  String>(
                                                dropdownColor: Colors.white,
                                                isExpanded: true,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
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
                                                hint: Text(
                                                    "Selecciona tu ocupaación"),
                                                items: ocupaciones
                                                    .map((String ocupaciones) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: ocupaciones,
                                                    child: Text(ocupaciones),
                                                  );
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    if (value != null) {
                                                      ocupacionSeleccionada =
                                                          value;
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
                                                hintText:
                                                    "Introduce tu biografía...",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.multiline,
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
                                                    } else if (!RegExp(
                                                            r'^[0-9]*$')
                                                        .hasMatch(value)) {
                                                      return 'Por favor, introduce un precio válido sin puntos ni decimales';
                                                    }
                                                    return null;
                                                  },
                                                  controller: _controllerPrecio,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "Introduce el precio de la vivienda...",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                labelForm(
                                                    title:
                                                        "Descripción de la vivienda"),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Por favor, introduce la descripción de la vivienda';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      _controllerDescripcionVivienda,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "Introduce la descripción de la vivienda...",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.multiline,
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        minimumSize: Size(double.infinity, 50),
                                      ),
                                      onPressed: () async {
                                        if (_formularioRegistroStepSecond
                                            .currentState!
                                            .validate()) {
                                          if (buscandoPisoSeleccionado ==
                                              true) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationStepThirdPage(
                                                  correoElectronico:
                                                      widget.correoElectronico,
                                                  contrasena: widget.contrasena,
                                                  nombre: _controllerNombre.text
                                                      .trim(),
                                                  apellidos:
                                                      _controllerApellidos.text
                                                          .trim(),
                                                  fechaNacimiento:
                                                      _controllerFechaNacimiento
                                                          .text,
                                                  telefono: _controllerTelefono
                                                      .text
                                                      .trim(),
                                                  genero: generoSeleccionado!,
                                                  ciudad: ciudadSeleccionada!,
                                                  buscandoPiso:
                                                      buscandoPisoSeleccionado!,
                                                  ocupacion:
                                                      ocupacionSeleccionada!,
                                                  biografia:
                                                      _controllerBiografia.text
                                                          .trim(),
                                                  precio: "",
                                                  descripcionVivienda: "",
                                                ),
                                              ),
                                            );
                                          } else if (buscandoPisoSeleccionado ==
                                              false) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationStepThirdPage(
                                                  correoElectronico:
                                                      widget.correoElectronico,
                                                  contrasena: widget.contrasena,
                                                  nombre: _controllerNombre.text
                                                      .trim(),
                                                  apellidos:
                                                      _controllerApellidos.text
                                                          .trim(),
                                                  fechaNacimiento:
                                                      _controllerFechaNacimiento
                                                          .text,
                                                  telefono: _controllerTelefono
                                                      .text
                                                      .trim(),
                                                  genero: generoSeleccionado!,
                                                  ciudad: ciudadSeleccionada!,
                                                  buscandoPiso:
                                                      buscandoPisoSeleccionado!,
                                                  ocupacion: "",
                                                  biografia: "",
                                                  precio: _controllerPrecio.text
                                                      .trim(),
                                                  descripcionVivienda:
                                                      _controllerDescripcionVivienda
                                                          .text
                                                          .trim(),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Text("Siguiente"),
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
