import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/views/boxesandcartonsresources/all_boxes_and_cartons_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/electricitywaterfasresources/all_electricity_water_gas_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/feedresources/all_feed_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/hensresources/all_hens_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/workersresources/all_workers_resources_page.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_colors.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../../utils/constants.dart';
import '../../../components/component_single_table_card.dart';
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
            "Material",
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
                        MenuOptions.workers,
                        currentUser.id.toString(),
                        SingleTableCardPositions.leftPosition,
                        currentUser),
                    SingleTableCard(
                        Icons.person_outline_outlined,
                        CustomColors.blackColor,
                        MenuOptions.hens,
                        currentUser.id.toString(),
                        SingleTableCardPositions.rightPosition,
                        currentUser)
                  ]),
                  TableRow(children: [
                    SingleTableCard(
                        Icons.person_outline_outlined,
                        CustomColors.blackColor,
                        MenuOptions.ewg,
                        currentUser.id.toString(),
                        SingleTableCardPositions.leftPosition,
                        currentUser),
                    SingleTableCard(
                        Icons.person_outline_outlined,
                        CustomColors.blackColor,
                        MenuOptions.feed,
                        currentUser.id.toString(),
                        SingleTableCardPositions.rightPosition,
                        currentUser)
                  ]),
                ],
              ),
            ),
            SizedBox(
              width: _width / 2 - 16,
              child: SingleTableCard(
                  Icons.person_outline_outlined,
                  CustomColors.blackColor,
                  MenuOptions.boxes,
                  currentUser.id.toString(),
                  SingleTableCardPositions.centerPosition,
                  currentUser),
            ),
            const SizedBox(height: 16,)
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
