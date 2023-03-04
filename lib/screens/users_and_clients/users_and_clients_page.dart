import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/component/menu/lateral_menu.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/screens/users_and_clients/all_clientes_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

class UsersAndClientsPage extends StatefulWidget {
  UsersAndClientsPage({Key? key}) : super(key: key);

  @override
  State<UsersAndClientsPage> createState() => _UsersAndClientsPageState();
}

class _UsersAndClientsPageState extends State<UsersAndClientsPage> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print("NULO");
    } else {
      print("NO NULO");
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const LateralMenu(),
      appBar: AppBar(
        toolbarHeight: 56.0,
        title: const Text("Usuarios y clientes", 
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: CustomSizes.textSize24
          ),
        )
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Clientes", textAlign: TextAlign.start,),
            const SizedBox(height: 16,),
            Container(
              child: HNButton(ButtonTypes.mainRoundedButton).getTypedButton("Ver clientes", null, null, navigateToAllClientsPage, () { }),
            ),
            const SizedBox(height: 48,),
            const Text("Usuarios", textAlign: TextAlign.start,),
            const SizedBox(height: 16,),
            Container(
              child: Column(
                children: [
                  HNButton(ButtonTypes.mainRoundedButton).getTypedButton("Usuarios internos", null, null, () { }, () { }),
                  const SizedBox(height: 16,),
                  HNButton(ButtonTypes.mainRoundedButton).getTypedButton("Usuarios externos", null, null, () { }, () { })
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigateToAllClientsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllClientsPage(),
      ));
  }
}
