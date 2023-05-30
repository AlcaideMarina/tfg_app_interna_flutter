import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/local/db_boxes_and_cartons_order_field_data.dart';

class MaterialUtils {

  String getBCOrderSummary(DBBoxesAndCartonsOrderFieldData data) {
    List<String> list = [];
    
    if(data.box != 0) list.add(data.box.toString() + " cajas");
    if(data.xlCarton != 0) list.add(data.xlCarton.toString() + " cartones XL");
    if(data.lCarton != 0) list.add(data.lCarton.toString() + " cartones L");
    if(data.mCarton != 0) list.add(data.mCarton.toString() + " cartones M");
    if(data.sCarton != 0) list.add(data.sCarton.toString() + " cartones S");

    String summary = "";
    for (String item in list) {
      summary += item;
      if (item != list[list.length - 1]) summary += " - ";
    }

    return summary;
  }

}