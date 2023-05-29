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

  const HNComponentTicket(this.expenseDate, this.quantity, this.price, {Key? key, this.units, this.onTap}) : super(key: key);

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
              Text(Utils().parseTimestmpToString(expenseDate) ?? "", 
                  style: TextStyle(fontSize: 10),),
              Row(
                children: [
                  Text(quantity),
                  SizedBox(
                    width: 16,
                  ),
                  Text(units ?? ""),
                ],
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Text(price.toString() + " €"),
              SizedBox(
                width: 16,
              ),
              onTap != null ? Image.asset(
                ImageRoutes.getRoute('ic_next_arrow'), 
                width: 16,
                height: 24,)
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
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
    ));
  }
}