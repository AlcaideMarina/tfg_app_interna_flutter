import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/local/egg_prices_data.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';
import 'package:hueveria_nieto_interna/ui/views/clientsbilling/clients_billing_page.dart';
import 'package:hueveria_nieto_interna/ui/views/selingprice/selling_price_page.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_colors.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../../utils/constants.dart';
import '../../../components/component_single_table_card.dart';
import '../../../components/constants/hn_button.dart';
import '../../../components/menu/lateral_menu.dart';

class EconomyPage extends StatefulWidget {
  const EconomyPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<EconomyPage> createState() => _EconomyPageState();
}

class _EconomyPageState extends State<EconomyPage> {
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
            "Economía",
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
                        MenuOptions.billing,
                        currentUser.id.toString(),
                        SingleTableCardPositions.leftPosition,
                        currentUser),
                    SingleTableCard(
                        Icons.person_outline_outlined,
                        CustomColors.blackColor,
                        MenuOptions.selingPrice,
                        currentUser.id.toString(),
                        SingleTableCardPositions.rightPosition,
                        currentUser)
                  ]),
                ],
              ),
            ),
            SizedBox(height: 16,)
          ],
        ),
      ),
    );
      
      
      
      
     /* Container(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Facturación de clientes",
                  null,
                  null,
                  navigateToBilling,
                  () {}),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              child: HNButton(ButtonTypes.redWhiteRoundedButton).getTypedButton(
                  "Precio de venta", null, null, navigateToSellingPrice, () {}),
            ),
          ],
        ),
      ),
    );*/
  }

  navigateToSellingPrice() async {
    var futureEggPrices = await FirebaseUtils.instance.getEggPrices();
    EggPricesData eggPricesData = EggPricesData(0, 0, 0, 0, 0, 0, 0, 0);
    if (futureEggPrices.docs.isNotEmpty) {
      Map<String, dynamic> valuesMap = futureEggPrices.docs[0].data()["values"];
      eggPricesData = EggPricesData(
          valuesMap['xl_box'],
          valuesMap['xl_dozen'],
          valuesMap['l_box'],
          valuesMap['l_dozen'],
          valuesMap['m_box'],
          valuesMap['m_dozen'],
          valuesMap['s_box'],
          valuesMap['s_dozen']);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SellingPricePage(currentUser, eggPricesData)));
  }

  navigateToBilling() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClientsBillingPage(currentUser)));
  }
}
