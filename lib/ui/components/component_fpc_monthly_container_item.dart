import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/local/monthly_fpc_container_data.dart';

import '../../custom/custom_colors.dart';
import '../../data/models/fpc_model.dart';
import '../../utils/Utils.dart';
import '../../values/image_routes.dart';

class HNComponentFPCMonthlyContainerItem extends StatelessWidget {

  final MonthlyFPCContainerData monthlyFPCContainerData;
  final Function()? onTap;

  const HNComponentFPCMonthlyContainerItem(
    this.monthlyFPCContainerData, {Key? key, this.onTap}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Text(Utils().parseTimestmpToString(monthlyFPCContainerData.initDate, dateFormat: "MMMM, yyyy") ?? ""),
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
