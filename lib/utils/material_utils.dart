import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/boxes_and_cartons_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/local/db_boxes_and_cartons_order_field_data.dart';

class MaterialUtils {

  String getBCOrderSummary(DBBoxesAndCartonsOrderFieldData data) {
    List<String> list = [];
    
    if(data.box != null && data.box != 0) list.add(data.box.toString() + " cajas");
    if(data.xlCarton != null && data.xlCarton != 0) list.add(data.xlCarton.toString() + " cartones XL");
    if(data.lCarton != null && data.lCarton != 0) list.add(data.lCarton.toString() + " cartones L");
    if(data.mCarton != null && data.mCarton != 0) list.add(data.mCarton.toString() + " cartones M");
    if(data.sCarton != null && data.sCarton != 0) list.add(data.sCarton.toString() + " cartones S");

    String summary = "";
    for (String item in list) {
      summary += item;
      if (item != list[list.length - 1]) summary += " - ";
    }

    return summary;
  }

  DBBoxesAndCartonsOrderFieldData bcOrderToDBBoxesAndCartonsOrderModel(BoxesAndCartonsResourcesModel bcData) {
    Map<String, dynamic> order = bcData.order;
    DBBoxesAndCartonsOrderFieldData data = DBBoxesAndCartonsOrderFieldData();

    if (order.containsKey("box")) {
      data.box = order["box"];
    }
    if (order.containsKey("xl_carton")) {
      data.xlCarton = order["xl_carton"];
    }
    if (order.containsKey("l_carton")) {
      data.lCarton = order["l_carton"];
    }
    if (order.containsKey("m_carton")) {
      data.mCarton = order["m_carton"];
    }
    if (order.containsKey("s_carton")) {
      data.sCarton = order["s_carton"];
    }

    return data;
  }

}