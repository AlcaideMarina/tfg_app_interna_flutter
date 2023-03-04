import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_text_input.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

class NewClientPage extends StatefulWidget {
  NewClientPage({Key? key}) : super(key: key);

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print("NULO");
    } else {
      print("NO NULO");
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 56.0,
        title: const Text("Nuevo cliente", 
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: CustomSizes.textSize24
          ),
        )
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ID: '),
                  const SizedBox(height: 16,),
                  const Text('Empresa:'),
                  const SizedBox(height: 8,),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HNComponentTextInput(contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),),
                  ),
                  const SizedBox(height: 8,),
                  const Text('Dirección:'),
                  const SizedBox(height: 8,),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HNComponentTextInput(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const Text('Ciudad:'),
                  const SizedBox(height: 8,),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HNComponentTextInput(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const Text('Provincia:'),
                  const SizedBox(height: 8,),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HNComponentTextInput(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const Text('Código postal:'),
                  const SizedBox(height: 8,),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HNComponentTextInput(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const Text('CIF:'),
                  const SizedBox(height: 8,),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HNComponentTextInput(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const Text('Correo:'),
                  const SizedBox(height: 8,),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HNComponentTextInput(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const Text('Teléfono:'),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 16, right: 8),
                          child: const HNComponentTextInput(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 8, right: 16),
                          child: const HNComponentTextInput(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 16, right: 8),
                          child: const HNComponentTextInput(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 8, right: 16),
                          child: const HNComponentTextInput(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  const Text('Precio/ud.:'),
                  const SizedBox(height: 8,),
                  Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth()
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 24, right: 16),
                            child: const Text("Cajas XL:")
                          ),
                          Container(
                              height: 40,
                              margin: const EdgeInsets.only(left: 8, right: 16, bottom: 8),
                              child: const HNComponentTextInput(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              ),
                            ),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 24, right: 16),
                            child: const Text("Cajas L:")
                          ),
                          Container(
                              height: 40,
                              margin: const EdgeInsets.only(left: 8, right: 16, bottom: 8),
                              child: const HNComponentTextInput(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              ),
                            ),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 24, right: 16),
                            child: const Text("Cajas M:")
                          ),
                          Container(
                              height: 40,
                              margin: const EdgeInsets.only(left: 8, right: 16, bottom: 8),
                              child: const HNComponentTextInput(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              ),
                            ),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 24, right: 16),
                            child: const Text("Cajas S:")
                          ),
                          Container(
                              height: 40,
                              margin: const EdgeInsets.only(left: 8, right: 16, bottom: 8),
                              child: const HNComponentTextInput(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              ),
                            ),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 24, right: 16),
                            child: const Text("Estuchados:")
                          ),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.only(left: 8, right: 16),
                            child: const HNComponentTextInput(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),),
                          ),
                        ]
                      )
                    ],
                  ),
                  SizedBox(height: 32,),
                  Container(
                    // TODO: Falta añadir el borde de puntos
                    color: Colors.amber,    // TODO: lo añado para ir viendo cómo queda - habrá que quitarlo
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          title: Text("Crear usuario para la app cliente"),
                          value: false,
                          onChanged: (newValue) {  },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        SizedBox(height: 16,),
                        Container(child: Text("Usuario:"), margin: EdgeInsets.only(left: 40),),
                        SizedBox(height: 8,),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: const HNComponentTextInput(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          ),
                        ),
                        SizedBox(height: 8,),
                        Container(child: Text("Correo:"), margin: EdgeInsets.only(left: 40),),
                        SizedBox(height: 8,),
                        Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HNComponentTextInput(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Se le mandará a la dirección xxxxx@xxxxx.xx un mensjae con la información para terminar de crear la cuenta"),
                  ),
                  SizedBox(height: 16,),
                      ],
                    ),
                  ),
                  SizedBox(height: 32,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                  HNButton(ButtonTypes.blackWhiteBoldRoundedButton).getTypedButton("Guardar", null, null, () { }, () { }),
                  SizedBox(height: 8,),
                  HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton("Guardar", null, null, () { }, () { }),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,)
                ],
              ),
            )
          ),
        ),
      )
    );
  }
}


void prueba () {
  Column(
    children: [
      Row(
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const HNComponentTextInput(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
          ),
        ],
      )
    ],
  );
}