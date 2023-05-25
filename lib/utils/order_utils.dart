import 'package:hueveria_nieto_interna/data/models/local/bd_order_field_data.dart';

class OrderUtils {

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
