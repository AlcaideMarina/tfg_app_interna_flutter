import 'package:cloud_firestore/cloud_firestore.dart';

import '../fpc_model.dart';

class MonthlyFPCContainerData {
  
  final Timestamp initDate;
  final Timestamp endDate;
  final List<FPCModel> list;

  MonthlyFPCContainerData(this.initDate, this.endDate, this.list);

}