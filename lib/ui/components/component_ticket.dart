import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../custom/custom_colors.dart';
import '../../values/image_routes.dart';

class HNComponentTicket extends StatelessWidget {
  final Timestamp expenseDate;
  final String quantity;
  final String? units;
  final double price;
  final Function()? onTap;

  const HNComponentTicket(this.expenseDate, this.quantity, this.price,
      {Key? key, this.units, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget element;
    if (units != null && units != "") {
      element = Row(
        children: [
          Text(quantity, style: const TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(
            width: 12,
          ),
          Text(units ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    } else {
      element = Text(quantity, style: const TextStyle(fontWeight: FontWeight.bold));
    }

    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils().parseTimestmpToString(expenseDate) ?? "",
                      style: const TextStyle(fontSize: 11),
                    ),
                    element
                  ],
                ),
              ),
              Container(
                height: 35,
                width: 1,
                color: CustomColors.redGrayLightSecondaryColor,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Text(price.toString() + " €", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 24,
                  ),
                  onTap != null
                      ? Image.asset(
                          ImageRoutes.getRoute('ic_next_arrow'),
                          width: 16,
                          height: 24,
                        )
                      : Container()
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
              color: CustomColors.redGraySecondaryColor,
              border: Border.all(
                color: CustomColors.redGraySecondaryColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ));
  }
}
