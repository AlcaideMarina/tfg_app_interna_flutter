import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/views/changepassword/change_password_page.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_colors.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../components/component_list_data.dart';
import '../../../components/menu/lateral_menu.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: LateralMenu(currentUser),
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: CustomColors.whiteColor,
            ),
            toolbarHeight: 56.0,
            title: const Text(
              'Ajustes',
              style: TextStyle(fontSize: 18.0),
            )),
        body: Stack(
          children: [
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: CustomColors.redPrimaryColor,
                        ),
                        Container(
                          margin: const EdgeInsets.all(24),
                          width: double.infinity,
                          child: Column(
                            children: [
                              const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "CONTACTO",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic
                                    ),
                                  )
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: const Column(children: [
                                  SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Dirección:  ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic
                                            ),
                                          ),
                                          Flexible(
                                            child: Text("Calle Matadero 80, Bajo - 15002, A Coruña",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Teléfono:  ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic
                                            ),
                                          ),
                                          Flexible(
                                            child: Text("981204709  -  981209405",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Correo:  ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic
                                            ),
                                          ),
                                          Flexible(
                                            child: Text("hueverianieto@gmail.com",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ]),
                              )
                            ],
                          ),
                        )
                      ]),
                )),
            ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                ListTile(
                  title: const Text(
                    'Cambiar contraseña',
                    style: TextStyle(fontSize: 15),
                  ),
                  dense: true,
                  onTap: () {
                    navigateToChangePassword();
                  },
                ),
                const Divider()
              ],
            ),
          ],
        ));
  }

  navigateToChangePassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => ChangePasswordPage(currentUser))));
  }
}
