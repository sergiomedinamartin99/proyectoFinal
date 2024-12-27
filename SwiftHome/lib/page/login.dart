import 'package:flutter/material.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_check.dart';
import 'package:swifthome/page/registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

late TextEditingController _controladorCorreo = new TextEditingController();
late TextEditingController _controladorContrasena = new TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          child: Column(
            children: [
              Text("Correo Electronico"),
              TextField(
                controller: _controladorCorreo,
                decoration: const InputDecoration(
                  hintText: "Introduce tu Correo Electronico...",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              Text("Contraseña"),
              TextField(
                controller: _controladorContrasena,
                decoration: const InputDecoration(
                  hintText: "Introduce tu contraseña...",
                ),
                obscureText: true,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_controladorCorreo.text.trim() != "" &&
                        _controladorContrasena.text.trim() != "") {
                      if (await validarLogin(_controladorCorreo.text,
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
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      final snackBar = SnackBar(
                        content: const Text(
                            'No puedes dejar campos vacios. Por favor, rellena los campos.'),
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
                  },
                  child: Text("Iniciar Sesión")),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RegistrationPage(
                        title: "Registro",
                      ),
                    ),
                  );
                },
                child: Text("Registrarse"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> validarLogin(String nombreusuario, String contrasenya) async {
  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlLogin}';
  final user = {"correo": "${nombreusuario}", "contrasena": "${contrasenya}"};
  NetworkCheck network = NetworkCheck(url, user);
  bool data = await network.fetchData();
  debugPrint("$data");
  return data;
}
