import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/local/billing_data.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
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
            style: TextStyle(fontSize: 18),
          )),
      body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              isThisMonth
                  ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        child: const Text(
                          "Esta factura es del mes vigente, por lo que no es una versión definitiva.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: CustomColors.redPrimaryColor,
                      ),
                    ])
                  : const SizedBox(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Compras al contado:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "${Utils().roundDouble(billingData.paymentByCash, 2).toString()} €",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Compras por recibo:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                        Text(
                          "${Utils().roundDouble(billingData.paymentByReceipt, 2).toString()} €",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Compras por transferencia:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                        Text(
                          "${Utils().roundDouble(billingData.paymentByTransfer, 2).toString()} €",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pagado hasta ahora:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                        Text(
                          "${Utils().roundDouble(billingData.paid, 2).toString()} €",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pendiente de pago:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                        Text(
                          "${Utils().roundDouble(billingData.toBePaid, 2).toString()} €",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: CustomColors.redGrayLightSecondaryColor,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "PRECIO TOTAL:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    Text(
                      "${Utils().roundDouble(billingData.totalPrice, 2).toString()} €",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),)
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: CustomColors.redGrayLightSecondaryColor,
              ),
            ],
          ),
        )
    );
  }
}
