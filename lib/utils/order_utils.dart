import 'package:hueveria_nieto_interna/data/models/local/bd_order_field_data.dart';
import 'package:hueveria_nieto_interna/data/models/order_model.dart';

class OrderUtils {

  DBOrderFieldData orderDataToBDOrderModel(OrderModel orderData) {

    Map<String, Map<String, num?>> order = orderData.order;
    DBOrderFieldData dbOrderFieldData = DBOrderFieldData();

    if (order.containsKey("xl_box")) {
      Map<String, num?> xlBox = order["xl_box"]!;
      dbOrderFieldData.xlBoxPrice = xlBox["price"];
      dbOrderFieldData.xlBoxQuantity = xlBox["quantity"]!.toInt();
    }
    if (order.containsKey("xl_dozen")) {
      Map<String, num?> xlDozen = order["xl_dozen"]!;
      dbOrderFieldData.xlDozenPrice = xlDozen["price"];
      dbOrderFieldData.xlDozenQuantity = xlDozen["quantity"]!.toInt();
    }
    if (order.containsKey("l_box")) {
      Map<String, num?> lBox = order["l_box"]!;
      dbOrderFieldData.lBoxPrice = lBox["price"];
      dbOrderFieldData.lBoxQuantity = lBox["quantity"]!.toInt();
    }
    if (order.containsKey("l_dozen")) {
      Map<String, num?> lDozen = order["l_dozen"]!;
      dbOrderFieldData.lDozenPrice = lDozen["price"];
      dbOrderFieldData.lDozenQuantity = lDozen["quantity"]!.toInt();
    }
    if (order.containsKey("m_box")) {
      Map<String, num?> mBox = order["m_box"]!;
      dbOrderFieldData.mBoxPrice = mBox["price"];
      dbOrderFieldData.mBoxQuantity = mBox["quantity"]!.toInt();
    }
    if (order.containsKey("m_dozen")) {
      Map<String, num?> mDozen = order["m_dozen"]!;
      dbOrderFieldData.mDozenPrice = mDozen["price"];
      dbOrderFieldData.mDozenQuantity = mDozen["quantity"]!.toInt();
    }
    if (order.containsKey("s_box")) {
      Map<String, num?> sBox = order["s_box"]!;
      dbOrderFieldData.sBoxPrice = sBox["price"];
      dbOrderFieldData.sBoxQuantity = sBox["quantity"]!.toInt();
    }
    if (order.containsKey("s_dozen")) {
      Map<String, num?> sDozen = order["s_dozen"]!;
      dbOrderFieldData.sDozenPrice = sDozen["price"];
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

}
