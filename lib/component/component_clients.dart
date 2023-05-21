import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

/// Component to use when listing all clients (e.g: AllClientsPage)

class HNComponentClients extends StatelessWidget {
  
  final String id;
  final String name;
  final String cif;
  final Function()? onTap;
  // TODO: Falta por añadir en onClick

  const HNComponentClients(
    this.id, 
    this.name, 
    this.cif, 
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
              Text("CIF: " + cif),
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
