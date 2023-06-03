import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/custom_colors.dart';
import '../../../values/image_routes.dart';


class HNComponentWeekDivisionData extends StatelessWidget {

  final Timestamp initTimestamp;
  final Timestamp endTimestamp;
  final Function()? onTap;

  const HNComponentWeekDivisionData(
    this.initTimestamp,
    this.endTimestamp, 
    {Key? key, this.onTap}) : super(key: key);

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
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (Utils().parseTimestmpToString(initTimestamp) ?? "?") 
                        + " - " 
                        + (Utils().parseTimestmpToString(endTimestamp) ?? "?")
                      ),
                    ],
                  ),
                ),
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
        )
    );
  }

}
