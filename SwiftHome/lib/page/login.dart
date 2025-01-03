import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_check.dart';
import 'package:swifthome/page/registration_step_one.dart';
import 'package:swifthome/widget/appbarStart.dart';
import 'package:swifthome/widget/footer.dart';
import 'package:swifthome/widget/labelForm.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController _controladorCorreo = TextEditingController();
TextEditingController _controladorContrasena = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  final ScrollController _scrollController = ScrollController();
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
                              child: Column(
                                children: [
                                  Text(
                                    "Iniciar sesión en RoomSwipe",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                      "Ingresa tus credenciales para acceder a tu cuenta"),
                                  labelForm(
                                    title: "Correo electrónico",
                                  ),
                                  TextField(
                                    controller: _controladorCorreo,
                                    decoration: const InputDecoration(
                                      hintText:
                                          "Introduce su correo electrónico...",
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
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  labelForm(
                                    title: "Contraseña",
                                  ),
                                  TextField(
                                    controller: _controladorContrasena,
                                    decoration: const InputDecoration(
                                      hintText: "Introduce su contraseña...",
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
                                    obscureText: true,
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
                                        if (_controladorCorreo.text.trim() !=
                                                "" &&
                                            _controladorContrasena.text
                                                    .trim() !=
                                                "") {
                                          if (await validarLogin(
                                              _controladorCorreo.text,
                                              _controladorContrasena.text)) {
                                            /** 
                        setState(() {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => PruebaPage(
                                        title: "prueba",
                                      )));
                        });
                        */
                                          } else {
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  'Correo y/o contraseña incorrectos. Por favor, vuelve a intentarlo.'),
                                              action: SnackBarAction(
                                                label: 'Cerrar',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        } else {
                                          final snackBar = SnackBar(
                                            content: const Text(
                                                'No puedes dejar campos vacios. Por favor, rellena los campos.'),
                                            action: SnackBarAction(
                                              label: 'Cerrar',
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: Text("Iniciar Sesión"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: '¿No tienes una cuenta? ',
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Regístrate aquí',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegistrationStepOnePage()),
                                                );
                                              },
                                          ),
                                        ],
                                      ),
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

Future<bool> validarLogin(String nombreusuario, String contrasenya) async {
  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlLogin}';
  final user = {"correo": nombreusuario, "contrasena": contrasenya};
  NetworkCheck network = NetworkCheck(url, user);
  bool data = await network.fetchData();
  debugPrint("$data");
  return data;
}
