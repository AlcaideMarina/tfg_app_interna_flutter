import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/ui/components/menu/lateral_menu.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/ui/views/clients/all_clients_page.dart';
import 'package:hueveria_nieto_interna/ui/views/internalusers/internal_users_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

import '../../../../custom/custom_colors.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../../utils/constants.dart';
import '../../../components/component_single_table_card.dart';

class UsersAndClientsPage extends StatefulWidget {
  const UsersAndClientsPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<UsersAndClientsPage> createState() => _UsersAndClientsPageState();
}

class _UsersAndClientsPageState extends State<UsersAndClientsPage> {
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
    if (StringsTranslation.of(context) == null) {
      print("NULO");
    } else {
      print("NO NULO");
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: LateralMenu(currentUser),
      appBar: AppBar(
          toolbarHeight: 56.0,
          title: const Text(
            "Usuarios y clientes",
            style: TextStyle(
                color: AppTheme.primary, fontSize: CustomSizes.textSize24),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Table(
                children: [
                  TableRow(children: [
                    SingleTableCard(
                        Icons.person_outline_outlined,
                        CustomColors.blackColor,
                        MenuOptions.clients,
                        currentUser.id.toString(),
                        SingleTableCardPositions.leftPosition,
                        currentUser),
                    SingleTableCard(
                        Icons.person_outline_outlined,
                        CustomColors.blackColor,
                        MenuOptions.users,
                        currentUser.id.toString(),
                        SingleTableCardPositions.rightPosition,
                        currentUser)
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }

  navigateToAllClientsPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllClientsPage(currentUser),
        ));
  }

  navigateToInternalUsersPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InternalUsersPage(currentUser),
        ));
  }
}
