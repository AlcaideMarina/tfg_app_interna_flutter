import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/screens/users_and_clients/users_and_clients_page.dart';
import 'lateral_menu_header.dart';

class LateralMenu extends StatefulWidget {
  const LateralMenu({Key? key}) : super(key: key);

  @override
  State<LateralMenu> createState() => _LateralMenuState();
}

class _LateralMenuState extends State<LateralMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const LateralMenuHeader(),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio', style: TextStyle(color: CustomColors.blackColor),),
            onTap: () {
              print("Se ha pulsado el botón de inicio del menú laterla");
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_add_outlined),
            title: const Text('Pedidos y repartos'),
            onTap: () {
              print("Se ha pulsado el botón de pedidos y repartos del menú laterla");
            },
          ),
          ListTile(
            leading: const Icon(Icons.money_outlined),
            title: const Text('Economía'),
            onTap: () {
              print("Se ha pulsado el botón de economía del menú laterla");
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets_outlined),
            title: const Text('Granja'),
            onTap: () {
              print("Se ha pulsado el botón de granja del menú laterla");
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text('Material'),
            onTap: () {
              print("Se ha pulsado el botón de material del menú laterla");
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
    );
  }

  navigateToUsersAndClientsPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UsersAndClientsPage(),
      ));
  }
}