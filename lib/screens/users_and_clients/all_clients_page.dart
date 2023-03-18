import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_clients.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/screens/users_and_clients/new_client_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

class AllClientsPage extends StatefulWidget {
  AllClientsPage({Key? key}) : super(key: key);

  @override
  State<AllClientsPage> createState() => _AllClientsPageState();
}

class _AllClientsPageState extends State<AllClientsPage> {
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
      appBar: AppBar(
        toolbarHeight: 56.0,
        title: const Text("Ver clientes", 
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: CustomSizes.textSize24
          ),
        )
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 56,
              vertical: 8
            ),
            child: Column(
              children: [
                HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton("Nuevo", null, null, navigateToNewClientPage, () { }),
                const SizedBox(height: 8,),
                HNButton(ButtonTypes.grayBlackRoundedButton).getTypedButton("Cuentas eliminadas", null, null, () { }, () { })
              ],
            ),
          ),
          const SizedBox(height: 16,),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 8
            ),
            child: const HNComponentClients("0000", "Huevería Nieto", "B - 65454654", "94623"),
          ), 
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 8
            ),
            child: const HNComponentClients("0000", "Huevería Nieto", "B - 65454654", "94623"),
          )
        ],
      ),
    );
  }
  
  navigateToNewClientPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewClientPage(),
      ));
  }

}
