import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/local/billing_data.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';

class MonthlyBillingDetailPage extends StatefulWidget {
  const MonthlyBillingDetailPage(
      this.currentUser, this.billingData, this.isThisMonth,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final BillingData billingData;
  final bool isThisMonth;

  @override
  State<MonthlyBillingDetailPage> createState() =>
      _MonthlyBillingDetailPageState();
}

class _MonthlyBillingDetailPageState extends State<MonthlyBillingDetailPage> {
  late InternalUserModel currentUser;
  late BillingData billingData;
  late bool isThisMonth;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    billingData = widget.billingData;
    isThisMonth = widget.isThisMonth;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 56.0,
          title: const Text(
            "Detalle de facturación",
            style: TextStyle(
                color: AppTheme.primary, fontSize: CustomSizes.textSize24),
          )),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Column(
          children: [
            isThisMonth
                ? Text(
                    'Esta factura es del mes vigente, por lo que no es una versión definitiva.')
                : Container(),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pagos al contado:'),
                Text(Utils()
                        .roundDouble(billingData.paymentByCash, 2)
                        .toString() +
                    "€")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pagos por recibo:'),
                Text(Utils()
                        .roundDouble(billingData.paymentByReceipt, 2)
                        .toString() +
                    "€")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pagos por transferencia:'),
                Text(Utils()
                        .roundDouble(billingData.paymentByTransfer, 2)
                        .toString() +
                    "€")
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pagado hasta ahora:'),
                Text(Utils().roundDouble(billingData.paid, 2).toString() + "€")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pendiente de pago:'),
                Text(Utils().roundDouble(billingData.toBePaid, 2).toString() +
                    "€")
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pago total:'),
                Text(Utils().roundDouble(billingData.totalPrice, 2).toString() +
                    "€")
              ],
            )
          ],
        ),
      ),
    );
  }
}
