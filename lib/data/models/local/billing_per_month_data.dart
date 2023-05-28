import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueveria_nieto_interna/data/models/local/billing_data.dart';

class BillingPerMonthData {
  final Timestamp initDate;
  final Timestamp endDate;
  final BillingData? billingData;

  BillingPerMonthData(
    this.initDate,
    this.endDate,
    this.billingData
  );

}
