import 'package:flutter/material.dart';

import '../../custom/custom_colors.dart';
import '../../values/image_routes.dart';

class HNComponentWorker extends StatelessWidget {
  final int id;
  final String name;
  final String surname;
  final double? salary;
  final Function()? onTap;

  const HNComponentWorker(this.id, this.name, this.surname, this.salary,
      {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ' + id.toString()),
                  Text(name + " " + surname),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Text((salary ?? "-").toString() + " €"),
                  const SizedBox(
                    width: 16,
                  ),
                  onTap != null
                      ? Image.asset(
                          ImageRoutes.getRoute('ic_next_arrow'),
                          width: 16,
                          height: 24,
                        )
                      : Container()
                ],
              )
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
