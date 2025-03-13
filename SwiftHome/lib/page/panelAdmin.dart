import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_users.dart';
import 'package:swifthome/page/desplazar.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';
import 'package:swifthome/widget/footer.dart';

class PanelAdminPage extends StatefulWidget {
  const PanelAdminPage({super.key, required this.idPersona});

  final int idPersona;

  @override
  State<PanelAdminPage> createState() => _PanelAdminPageState();
}

class _PanelAdminPageState extends State<PanelAdminPage> {
  final ScrollController _horizontalScrollController1 = ScrollController();
  final ScrollController _horizontalScrollController2 = ScrollController();
  final List<Map<String, dynamic>> users = [];
  final List<Map<String, dynamic>> usersBlock = [];

  @override
  void initState() {
    getDatosUsuario().then((value) {
      if (value != null && value["status"] == 1) {
        setState(() {
          users.addAll(List<Map<String, dynamic>>.from(value["usuarios"]));
        });
      }
    });
    getDatosUsuarioBloqueado().then((value) {
      if (value != null && value["status"] == 1) {
        setState(() {
          usersBlock.addAll(List<Map<String, dynamic>>.from(value["usuarios"]));
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
      body: DefaultTabController(
        length: 2,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 60.0,
                          left: 64,
                          right: 64,
                          bottom: 50.0,
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 16.0,
                                      left: 15,
                                      right: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Panel de Administración",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: 350,
                                    child: TabBar(tabs: [
                                      Tab(text: 'Usuarios'),
                                      Tab(text: 'Usuarios Bloqueados'),
                                    ]),
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      // Segundo Tab: Ejemplo con DataTable
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Scrollbar(
                                          controller:
                                              _horizontalScrollController1,
                                          thumbVisibility: true,
                                          child: GestureDetector(
                                            onHorizontalDragUpdate:
                                                (DragUpdateDetails details) {
                                              _horizontalScrollController1.jumpTo(
                                                  _horizontalScrollController1
                                                          .offset -
                                                      details.delta.dx);
                                            },
                                            child: SingleChildScrollView(
                                              controller:
                                                  _horizontalScrollController1,
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                ),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: DataTable(
                                                    dataRowMinHeight: 80,
                                                    dataRowMaxHeight: 80,
                                                    headingTextStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                    columnSpacing: 100,
                                                    border: TableBorder(
                                                      horizontalInside:
                                                          BorderSide(
                                                        width: 0.5,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    columns: [
                                                      DataColumn(
                                                          label: Text('ID')),
                                                      DataColumn(
                                                          label:
                                                              Text('Nombre')),
                                                      DataColumn(
                                                          label: Text(
                                                              'Apellidos')),
                                                      DataColumn(
                                                          label: Text(
                                                              'Correo electrónico')),
                                                      DataColumn(
                                                          label:
                                                              Text("Acciones"))
                                                    ],
                                                    rows: users
                                                        .map((user) => DataRow(
                                                              cells: [
                                                                DataCell(Text(user[
                                                                        'id']
                                                                    .toString())),
                                                                DataCell(Text(user[
                                                                    'nombre']!)),
                                                                DataCell(Text(user[
                                                                    'apellidos']!)),
                                                                DataCell(Text(user[
                                                                    'correo']!)),
                                                                DataCell(Row(
                                                                  children: [
                                                                    IconButtonPersonal(
                                                                      Icon(Icons
                                                                          .edit),
                                                                      () {
                                                                        debugPrint(
                                                                            'Editar usuario ${user['id']}');
                                                                      },
                                                                    ),
                                                                    IconButtonPersonal(
                                                                      Icon(Icons
                                                                          .delete),
                                                                      () async {
                                                                        String
                                                                            contenido =
                                                                            await deleteUser(user['id'].toString());
                                                                        setState(
                                                                            () {
                                                                          users.removeWhere((element) =>
                                                                              element['id'] ==
                                                                              user['id']);
                                                                        });
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text(contenido),
                                                                            action:
                                                                                SnackBarAction(
                                                                              label: 'Cerrar',
                                                                              onPressed: () {},
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    IconButtonPersonal(
                                                                      Icon(Icons
                                                                          .lock),
                                                                      () async {
                                                                        String
                                                                            contenido =
                                                                            await blockUser(user['id'].toString());
                                                                        setState(
                                                                            () {
                                                                          users.removeWhere((element) =>
                                                                              element['id'] ==
                                                                              user['id']);
                                                                        });
                                                                        final response =
                                                                            await getDatosUsuarioBloqueado();
                                                                        if (response !=
                                                                                null &&
                                                                            response["status"] ==
                                                                                1) {
                                                                          setState(
                                                                              () {
                                                                            // Reinicia la lista con los datos actuales del API
                                                                            usersBlock.clear();
                                                                            usersBlock.addAll(List<Map<String, dynamic>>.from(response["usuarios"]));
                                                                          });
                                                                        }
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text(contenido),
                                                                            action:
                                                                                SnackBarAction(
                                                                              label: 'Cerrar',
                                                                              onPressed: () {},
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ],
                                                                )),
                                                              ],
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Scrollbar(
                                          controller:
                                              _horizontalScrollController2,
                                          thumbVisibility: true,
                                          child: GestureDetector(
                                            onHorizontalDragUpdate:
                                                (DragUpdateDetails details) {
                                              _horizontalScrollController2.jumpTo(
                                                  _horizontalScrollController2
                                                          .offset -
                                                      details.delta.dx);
                                            },
                                            child: SingleChildScrollView(
                                              controller:
                                                  _horizontalScrollController2,
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                ),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: DataTable(
                                                    dataRowMinHeight: 80,
                                                    dataRowMaxHeight: 80,
                                                    headingTextStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                    columnSpacing: 100,
                                                    border: TableBorder(
                                                      horizontalInside:
                                                          BorderSide(
                                                        width: 0.5,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    columns: [
                                                      DataColumn(
                                                          label: Text('ID')),
                                                      DataColumn(
                                                          label: Text(
                                                              'Correo electrónico')),
                                                      DataColumn(
                                                          label:
                                                              Text('Motivo')),
                                                      DataColumn(
                                                          label: Text(
                                                              'Fecha bloqueo')),
                                                      DataColumn(
                                                          label:
                                                              Text("Acciones"))
                                                    ],
                                                    rows: usersBlock
                                                        .map(
                                                            (userBlock) =>
                                                                DataRow(
                                                                  cells: [
                                                                    DataCell(Text(
                                                                        userBlock['id']
                                                                            .toString())),
                                                                    DataCell(Text(
                                                                        userBlock[
                                                                            'correo']!)),
                                                                    DataCell(Text(
                                                                        userBlock[
                                                                            'motivoBloqueo']!)),
                                                                    DataCell(Text(DateFormat(
                                                                            'dd/MM/yyyy')
                                                                        .format(
                                                                            DateTime.parse(userBlock['fechaBloqueo']!)))),
                                                                    DataCell(
                                                                        Row(
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            String
                                                                                contenido =
                                                                                await unlockUser(userBlock['id'].toString());
                                                                            setState(() {
                                                                              usersBlock.removeWhere((user) => user['id'] == userBlock['id']);
                                                                            });
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Text(contenido),
                                                                                action: SnackBarAction(
                                                                                  label: 'Cerrar',
                                                                                  onPressed: () {},
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          style:
                                                                              ButtonStyle(
                                                                            side:
                                                                                WidgetStateProperty.all(BorderSide(color: Colors.grey[300]!, width: 1)),
                                                                            shape:
                                                                                WidgetStateProperty.all(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            )),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.lock_open),
                                                                              SizedBox(width: 5),
                                                                              Text("Desbloquear"),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ],
                                                                ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
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
                    ),
                  ),
                  Footer(),
                ],
              ),
            );
          },
        ),
      ),
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

Future<Map<String, dynamic>?> getDatosUsuarioBloqueado() async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlPanelUserProfileBlock}';
  NetworkUserProfile network = NetworkUserProfile(url);
  return network.fetchUserProfile();
}

Future<String> unlockUser(String idUsuario) async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlUnlockUserRoomSwipe}';
  final user = {"idUsuario": idUsuario.toString()};
  NetworkUserProfile network = NetworkUserProfile(url, user);
  return network.unlockUser();
}

Future<String> deleteUser(String idUsuario) async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlDeleteUserRoomSwipe}';
  final user = {"idUsuario": idUsuario.toString()};
  NetworkUserProfile network = NetworkUserProfile(url, user);
  return network.deleteUser();
}

Future<String> blockUser(String idUsuario) async {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlBlockUserRoomSwipe}';
  final user = {"idUsuario": idUsuario.toString()};
  NetworkUserProfile network = NetworkUserProfile(url, user);
  return network.blockUser();
}
