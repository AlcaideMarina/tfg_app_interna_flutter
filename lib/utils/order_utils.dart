import 'package:hueveria_nieto_interna/data/models/local/bd_order_field_data.dart';
import 'package:hueveria_nieto_interna/data/models/order_model.dart';

import '../data/models/local/egg_prices_data.dart';

class OrderUtils {

  DBOrderFieldData orderDataToBDOrderModel(OrderModel orderData) {

    Map<String, Map<String, num?>> order = orderData.order;
    DBOrderFieldData dbOrderFieldData = DBOrderFieldData();

    if (order.containsKey("xl_box")) {
      Map<String, num?> xlBox = order["xl_box"]!;
      dbOrderFieldData.xlBoxPrice = xlBox["price"]?.toDouble();
      dbOrderFieldData.xlBoxQuantity = xlBox["quantity"]!.toInt();
    }
    if (order.containsKey("xl_dozen")) {
      Map<String, num?> xlDozen = order["xl_dozen"]!;
      dbOrderFieldData.xlDozenPrice = xlDozen["price"]?.toDouble();
      dbOrderFieldData.xlDozenQuantity = xlDozen["quantity"]!.toInt();
    }
    if (order.containsKey("l_box")) {
      Map<String, num?> lBox = order["l_box"]!;
      dbOrderFieldData.lBoxPrice = lBox["price"]?.toDouble();
      dbOrderFieldData.lBoxQuantity = lBox["quantity"]!.toInt();
    }
    if (order.containsKey("l_dozen")) {
      Map<String, num?> lDozen = order["l_dozen"]!;
      dbOrderFieldData.lDozenPrice = lDozen["price"]?.toDouble();
      dbOrderFieldData.lDozenQuantity = lDozen["quantity"]!.toInt();
    }
    if (order.containsKey("m_box")) {
      Map<String, num?> mBox = order["m_box"]!;
      dbOrderFieldData.mBoxPrice = mBox["price"]?.toDouble();
      dbOrderFieldData.mBoxQuantity = mBox["quantity"]!.toInt();
    }
    if (order.containsKey("m_dozen")) {
      Map<String, num?> mDozen = order["m_dozen"]!;
      dbOrderFieldData.mDozenPrice = mDozen["price"]?.toDouble();
      dbOrderFieldData.mDozenQuantity = mDozen["quantity"]!.toInt();
    }
    if (order.containsKey("s_box")) {
      Map<String, num?> sBox = order["s_box"]!;
      dbOrderFieldData.sBoxPrice = sBox["price"]?.toDouble();
      dbOrderFieldData.sBoxQuantity = sBox["quantity"]!.toInt();
    }
    if (order.containsKey("s_dozen")) {
      Map<String, num?> sDozen = order["s_dozen"]!;
      dbOrderFieldData.sDozenPrice = sDozen["price"]?.toDouble();
      dbOrderFieldData.sDozenQuantity = sDozen["quantity"]!.toInt();
    }
    return dbOrderFieldData;

  }

  String getOrderSummary(DBOrderFieldData dbOrderFieldData) {

    List<String> list = [];

    if (dbOrderFieldData.xlBoxQuantity != 0) list.add(dbOrderFieldData.xlBoxQuantity.toString() + " cajas XL");
    if (dbOrderFieldData.xlDozenQuantity != 0) list.add(dbOrderFieldData.xlDozenQuantity.toString() + " docenas XL");
    if (dbOrderFieldData.lBoxQuantity != 0) list.add(dbOrderFieldData.lBoxQuantity.toString() + " cajas L");
    if (dbOrderFieldData.lDozenQuantity != 0) list.add(dbOrderFieldData.lDozenQuantity.toString() + " docenas L");
    if (dbOrderFieldData.mBoxQuantity != 0) list.add(dbOrderFieldData.mBoxQuantity.toString() + " cajas M");
    if (dbOrderFieldData.mDozenQuantity != 0) list.add(dbOrderFieldData.mDozenQuantity.toString() + " docenas M");
    if (dbOrderFieldData.sBoxQuantity != 0) list.add(dbOrderFieldData.sBoxQuantity.toString() + " cajas S");
    if (dbOrderFieldData.sDozenQuantity != 0) list.add(dbOrderFieldData.sDozenQuantity.toString() + " docenas S");

    String summary = "";
    for (var item in list) {
      summary += item;
      if (item != list[list.length - 1]) summary += " - ";
    }

    return summary;
  }

  DBOrderFieldData getOrderStructure(Map<String, int> productQuantities, EggPricesData eggPrices) {
    int xlBox = 0;
    int xlBoxPrice = 0;
    int xlDozen = 0;
    int xlDozenPrice = 0;
    int lBox = 0;
    int lBoxPrice = 0;
    int lDozen = 0;
    int lDozenPrice = 0;
    int mBox = 0;
    int mBoxPrice = 0;
    int mDozen = 0;
    int mDozenPrice = 0;
    int sBox = 0;
    int sBoxPrice = 0;
    int sDozen = 0;
    int sDozenPrice = 0;

    if (productQuantities.containsKey("xl_box") && productQuantities['xl_box'] != null){
      xlBox = productQuantities['xl_box']!;

    }
    if (productQuantities.containsKey("xl_dozen") && productQuantities['xl_dozen'] != null){
      xlDozen = productQuantities['xl_dozen']!;
    }
    if (productQuantities.containsKey("l_box") && productQuantities['l_box'] != null){
      lBox = productQuantities['l_box']!;
    }
    if (productQuantities.containsKey("l_dozen") && productQuantities['l_dozen'] != null){
      lDozen = productQuantities['l_dozen']!;
    }
    if (productQuantities.containsKey("m_box") && productQuantities['m_box'] != null){
      mBox = productQuantities['m_box']!;
    }
    if (productQuantities.containsKey("m_dozen") && productQuantities['m_dozen'] != null){
      mDozen = productQuantities['m_dozen']!;
    }
    if (productQuantities.containsKey("s_box") && productQuantities['s_box'] != null){
      sBox = productQuantities['s_box']!;
    }
    if (productQuantities.containsKey("s_dozen") && productQuantities['s_dozen'] != null){
      sDozen = productQuantities['s_dozen']!;
    }

    return DBOrderFieldData(
      xlBoxPrice: xlBox == 0 ? null : eggPrices.xlBox!.toDouble(),
      xlBoxQuantity: xlBox,
      xlDozenPrice: xlDozen == 0 ? null : eggPrices.xlDozen!.toDouble(),
      xlDozenQuantity: xlDozen,
      lBoxPrice: lBox == 0 ? null : eggPrices.lBox!.toDouble(),
      lBoxQuantity: lBox,
      lDozenPrice: lDozen == 0 ? null : eggPrices.lDozen!.toDouble(),
      lDozenQuantity: lDozen,
      mBoxPrice: mBox == 0 ? null : eggPrices.mBox!.toDouble(),
      mBoxQuantity: mBox,
      mDozenPrice: mDozen == 0 ? null : eggPrices.mDozen!.toDouble(),
      mDozenQuantity: mDozen,
      sBoxPrice: sBox == 0 ? null : eggPrices.sBox!.toDouble(),
      sBoxQuantity: sBox,
      sDozenPrice: sDozen == 0 ? null : eggPrices.sDozen!.toDouble(),
      sDozenQuantity: sDozen,
    );
  }

}
