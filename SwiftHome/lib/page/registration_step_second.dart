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
  String? generoSeleccionado;
  bool? buscandoPisoSeleccionado;
  String? ciudadSeleccionada;
  DateTime? _selectedDate;

  final _formularioRegistroStepSecond = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controllerNombre = TextEditingController();
  final TextEditingController _controllerApellidos = TextEditingController();
  final TextEditingController _controllerFechaNacimiento =
      TextEditingController();
  final TextEditingController _controllerTelefono = TextEditingController();
  final TextEditingController _controllerBiografia = TextEditingController();

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
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  labelForm(title: "Genero"),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: DropdownButtonFormField<String>(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        minimumSize: Size(double.infinity, 50),
                                      ),
                                      onPressed: () async {
                                        if (_formularioRegistroStepSecond
                                            .currentState!
                                            .validate()) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationStepThirdPage(
                                                correoElectronico:
                                                    widget.correoElectronico,
                                                contrasena: widget.contrasena,
                                                nombre: _controllerNombre.text
                                                    .trim(),
                                                apellidos: _controllerApellidos
                                                    .text
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
                                                biografia: _controllerBiografia
                                                    .text
                                                    .trim(),
                                              ),
                                            ),
                                          );
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
