import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/utils/Utils.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';

import '../../values/image_routes.dart';

/// Component to use when listing all clients (e.g: AllClientsPage)

class HNComponentInternalUsers extends StatelessWidget {
  final String id;
  final String name;
  final String dni;
  final int jobPosition;
  final Function()? onTap;

  const HNComponentInternalUsers(this.id, this.name, this.dni, this.jobPosition,
      {Key? key, this.onTap})
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
                children: [
                  Row(
                    children: [
                      const Text('ID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      const SizedBox(width: 8,),
                      Text(id, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Container(
                    width: 220, 
                    height: 1, 
                    color: CustomColors.redGrayLightSecondaryColor,
                  ),
                  const SizedBox(height: 8,),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      const Text("DNI:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 8,),
                      Text(dni, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Container(
                    width: 220, 
                    height: 1, 
                    color: CustomColors.redGrayLightSecondaryColor,
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      const Text("Puesto:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 8,),
                      Text(Utils().getKey(Constants().roles, jobPosition), style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
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
