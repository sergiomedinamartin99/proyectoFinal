import 'package:flutter/material.dart';
import 'package:swifthome/page/home.dart';
import 'package:swifthome/page/login.dart';
import 'package:swifthome/page/registration_step_one.dart';
import 'package:swifthome/widget/appbarStart.dart';
import 'package:swifthome/widget/footer.dart';
import 'package:swifthome/widget/labelForm.dart';
import 'package:swifthome/widget/snackBar_%20personalized.dart';

class LeadingPage extends StatefulWidget {
  const LeadingPage({super.key});

  @override
  State<LeadingPage> createState() => _LeadingPageState();
}

class _LeadingPageState extends State<LeadingPage> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController _controladorCorreo = TextEditingController();
  TextEditingController _controladorContrasena = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppbarStart(page: "leading")),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: MediaQuery.of(context).size.height * 0.07,
                  ),
                  width: double.infinity,
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Descubre el hogar perfecto para ti",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "RoomSwipe te ayuda a encontrar el piso perfecto de una manera fácil y divertida. ¡Desliza, haz match y encuentra tu nuevo hogar!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 8.0,
                        spacing: 16.0,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 180.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationStepOnePage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                              ),
                              child: Text("Registrarse"),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 180.0),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey.shade300,
                                      title: Text("Inicio de sesión"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Form(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      "Ingresa tus credenciales para acceder a tu cuenta"),
                                                  labelForm(
                                                    title: "Correo electrónico",
                                                  ),
                                                  TextField(
                                                    controller:
                                                        _controladorCorreo,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          "Introduce su correo electrónico...",
                                                      border:
                                                          OutlineInputBorder(
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
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                  ),
                                                  labelForm(
                                                    title: "Contraseña",
                                                  ),
                                                  TextField(
                                                    controller:
                                                        _controladorContrasena,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          "Introduce su contraseña...",
                                                      border:
                                                          OutlineInputBorder(
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
                                                    obscureText: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cerrar"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_controladorCorreo.text
                                                        .trim() !=
                                                    "" &&
                                                _controladorContrasena.text
                                                        .trim() !=
                                                    "") {
                                              Map<String, dynamic>? check =
                                                  await validarLogin(
                                                      _controladorCorreo.text,
                                                      _controladorContrasena
                                                          .text);

                                              if (check != null) {
                                                if (check['status'] == 1) {
                                                  SnackbarPersonalized(
                                                          title:
                                                              check['mensaje'])
                                                      .show(context);
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(
                                                        idPersona:
                                                            check['usuarioId'],
                                                      ),
                                                    ),
                                                    (Route<dynamic> route) =>
                                                        false,
                                                  );
                                                } else {
                                                  SnackbarPersonalized(
                                                          title:
                                                              check['mensaje'])
                                                      .show(context);
                                                }
                                              } else {
                                                SnackbarPersonalized(
                                                        title:
                                                            'Error en la conexión. Por favor, inténtalo de nuevo.')
                                                    .show(context);
                                              }
                                            } else {
                                              SnackbarPersonalized(
                                                      title:
                                                          'No puedes dejar campos vacíos. Por favor, rellena los campos.')
                                                  .show(context);
                                            }
                                          },
                                          child: Text("Iniciar sesión"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                              ),
                              child: Text("Iniciar sesión"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: MediaQuery.of(context).size.height * 0.06,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "¿Por qué elegir RoomSwipe?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 16.0,
                        spacing: 16.0,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.home_outlined,
                                      size: 50,
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Encuentra tu hogar ideal",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Flexible(
                                      child: Text(
                                        "Explora opciones de alquiler diseñadas para adaptarse a tu estilo de vida y presupuesto.",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Repite para los demás SizedBox
                        ],
                      ),
                    ],
                  ),
                ),
                Footer(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
