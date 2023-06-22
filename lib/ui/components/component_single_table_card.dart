import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../custom/custom_colors.dart';
import '../../data/models/internal_user_model.dart';
import '../../data/models/local/egg_prices_data.dart';
import '../../flutterfire/firebase_utils.dart';
import '../../utils/constants.dart';
import '../../values/image_routes.dart';
import '../views/boxesandcartonsresources/all_boxes_and_cartons_resources_page.dart';
import '../views/clients/all_clients_page.dart';
import '../views/clientsbilling/clients_billing_page.dart';
import '../views/electricitywaterfasresources/all_electricity_water_gas_resources_page.dart';
import '../views/feedresources/all_feed_resources_page.dart';
import '../views/finalproductcontrol/monthly_final_product_control_page.dart';
import '../views/hensresources/all_hens_resources_page.dart';
import '../views/internalusers/internal_users_page.dart';
import '../views/monitoringcompanysituation/monthly_monitoring_company_situation_page.dart';
import '../views/selingprice/selling_price_page.dart';
import '../views/workersresources/all_workers_resources_page.dart';

class SingleTableCard extends StatelessWidget {
  final IconData icono;
  final Color color;
  final MenuOptions homeMenuOption;
  final String id;
  final SingleTableCardPositions position;
  final InternalUserModel currentUser;

  const SingleTableCard(this.icono, this.color, this.homeMenuOption, this.id,
      this.position, this.currentUser,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeMenuOptionStr = Constants().mapMenuOptions[homeMenuOption];
    final image;

    if (homeMenuOption == MenuOptions.billing) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_economy'), 
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }
    else if (homeMenuOption == MenuOptions.selingPrice) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_farm'), 
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }
    else if (homeMenuOption == MenuOptions.fpc) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_fpc'),
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }
    else if (homeMenuOption == MenuOptions.mcs) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_mcs'), 
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    } 
    else if (homeMenuOption == MenuOptions.workers) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_users'), 
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }
    else if (homeMenuOption == MenuOptions.hens) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_hens'),
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }
    else if (homeMenuOption == MenuOptions.ewg) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_ewg'), 
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }
    else if (homeMenuOption == MenuOptions.feed) {
      image = Image.asset(
        ImageRoutes.getRoute('id_feed'),
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }
    else if (homeMenuOption == MenuOptions.boxes) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_box'), 
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    } 
    else if (homeMenuOption == MenuOptions.clients) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_users'), 
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    } 
    else if (homeMenuOption == MenuOptions.users) {
      image = Image.asset(
        ImageRoutes.getRoute('ic_internal_user'),
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }
    else {
      image = Image.asset(
        ImageRoutes.getRoute('ic_logo'), 
        width: 64, 
        height: 64,
        color: CustomColors.redGrayLightSecondaryColor,
      );
    }

    return Container(
      margin: position == SingleTableCardPositions.leftPosition
          ? const EdgeInsets.fromLTRB(16, 8, 8, 8)
          : position == SingleTableCardPositions.rightPosition
              ? const EdgeInsets.fromLTRB(8, 8, 16, 8)
              : const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: GestureDetector(
              child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                      color: CustomColors.redPrimaryColor,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image,
                        const SizedBox(height: 24.0),
                        Text(
                          homeMenuOptionStr ?? "",
                          style: const TextStyle(
                              color: CustomColors.redGrayLightSecondaryColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        )
                      ])),
              onTap: () async {
                if (homeMenuOption == MenuOptions.billing) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientsBillingPage(currentUser)));
                }
                else if (homeMenuOption == MenuOptions.selingPrice) {
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
                else if (homeMenuOption == MenuOptions.fpc) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MonthlyFinalProductControlPage(currentUser)));
                }
                else if (homeMenuOption == MenuOptions.mcs) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MonthlyMonitoringCompanySituationPage(currentUser)));
                } 
                else if (homeMenuOption == MenuOptions.workers) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllWorkersResources(currentUser),
                      ));
                }
                else if (homeMenuOption == MenuOptions.hens) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllHensResourcesPage(currentUser),
                      ));
                }
                else if (homeMenuOption == MenuOptions.ewg) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllElectricityWaterGasResourcesPage(currentUser),
                      ));
                }
                else if (homeMenuOption == MenuOptions.feed) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllFeedResourcesPage(currentUser),
                      ));
                }
                else if (homeMenuOption == MenuOptions.boxes) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllBoxesAndCartonsResourcesPage(currentUser),
                      ));
                } 
                else if (homeMenuOption == MenuOptions.clients) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllClientsPage(currentUser),
                      ));
                } 
                else if (homeMenuOption == MenuOptions.users) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InternalUsersPage(currentUser),
                      ));
                }
              },
            )),
      ),
    );
  }
}
