import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/login/login_page.dart';
import 'package:hueveria_nieto_interna/ui/views/main/main_page.dart';
import 'package:hueveria_nieto_interna/ui/views/main/mainpages/economy_page.dart';
import 'package:hueveria_nieto_interna/ui/views/main/mainpages/farm_page.dart';
import 'package:hueveria_nieto_interna/ui/views/main/mainpages/material_and_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/main/mainpages/orders_page.dart';
import 'package:hueveria_nieto_interna/ui/views/main/mainpages/settings_page.dart';
import 'package:hueveria_nieto_interna/ui/views/main/mainpages/users_and_clients_page.dart';
import 'lateral_menu_header.dart';

class LateralMenu extends StatefulWidget {
  const LateralMenu(this.currentUser, {Key? key}) : super(key: key);
  final InternalUserModel currentUser;

  @override
  State<LateralMenu> createState() => _LateralMenuState();
}

class _LateralMenuState extends State<LateralMenu> {

  late InternalUserModel currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
            Container(
              height: 128, // Establece la altura mínima deseada
              child: LateralMenuHeader(currentUser)
            ),
            ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Inicio', style: TextStyle(color: CustomColors.blackColor),),
                  onTap: () {
                    navigateToHome();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.note_add_outlined),
                  title: const Text('Pedidos y repartos'),
                  onTap: () {
                    navegateToOrderAndDelivery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money_outlined),
                  title: const Text('Economía'),
                  onTap: () {
                    navigateToEconomy();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pets_outlined),
                  title: const Text('Granja'),
                  onTap: () {
                    navigateToFarm();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book_outlined),
                  title: const Text('Material'),
                  onTap: () {
                    navigateToMaterial();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Usuarios y clientes'),
                  onTap: () {
                    navigateToUsersAndClientsPage();
                  },
                )
              ]
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: CustomColors.redPrimaryColor,
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Ajustes'),
            onTap: () async {
              navegateToSettings();
            },
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: CustomColors.redGraySecondaryColor,
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              navegateToLogin();
            },
          ),
        ],
      ),
    );
  }

  navigateToUsersAndClientsPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UsersAndClientsPage(currentUser),
      ));
  }

  navegateToOrderAndDelivery() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: ((context) => OrdersPage(currentUser))));
  }

  navigateToEconomy() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => EconomyPage(currentUser)));
  }

  navigateToMaterial() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => MaterialAndResourcesPage(currentUser)));
  }

  navigateToFarm() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => FarmPage(currentUser)));
  }

  navigateToHome() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => HomePage(currentUser)));
  }

  navegateToSettings() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: ((context) => SettingsPage(currentUser))));
  }

  navegateToLogin() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: ((context) => const LoginPage())));
  }

}
