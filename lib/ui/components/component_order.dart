import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../custom/custom_colors.dart';
import '../../utils/Utils.dart';
import '../../utils/constants.dart';
import '../../values/image_routes.dart';

class HNComponentOrders extends StatelessWidget {

  final Timestamp orderDate;
  final int orderId;
  final String company;
  final String orderSummary;
  final double? price;
  final int status;
  final String? deliveryDni;
  final Function()? onTap;

  const HNComponentOrders(
    this.orderDate,
    this.orderId,
    this.company,
    this.orderSummary,
    this.price,
    this.status,
    this.deliveryDni,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Pedido: ' + orderId.toString()),
              Text(company),
              Text(orderSummary),
              Text("Precio: " + (price ?? "-").toString() + " €"),
              Text(Utils().getKey(Constants().orderStatus, status))
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