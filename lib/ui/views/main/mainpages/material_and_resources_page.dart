import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/views/boxesandcartonsresources/all_boxes_and_cartons_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/electricitywaterfasresources/all_electricity_water_gas_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/feedresources/all_feed_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/hensresources/all_hens_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/workersresources/all_workers_resources_page.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../components/constants/hn_button.dart';
import '../../../components/menu/lateral_menu.dart';

class MaterialAndResourcesPage extends StatefulWidget {
  const MaterialAndResourcesPage(this.currentUser, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<MaterialAndResourcesPage> createState() =>
      _MaterialAndResourcesPageState();
}

class _MaterialAndResourcesPageState extends State<MaterialAndResourcesPage> {
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
                  "Trabajadores y sueldos",
                  null,
                  null,
                  navigateToWorkerResources,
                  () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Gallinas", null, null, navigateToHensResources, () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Luz, agua, gas", null, null, navigateToEWGResources, () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Pienso", null, null, navigateToFeedResources, () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Cajas y cartones",
                  null,
                  null,
                  navigateToBoxesAndCartonsResources,
                  () {}),
            ),
          ],
        ),
      ),
    );
  }

  navigateToWorkerResources() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllWorkersResources(currentUser),
        ));
  }

  navigateToHensResources() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllHensResourcesPage(currentUser),
        ));
  }

  navigateToEWGResources() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AllElectricityWaterGasResourcesPage(currentUser),
        ));
  }

  navigateToFeedResources() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllFeedResourcesPage(currentUser),
        ));
  }

  navigateToBoxesAndCartonsResources() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllBoxesAndCartonsResourcesPage(currentUser),
        ));
  }
}
