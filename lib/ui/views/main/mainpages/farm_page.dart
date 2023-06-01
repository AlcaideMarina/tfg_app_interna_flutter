import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../components/constants/hn_button.dart';
import '../../../components/menu/lateral_menu.dart';

class FarmPage extends StatefulWidget {
  const FarmPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<FarmPage> createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
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
                  "Control prod. final", null, null, () {}, () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Seg. siguación granja", null, null, () {}, () {}),
            ),
          ],
        ),
      ),
    );
  }
}