import 'package:flutter/material.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_validation_email.dart';
import 'package:swifthome/page/login.dart';
import 'package:swifthome/page/registration_step_second.dart';
import 'package:swifthome/widget/appbarStart.dart';
import 'package:swifthome/widget/footer.dart';
import 'package:swifthome/widget/labelForm.dart';

class RegistrationStepOnePage extends StatefulWidget {
  const RegistrationStepOnePage({super.key});

  @override
  State<RegistrationStepOnePage> createState() =>
      _RegistrationStepOnePageState();
}

class _RegistrationStepOnePageState extends State<RegistrationStepOnePage> {
  final _formularioRegistroStepOne = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controllerCorreo = TextEditingController();
  final TextEditingController _controllerContrasena = TextEditingController();
  final TextEditingController _controllerConfirmarContrasena =
      TextEditingController();

  bool _obscureTextContrasena = true;
  bool _obscureTextConfirmarContrasena = true;

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
                              key: _formularioRegistroStepOne,
                              child: Column(
                                children: [
                                  Text(
                                    "Crea su cuenta en RoomSwipe",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text("Paso 1 de 3: Información de la cuenta"),
                                  labelForm(
                                    title: "Correo Electrónico",
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Por favor, introduce su correo electrónico';
                                      } else if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return 'Por favor, introduce un correo electrónico válido';
                                      }
                                      return null;
                                    },
                                    controller: _controllerCorreo,
                                    decoration: const InputDecoration(
                                      hintText:
                                          "Introduce su correo electronico...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  labelForm(
                                    title: "Contraseña",
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Por favor, introduce su contraseña';
                                      } else if (value.length < 8) {
                                        return 'La contraseña debe tener al menos 8 caracteres';
                                      } else if (!RegExp(
                                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$')
                                          .hasMatch(value)) {
                                        return 'La contraseña debe tener al menos una letra mayúscula, una letra minúscula y un número';
                                      } else if (value !=
                                          _controllerConfirmarContrasena.text) {
                                        return 'Las contraseñas no coinciden';
                                      }
                                      return null;
                                    },
                                    controller: _controllerContrasena,
                                    decoration: InputDecoration(
                                      hintText: "Introduce su contraseña...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureTextContrasena
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureTextContrasena =
                                                !_obscureTextContrasena;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: _obscureTextContrasena,
                                  ),
                                  labelForm(
                                    title: "Confirmar contraseña",
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Por favor, introduce su contraseña';
                                      } else if (value.length < 8) {
                                        return 'La contraseña debe tener al menos 8 caracteres';
                                      } else if (!RegExp(
                                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$')
                                          .hasMatch(value)) {
                                        return 'La contraseña debe tener al menos una letra mayúscula, una letra minúscula y un número';
                                      } else if (value !=
                                          _controllerContrasena.text) {
                                        return 'Las contraseñas no coinciden';
                                      }
                                      return null;
                                    },
                                    controller: _controllerConfirmarContrasena,
                                    decoration: InputDecoration(
                                      hintText: "Confirma tu contraseña...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureTextConfirmarContrasena
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureTextConfirmarContrasena =
                                                !_obscureTextConfirmarContrasena;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText:
                                        _obscureTextConfirmarContrasena,
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
                                        if (_formularioRegistroStepOne
                                            .currentState!
                                            .validate()) {
                                          if (!await validarExistenciaEmail(
                                              _controllerCorreo.text)) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationStepSecondPage(
                                                        correoElectronico:
                                                            _controllerCorreo
                                                                .text,
                                                        contrasena:
                                                            _controllerContrasena
                                                                .text
                                                                .trim()),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              barrierDismissible:
                                                  true, // Permite cerrar el diálogo tocando fuera de él
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "¡Ya existe el correo electrónico!"),
                                                  content: Text(
                                                      "El correo electrónico ingresado ya está registrado. ¿Deseas ir a la página de login?"),
                                                  actions: <Widget>[
                                                    // Botón para cerrar el diálogo
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Cierra el diálogo
                                                      },
                                                      child: Text("Cerrar"),
                                                    ),
                                                    // Botón para navegar a otra página
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Cierra el diálogo primero
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LoginPage()), // Navega a la página de login
                                                        );
                                                      },
                                                      child: Text("Ir a Login"),
                                                    ),
                                                  ],
                                                );
                                              },
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

Future<bool> validarExistenciaEmail(
  String correo,
) {
  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlExisteCorreo}';
  final emailroomswipe = {'correo': correo};
  NetworkValidationEmail network = NetworkValidationEmail(url, emailroomswipe);
  return network.fetchEmail();
}
