import 'package:flutter/material.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_users.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';
import 'package:swifthome/widget/footer.dart';

class PanelAdminPage extends StatefulWidget {
  const PanelAdminPage({super.key, required this.idPersona});

  final int idPersona;

  @override
  State<PanelAdminPage> createState() => _PanelAdminPageState();
}

class _PanelAdminPageState extends State<PanelAdminPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    getDatosUsuario().then((value) {
      if (value != null && value["status"] == 1) {
        setState(() {
          users.addAll(List<Map<String, dynamic>>.from(value["usuarios"]));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppbarAlreadyRegistered(
            namePage: 'home', idPersona: widget.idPersona),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    "Panel de Administración",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    dataRowMinHeight:
                                        80, // Altura mínima de la fila
                                    dataRowMaxHeight: 80,
                                    headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .grey, // Color del texto del encabezado
                                    ),
                                    columnSpacing: 100,
                                    border: TableBorder(
                                      horizontalInside: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    columns: [
                                      DataColumn(label: Text('ID')),
                                      DataColumn(label: Text('Nombre')),
                                      DataColumn(label: Text('Apellidos')),
                                      DataColumn(
                                          label: Text('Correo electrónico')),
                                      DataColumn(label: Text("Acciones"))
                                    ],
                                    rows: users
                                        .map(
                                          (user) => DataRow(
                                            cells: [
                                              DataCell(
                                                  Text(user['id'].toString())),
                                              DataCell(Text(user['nombre']!)),
                                              DataCell(
                                                  Text(user['apellidos']!)),
                                              DataCell(Text(user['correo']!)),
                                              DataCell(Row(
                                                spacing: 10,
                                                children: [
                                                  IconButtonPersonal(
                                                    Icon(Icons.edit),
                                                    () {
                                                      debugPrint(
                                                          'Editar usuario ${user['id']}');
                                                    },
                                                  ),
                                                  IconButtonPersonal(
                                                    Icon(Icons.delete),
                                                    () {},
                                                  ),
                                                  IconButtonPersonal(
                                                    Icon(Icons.lock),
                                                    () {
                                                      print(user['id']);
                                                    },
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Footer(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget IconButtonPersonal(Icon icon, Function() onPressed) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      style: ButtonStyle(
        side: WidgetStateProperty.all(BorderSide(
            color: Colors.grey[300]!, width: 1)), // Borde gris de 2px
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Bordes redondeados
        )),
      ),
    );
  }
}

Future<Map<String, dynamic>?> getDatosUsuario() async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlPanelUserProfile}';
  NetworkUserProfile network = NetworkUserProfile(url);
  return network.fetchUserProfile();
}
