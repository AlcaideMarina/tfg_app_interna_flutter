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
import 'package:hueveria_nieto_interna/values/image_routes.dart';
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
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              Container(height: 128, child: LateralMenuHeader(currentUser)),
              ListTile(
                leading: Image.asset(ImageRoutes.getRoute('ic_home'), width: 24, height: 24,),
                title: const Text(
                  'Inicio',
                  style: TextStyle(color: CustomColors.blackColor),
                ),
                onTap: () {
                  navigateToHome();
                },
              ),
              ListTile(
                leading: Image.asset(ImageRoutes.getRoute('ic_orders'), width: 24, height: 24,),
                title: const Text('Pedidos y repartos'),
                onTap: () {
                  navegateToOrderAndDelivery();
                },
              ),
              ListTile(
                leading: Image.asset(ImageRoutes.getRoute('ic_economy'), width: 24, height: 24,),
                title: const Text('Economía'),
                onTap: () {
                  navigateToEconomy();
                },
              ),
              ListTile(
                leading: Image.asset(ImageRoutes.getRoute('ic_farm'), width: 24, height: 24,),
                title: const Text('Granja'),
                onTap: () {
                  navigateToFarm();
                },
              ),
              ListTile(
                leading: Image.asset(ImageRoutes.getRoute('ic_material'), width: 24, height: 24,),
                title: const Text('Material'),
                onTap: () {
                  navigateToMaterial();
                },
              ),
              ListTile(
                leading: Image.asset(ImageRoutes.getRoute('ic_users'), width: 24, height: 24,),
                title: const Text('Usuarios y clientes'),
                onTap: () {
                  navigateToUsersAndClientsPage();
                },
              )
            ]),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: CustomColors.redPrimaryColor,
          ),
          ListTile(
            leading: Image.asset(ImageRoutes.getRoute('ic_settings'), width: 24, height: 24,),
            title: const Text('Ajustes'),
            onTap: () {
              navegateToSettings();
            },
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: CustomColors.redGraySecondaryColor,
          ),
          ListTile(
            leading: Image.asset(ImageRoutes.getRoute('ic_logout'), width: 24, height: 24,),
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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: ((context) => OrdersPage(currentUser))));
  }

  navigateToEconomy() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => EconomyPage(currentUser)));
  }

  navigateToMaterial() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MaterialAndResourcesPage(currentUser)));
  }

  navigateToFarm() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => FarmPage(currentUser)));
  }

  navigateToHome() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomePage(currentUser)));
  }

  navegateToSettings() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: ((context) => SettingsPage(currentUser))));
  }

  navegateToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => const LoginPage())));
  }
}
