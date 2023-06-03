import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../custom/custom_colors.dart';
import '../../utils/Utils.dart';
import '../../values/image_routes.dart';

class HNComponentDayDivisionData extends StatelessWidget {
  const HNComponentDayDivisionData(this.dayOfWeek, this.timestamp, {Key? key, this.onTap}) : super(key: key);

  final String dayOfWeek;
  final Timestamp timestamp;
  final Function()? onTap;

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
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dayOfWeek + " - " + (Utils().parseTimestmpToString(timestamp, dateFormat: "dd, MMMM, yyyy") ?? "?")),
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