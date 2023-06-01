import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../custom/custom_colors.dart';
import '../../data/models/fpc_model.dart';
import '../../utils/Utils.dart';
import '../../values/image_routes.dart';

class HNCompoentnFPCMonthlyContainerItem extends StatelessWidget {

  final Timestamp initDate;
  final Timestamp endDate;
  final List<FPCModel> list;
  final Function()? onTap;

  HNCompoentnFPCMonthlyContainerItem(
    this.initDate, 
    this.endDate, 
    this.list, 
    this.onTap
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Utils().parseTimestmpToString(initDate, dateFormat: "MMMM, yyyy") ?? ""),
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
