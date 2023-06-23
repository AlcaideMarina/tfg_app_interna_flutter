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

  const HNComponentOrders(this.orderDate, this.orderId, this.company,
      this.orderSummary, this.price, this.status, this.deliveryDni,
      {Key? key, this.onTap})
      : super(key: key);

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
                      Text(Utils().parseTimestmpToString(orderDate) ?? "", style: const TextStyle(fontSize: 11)),
                      const SizedBox(height: 4,),
                      Row(
                        children: [
                          const Text('ID Pedido: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Text(orderId.toString(), style: const TextStyle(fontSize: 15))
                        ],
                      ),
                      Text(company, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      const SizedBox(height: 12,),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: CustomColors.redGrayLightSecondaryColor,
                        margin: const EdgeInsets.only(left: 12),
                      ),
                      const SizedBox(height: 12,),
                      const Text('Resumen del pedido: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(orderSummary),
                      const SizedBox(height: 12,),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: CustomColors.redGrayLightSecondaryColor,
                        margin: const EdgeInsets.only(left: 12),
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        children: [
                          const Text("Precio: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text((price ?? "-").toString() + " €", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        ],
                      ),
                      const SizedBox(height: 4,),
                      Text(Utils().getKey(Constants().orderStatus, status)),
                      deliveryDni != null
                          ? Text("DNI de recogida: $deliveryDni")
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              onTap != null
                  ? Image.asset(
                      ImageRoutes.getRoute('ic_next_arrow'),
                      width: 16,
                      height: 24,
                    )
                  : Container()
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
