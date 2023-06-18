import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueveria_nieto_interna/data/models/local/bd_order_field_data.dart';
import 'package:hueveria_nieto_interna/data/models/local/billing_data.dart';
import 'package:hueveria_nieto_interna/data/models/local/order_billing_data.dart';
import 'package:hueveria_nieto_interna/data/models/order_model.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../data/models/local/billing_per_month_data.dart';
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

  DBOrderFieldData dbOrderModelFromTwoSources(
      OrderModel orderData, EggPricesData eggPricesData) {
    Map<String, Map<String, num?>> order = orderData.order;
    DBOrderFieldData dbOrderFieldData = DBOrderFieldData();

    if (order.containsKey("xl_box")) {
      Map<String, num?> xlBox = order["xl_box"]!;
      dbOrderFieldData.xlBoxPrice = (eggPricesData.xlBox ?? 0.0).toDouble();
      dbOrderFieldData.xlBoxQuantity = xlBox["quantity"]!.toInt();
    }
    if (order.containsKey("xl_dozen")) {
      Map<String, num?> xlDozen = order["xl_dozen"]!;
      dbOrderFieldData.xlDozenPrice = (eggPricesData.xlDozen ?? 0.0).toDouble();
      dbOrderFieldData.xlDozenQuantity = xlDozen["quantity"]!.toInt();
    }
    if (order.containsKey("l_box")) {
      Map<String, num?> lBox = order["l_box"]!;
      dbOrderFieldData.lBoxPrice = (eggPricesData.lBox ?? 0.0).toDouble();
      dbOrderFieldData.lBoxQuantity = lBox["quantity"]!.toInt();
    }
    if (order.containsKey("l_dozen")) {
      Map<String, num?> lDozen = order["l_dozen"]!;
      dbOrderFieldData.lDozenPrice = (eggPricesData.lDozen ?? 0.0).toDouble();
      dbOrderFieldData.lDozenQuantity = lDozen["quantity"]!.toInt();
    }
    if (order.containsKey("m_box")) {
      Map<String, num?> mBox = order["m_box"]!;
      dbOrderFieldData.mBoxPrice = (eggPricesData.mBox ?? 0.0).toDouble();
      dbOrderFieldData.mBoxQuantity = mBox["quantity"]!.toInt();
    }
    if (order.containsKey("m_dozen")) {
      Map<String, num?> mDozen = order["m_dozen"]!;
      dbOrderFieldData.mDozenPrice = (eggPricesData.mDozen ?? 0.0).toDouble();
      dbOrderFieldData.mDozenQuantity = mDozen["quantity"]!.toInt();
    }
    if (order.containsKey("s_box")) {
      Map<String, num?> sBox = order["s_box"]!;
      dbOrderFieldData.sBoxPrice = (eggPricesData.sBox ?? 0.0).toDouble();
      dbOrderFieldData.sBoxQuantity = sBox["quantity"]!.toInt();
    }
    if (order.containsKey("s_dozen")) {
      Map<String, num?> sDozen = order["s_dozen"]!;
      dbOrderFieldData.sDozenPrice = (eggPricesData.sDozen ?? 0.0).toDouble();
      dbOrderFieldData.sDozenQuantity = sDozen["quantity"]!.toInt();
    }
    return dbOrderFieldData;
  }

  String getOrderSummary(DBOrderFieldData dbOrderFieldData) {
    List<String> list = [];

    if (dbOrderFieldData.xlBoxQuantity != null &&
        dbOrderFieldData.xlBoxQuantity != 0) {
      list.add(dbOrderFieldData.xlBoxQuantity.toString() + " cajas XL");
    }
    if (dbOrderFieldData.xlDozenQuantity != null &&
        dbOrderFieldData.xlDozenQuantity != 0) {
      list.add(dbOrderFieldData.xlDozenQuantity.toString() + " docenas XL");
    }
    if (dbOrderFieldData.lBoxQuantity != null &&
        dbOrderFieldData.lBoxQuantity != 0) {
      list.add(dbOrderFieldData.lBoxQuantity.toString() + " cajas L");
    }
    if (dbOrderFieldData.lDozenQuantity != null &&
        dbOrderFieldData.lDozenQuantity != 0) {
      list.add(dbOrderFieldData.lDozenQuantity.toString() + " docenas L");
    }
    if (dbOrderFieldData.mBoxQuantity != null &&
        dbOrderFieldData.mBoxQuantity != 0) {
      list.add(dbOrderFieldData.mBoxQuantity.toString() + " cajas M");
    }
    if (dbOrderFieldData.mDozenQuantity != null &&
        dbOrderFieldData.mDozenQuantity != 0) {
      list.add(dbOrderFieldData.mDozenQuantity.toString() + " docenas M");
    }
    if (dbOrderFieldData.sBoxQuantity != null &&
        dbOrderFieldData.sBoxQuantity != 0) {
      list.add(dbOrderFieldData.sBoxQuantity.toString() + " cajas S");
    }
    if (dbOrderFieldData.sDozenQuantity != null &&
        dbOrderFieldData.sDozenQuantity != 0) {
      list.add(dbOrderFieldData.sDozenQuantity.toString() + " docenas S");
    }

    String summary = "";
    for (var item in list) {
      summary += item;
      if (item != list[list.length - 1]) summary += " - ";
    }

    return summary;
  }

  DBOrderFieldData getOrderStructure(
      Map<String, int> productQuantities, EggPricesData eggPrices) {
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

    if (productQuantities.containsKey("xl_box") &&
        productQuantities['xl_box'] != null) {
      xlBox = productQuantities['xl_box']!;
    }
    if (productQuantities.containsKey("xl_dozen") &&
        productQuantities['xl_dozen'] != null) {
      xlDozen = productQuantities['xl_dozen']!;
    }
    if (productQuantities.containsKey("l_box") &&
        productQuantities['l_box'] != null) {
      lBox = productQuantities['l_box']!;
    }
    if (productQuantities.containsKey("l_dozen") &&
        productQuantities['l_dozen'] != null) {
      lDozen = productQuantities['l_dozen']!;
    }
    if (productQuantities.containsKey("m_box") &&
        productQuantities['m_box'] != null) {
      mBox = productQuantities['m_box']!;
    }
    if (productQuantities.containsKey("m_dozen") &&
        productQuantities['m_dozen'] != null) {
      mDozen = productQuantities['m_dozen']!;
    }
    if (productQuantities.containsKey("s_box") &&
        productQuantities['s_box'] != null) {
      sBox = productQuantities['s_box']!;
    }
    if (productQuantities.containsKey("s_dozen") &&
        productQuantities['s_dozen'] != null) {
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

  Map<String, Map<String, num>> bdOrderFieldDataToMap(DBOrderFieldData data) {
    Map<String, Map<String, num>> map = {};

    if (data.xlBoxQuantity != null && data.xlBoxPrice != null) {
      map["xl_box"] = {
        "quantity": data.xlBoxQuantity!,
        "price": data.xlBoxPrice!
      };
    }
    if (data.xlDozenQuantity != null && data.xlDozenPrice != null) {
      map["xl_dozen"] = {
        "quantity": data.xlDozenQuantity!,
        "price": data.xlDozenPrice!
      };
    }
    if (data.lBoxQuantity != null && data.lBoxPrice != null) {
      map["l_box"] = {"quantity": data.lBoxQuantity!, "price": data.lBoxPrice!};
    }
    if (data.lDozenQuantity != null && data.lDozenPrice != null) {
      map["l_dozen"] = {
        "quantity": data.lDozenQuantity!,
        "price": data.lDozenPrice!
      };
    }
    if (data.mBoxQuantity != null && data.mBoxPrice != null) {
      map["m_box"] = {"quantity": data.mBoxQuantity!, "price": data.mBoxPrice!};
    }
    if (data.mDozenQuantity != null && data.mDozenPrice != null) {
      map["m_dozen"] = {
        "quantity": data.mDozenQuantity!,
        "price": data.mDozenPrice!
      };
    }
    if (data.sBoxQuantity != null && data.sBoxPrice != null) {
      map["s_box"] = {"quantity": data.sBoxQuantity!, "price": data.sBoxPrice!};
    }
    if (data.sDozenQuantity != null && data.sDozenPrice != null) {
      map["s_dozen"] = {
        "quantity": data.sDozenQuantity!,
        "price": data.sDozenPrice!
      };
    }

    return map;
  }

  String paymentMethodIntToString(int paymentMethodInt) {
    return Utils().getKey(Constants().paymentMethods, paymentMethodInt);
  }

  int paymentMethodStringToInt(String paymentMethodStr) {
    return Constants().paymentMethods[paymentMethodStr] ?? -1;
  }

  int orderStatusStringToInt(String status) {
    return Constants().orderStatus[status] ?? -1;
  }

  String? orderStatusIntToString(int status) {
    var key = Constants()
        .orderStatus
        .keys
        .firstWhere((k) => Constants().orderStatus[k] == status);
    return key;
  }

  List<OrderBillingData> getOrderBillingData(List? mapList) {
    List<OrderBillingData> list = [];
    List<OrderModel> orderModelList = [];

    if (mapList != null) {
      for (var item in mapList) {
        if (item != null) {
          OrderModel order = OrderModel.fromMap(item.data(), item.id);
          if (order.status != Constants().orderStatus["Cancelado"]) {
            list.add(OrderBillingData(order.orderId, order.orderDatetime,
                order.paymentMethod, order.totalPrice, order.paid));
          }
        }
      }
    }

    return list;
  }

  List<BillingPerMonthData> getBillingContainerFromOrderModel(
      List<OrderBillingData> orderBillingDataList) {
    List<BillingPerMonthData> list = [];

    if (orderBillingDataList.isNotEmpty) {
      double paymentByCash = 0.0;
      double paymentByReceipt = 0.0;
      double paymentByTransfer = 0.0;
      double paid = 0.0;
      double toBePaid = 0.0;
      double totalPrice = 0.0;

      List<OrderBillingData> orderBillingDataMonthlyList = [];

      // Ordernamos la lista pro fecha de pedido en desc.
      orderBillingDataList
          .sort((a, b) => a.orderDatetime.compareTo(b.orderDatetime));

      // Cogemos la primera posición -> Es la más reciente -> Último mes
      OrderBillingData firstOrder = orderBillingDataList[0];
      DateTime firstDate = firstOrder.orderDatetime.toDate();

      String m = firstDate.month.toString();
      while (m.length < 2) {
        m = '0' + m;
      }
      String y = firstDate.year.toString();
      while (y.length < 4) {
        y = '0' + y;
      }

      // Creamos fecha inicial y final
      Timestamp initDateTimestamp = Utils().parseStringToTimestamp('01/$m/$y');
      Timestamp endDateTimestamp = Timestamp.fromDate(
          Utils().addToDate(initDateTimestamp.toDate(), monthsToAdd: 1));

      for (OrderBillingData item in orderBillingDataList) {
        if (initDateTimestamp.compareTo(item.orderDatetime) > 1) {
          // Añadimos el elemento a la list a de retorno
          BillingData billingData = BillingData(paymentByCash, paymentByReceipt,
              paymentByTransfer, paid, toBePaid, totalPrice);
          BillingPerMonthData billingContainerData = BillingPerMonthData(
              initDateTimestamp, endDateTimestamp, billingData);

          list.add(billingContainerData);
          // Reseteamos todas las variables y guardamos
          endDateTimestamp = initDateTimestamp;
          initDateTimestamp = Timestamp.fromDate(
              Utils().addToDate(initDateTimestamp.toDate(), monthsToAdd: -1));
          paymentByCash = 0.0;
          paymentByReceipt = 0.0;
          paymentByTransfer = 0.0;
          paid = 0.0;
          toBePaid = 0.0;
          totalPrice = 0.0;
          orderBillingDataMonthlyList = [];
        }

        // Actualizamos métodos de pago
        if (item.paymentMethod == 0) {
          paymentByCash += (item.totalPrice ?? 0).toDouble();
        } else if (item.paymentMethod == 0) {
          paymentByReceipt += (item.totalPrice ?? 0).toDouble();
        } else if (item.paymentMethod == 0) {
          paymentByTransfer += (item.totalPrice ?? 0).toDouble();
        }
        //Actualizamos si es un pedido pagado o por pagar
        if (item.paid) {
          paid += (item.totalPrice ?? 0).toDouble();
        } else {
          toBePaid += (item.totalPrice ?? 0).toDouble();
        }
        totalPrice += (item.totalPrice ?? 0).toDouble();
        orderBillingDataMonthlyList.add(item);

        if (orderBillingDataList.last == item) {
          BillingData billingData = BillingData(paymentByCash, paymentByReceipt,
              paymentByTransfer, paid, toBePaid, totalPrice);
          BillingPerMonthData billingPerMonthData = BillingPerMonthData(
              initDateTimestamp, endDateTimestamp, billingData);
          list.add(billingPerMonthData);
        }
      }
    }
    return list;
  }
}
