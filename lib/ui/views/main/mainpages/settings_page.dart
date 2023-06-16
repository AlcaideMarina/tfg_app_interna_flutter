import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/views/changepassword/change_password_page.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../components/component_list_data.dart';
import '../../../components/menu/lateral_menu.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late InternalUserModel currentUser;

  @override
  void  initState() {
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
          toolbarHeight: 56.0,
          title: const Text(
            "Ajustes",
            style: TextStyle(
                color: AppTheme.primary, fontSize: CustomSizes.textSize24),
          )),
      body: ListView(
          children: [
            HNComponentListData(
              "Cambiar contraseña", 
              true,
              onTap: () { 
                navegateToChangePassword(); 
              }
            ),
            const HNComponentListData(
              "Cambiar idioma", 
              false,
            ),
          ],
        )
    );
  }

  navegateToChangePassword() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: ((context) => ChangePasswordPage(currentUser))));
  }

}
