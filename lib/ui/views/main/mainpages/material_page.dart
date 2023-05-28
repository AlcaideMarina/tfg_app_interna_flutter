import 'package:flutter/material.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../components/constants/hn_button.dart';
import '../../../components/menu/lateral_menu.dart';

class MaterialPage extends StatefulWidget {
  const MaterialPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<MaterialPage> createState() => _MaterialPageState();
}

class _MaterialPageState extends State<MaterialPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: LateralMenu(currentUser),
      appBar: AppBar(
          toolbarHeight: 56.0,
          title: const Text(
            "Material",
            style: TextStyle(
                color: AppTheme.primary, fontSize: CustomSizes.textSize24),
          )),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Trabajadores y sueldos", null, null, () {}, () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Gallinas", null, null, () {}, () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Luz, agua, gas", null, null, () {}, () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Pienso", null, null, () {}, () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Cajas y cartones", null, null, () {}, () {}),
            ),
          ],
        ),
      ),
    );
  }
}