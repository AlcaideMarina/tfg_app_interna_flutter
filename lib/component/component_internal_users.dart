import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

/// Component to use when listing all clients (e.g: AllClientsPage)

class HNComponentInternalUsers extends StatelessWidget {
  
  final String id;
  final String name;
  final String dni;
  final int jobPosition;
  final Function()? onTap;

  const HNComponentInternalUsers(
    this.id, 
    this.name, 
    this.dni, 
    this.jobPosition, 
    {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: onTap,
        child: Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id),
              Text(name),
              Text("DNI: " + dni),
              Text("Puesto: " + jobPosition.toString()) // TODO: Sacar equivalencia del puesto por bbdd
            ],
          ),
          // TODO: Cambiar icono - creo que se va a tener que importar
          const Icon(Icons.arrow_right_alt_outlined)
        ],
      ),
      decoration: BoxDecoration(
        color: CustomColors.redGraySecondaryColor,
        border: Border.all(
          color: CustomColors.redGraySecondaryColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
    ));
  }
}
