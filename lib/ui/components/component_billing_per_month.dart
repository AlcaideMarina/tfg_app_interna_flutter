import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/local/billing_per_month_data.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../custom/custom_colors.dart';
import '../../values/image_routes.dart';

class HNComponentBillingPerMonth extends StatelessWidget {

  final BillingPerMonthData billingPerMonthData;
  final Function()? onTap;

  const HNComponentBillingPerMonth(
    this.billingPerMonthData,
    {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String m = billingPerMonthData.initDate.toDate().month.toString();
    while (m.length < 2) {
      m = "0$m";
    }
    String monthInSpanish = Constants().monthInSpanish[m] ?? "mes";
    String orderDatetimeSpanish = "$monthInSpanish, ${billingPerMonthData.initDate.toDate().year}";

    return GestureDetector(
        onTap: onTap,
        child: Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderDatetimeSpanish),
            ],
          ),
          onTap != null ? Image.asset(
            ImageRoutes.getRoute('ic_next_arrow'), 
            width: 16,
            height: 24,)
          : Container()
        ],
      ),
      decoration: BoxDecoration(
        color: CustomColors.redGraySecondaryColor,
        border: Border.all(
          color: CustomColors.redGraySecondaryColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
    ));
  }

}
