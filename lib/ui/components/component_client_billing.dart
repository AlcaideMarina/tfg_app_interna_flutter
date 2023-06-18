import 'package:flutter/material.dart';

import '../../custom/custom_colors.dart';
import '../../values/image_routes.dart';

class HNComponentClientBilling extends StatelessWidget {
  final String id;
  final String company;
  final Function()? onTap;

  const HNComponentClientBilling(this.id, this.company, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('ID: ' + id), Text(company)],
              ),
              onTap != null
                  ? Image.asset(
                      ImageRoutes.getRoute('ic_next_arrow'),
                      width: 16,
                      height: 24,
                    )
                  : Container()
            ],
          ),
          decoration: BoxDecoration(
              color: CustomColors.redGraySecondaryColor,
              border: Border.all(
                color: CustomColors.redGraySecondaryColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ));
  }
}
