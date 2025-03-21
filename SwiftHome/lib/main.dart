import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:swifthome/page/login.dart';
import 'package:swifthome/page/panelAdmin.dart';
import 'package:swifthome/page/home.dart';
import 'package:swifthome/page/registration_step_third.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(), // Define el borde del campo de texto
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
          canvasColor: const Color(0xFFFDF5EC),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateColor.resolveWith((states) => Colors.black),
              foregroundColor:
                  WidgetStateColor.resolveWith((states) => Colors.white),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateColor.resolveWith(
                (states) => Colors.black,
              ),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.black,
          ),
          useMaterial3: true),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''), // Español
      ],
      //home: const LoginPage(),
      home: HomePage(
        idPersona: 1,
        buscandoPiso: true,
        isAdmin: false,
      ),

      /*home: const RegistrationStepThirdPage(
          correoElectronico: "sergio@sergio.es",
          contrasena: "1234",
          nombre: "sergio",
          apellidos: "medina",
          fechaNacimiento: "1999-01-01",
          telefono: "644343423",
          genero: "Masculino",
          ciudad: "Valladolid",
          buscandoPiso: true,
          ocupacion: "Ingeniero",
          biografia: "qwe",
          precio: "q1222",
          descripcionVivienda: "qwe"),*/

      /*home: const PanelAdminPage(
        idPersona: 1,
      ),*/
    );
  }
}
