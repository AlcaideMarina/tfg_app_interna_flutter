import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

/// Component to use when listing all clients (e.g: AllClientsPage)

class HNComponentClients extends StatelessWidget {
  
  final String id;
  final String name;
  final String cif;
  final String actualOrder;

  const HNComponentClients(
    this.id, 
    this.name, 
    this.cif, 
    this.actualOrder, 
    {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text("Pedido actual: " + actualOrder)
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
    );
  }
}
