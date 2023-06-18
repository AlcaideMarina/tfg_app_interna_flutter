import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/component_cell_table_form.dart';
import 'package:hueveria_nieto_interna/ui/components/component_container_border_text.dart';
import 'package:hueveria_nieto_interna/ui/components/component_simple_form.dart';
import 'package:hueveria_nieto_interna/ui/components/component_table_form.dart';
import 'package:hueveria_nieto_interna/ui/components/component_text_input.dart';
import 'package:hueveria_nieto_interna/ui/components/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/ui/views/allorders/client_all_orders_page.dart';
import 'package:hueveria_nieto_interna/ui/views/clients/modify_client_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

import '../../../data/models/order_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/order_utils.dart';
import '../../components/component_order.dart';
import '../../components/component_panel.dart';
import '../allorders/order_detail_page.dart';

class ClientDetailPage extends StatefulWidget {
  const ClientDetailPage(this.currentUser, this.client, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final ClientModel client;

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  late InternalUserModel currentUser;
  late ClientModel client;

  late int id;
  late String company;
  late String direction;
  late String city;
  late String province;
  late int postalCode;
  late String cif;
  late String email;
  late int phone1;
  late int phone2;
  late String namePhone1;
  late String namePhone2;
  bool hasAccount = false;
  String? user;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    client = widget.client;

    id = client.id;
    company = client.company;
    direction = client.direction;
    city = client.city;
    province = client.province;
    postalCode = client.postalCode;
    cif = client.cif;
    email = client.email;
    phone1 = client.phone[0].values.first;
    namePhone1 = client.phone[0].keys.first;
    phone2 = client.phone[1].values.first;
    namePhone2 = client.phone[1].keys.first;
    hasAccount = client.hasAccount;
    user = client.user;
  }

  List<String> labelList = [
    'Empresa',
    'Dirección',
    'Ciudad',
    'Provincia',
    'Código postal',
    'CIF',
    'Correo',
    'Confirmación del email',
    'Teléfono',
    'Precio/ud.',
  ];

  Map<String, String> eggTypes = {
    'xl': 'Cajas XL',
    'l': 'Cajas L',
    'm': 'Cajas M',
    's': 'Cajas S',
    'cartoned': 'Estuchados'
  };
  List<String> userLabels = ['Usuario'];
  // TODO: Mirar otra forma de contar - ¿mapas?
  int contCompany = 0;
  int contUser = 0;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print('NULO');
    } else {
      print('NO NULO');
    }
    contCompany = 0;
    contUser = 0;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Información del cliente',
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: SafeArea(
          child: StreamBuilder(
              stream:
                  FirebaseUtils.instance.getClientWithDocId(client.documentId!),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    DocumentSnapshot data = snapshot.data;
                    Map<String, dynamic> map =
                        data.data() as Map<String, dynamic>;
                    client = ClientModel.fromMap(map, data.id);
                    return Container(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getAllFormElements(),
                              getOrderElement(),
                              const SizedBox(
                                height: 32,
                              ),
                              getButtonsComponent(),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                        margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                        child: const HNComponentPanel(
                          title: 'Ha ocurrido un error',
                          text:
                              "Se ha producido un error al cargar los datos del cliente. Por favor, inténtelo de nuevo.",
                        ));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.redPrimaryColor,
                    ),
                  );
                }
              }),
        ));
  }

  Widget getAllFormElements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCompanyComponentSimpleForm(
            'Empresa', client.company, null, TextInputType.text, (value) {
          company = value;
        }),
        getCompanyComponentSimpleForm(
            'Dirección', client.direction, null, TextInputType.text, (value) {
          direction = value;
        }),
        getCompanyComponentSimpleForm(
            'Ciudad', client.city, null, TextInputType.text, (value) {
          city = value;
        }),
        getCompanyComponentSimpleForm(
            'Provincia', client.province, null, TextInputType.text, (value) {
          province = value;
        }),
        getCompanyComponentSimpleForm('Código postal',
            client.postalCode.toString(), null, TextInputType.number, (value) {
          postalCode = int.parse(value);
        }),
        getCompanyComponentSimpleForm(
            'CIF', client.cif, null, TextInputType.text, (value) {
          cif = value;
        }, textCapitalization: TextCapitalization.characters),
        getCompanyComponentSimpleForm(
            'Correo', client.email, null, TextInputType.emailAddress, (value) {
          email = value;
        }, textCapitalization: TextCapitalization.none),
        getComponentTableForm('Teléfono', getTelephoneTableRow()),
        getClientUserContainerComponent(),
      ],
    );
  }

  Widget getOrderElement() {
    return Flexible(
      fit: FlexFit.loose,
      child: StreamBuilder(
        stream: FirebaseUtils.instance.getUserOrders(client.documentId!),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              final List orders = data.docs;
              if (orders.isNotEmpty) {
                List<dynamic>? orderModelList = orders
                    .map((e) => OrderModel.fromMap(
                        e.data() as Map<String, dynamic>, e.id))
                    .toList();

                List<OrderModel> list = [];
                for (OrderModel item in orderModelList) {
                  if (item.status != Constants().orderStatus["Cancelado"]) {
                    list.add(item);
                  }
                }
                list.sort((a, b) {
                  return b.orderDatetime.compareTo(a.orderDatetime);
                });
                if (list.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        'Últimos pedidos:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: orders.length > 3 ? 3 : orders.length,
                        itemBuilder: ((context, index) {
                          final OrderModel orderModel = list[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 8),
                            child: HNComponentOrders(
                                orderModel.orderDatetime,
                                orderModel.orderId!,
                                orderModel.company,
                                OrderUtils().getOrderSummary(OrderUtils()
                                    .orderDataToBDOrderModel(
                                        orderModel)), // TODO
                                orderModel.totalPrice,
                                orderModel.status,
                                orderModel.deliveryDni, onTap: () async {
                              navigateToOrderDetail(orderModel);
                            }),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: HNButton(ButtonTypes.redWhiteBoldRoundedButton)
                            .getTypedButton('Ver todos', null, null,
                                navigateToClientAllOrders, () {}),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: CustomColors.redPrimaryColor,
              ),
            );
          }
        },
      ),
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
              'Modificar', null, null, navigateToModifyClient, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.blackRedBoldRoundedButton).getTypedButton(
              'Eliminar cliente', null, null, deleteWarningUser, () {}),
        ],
      ),
    );
  }

  Widget getCompanyComponentSimpleForm(
      String label,
      String initialValue,
      String? labelInputText,
      TextInputType textInputType,
      Function(String)? onChange,
      {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contCompany == 0) {
      topMargin = 8;
    } else if (contCompany == labelList.length) {
      bottomMargin = 32;
    }
    contCompany++;

    return HNComponentSimpleForm(
      label + ':',
      8,
      40,
      const EdgeInsets.symmetric(horizontal: 16),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      componentTextInput: HNComponentTextInput(
        textCapitalization: textCapitalization,
        labelText: initialValue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textInputType: textInputType,
        onChange: onChange,
        isEnabled: false,
        backgroundColor: CustomColors.backgroundTextFieldDisabled,
        textColor: CustomColors.darkGrayColor,
      ),
    );
  }

  Widget getComponentTableForm(String label, List<TableRow> children,
      {Map<int, TableColumnWidth>? columnWidhts}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contCompany == 0) {
      topMargin = 8;
    } else if (contCompany == labelList.length - 1) {
      bottomMargin = 32;
    }
    contCompany++;

    return HNComponentTableForm(
      label,
      8,
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
    );
  }

  List<TableRow> getTelephoneTableRow() {
    return [
      TableRow(children: [
        HNComponentCellTableForm(
            40, const EdgeInsets.only(left: 16, right: 8, bottom: 8),
            componentTextInput: HNComponentTextInput(
              labelText: phone1.toString(),
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                phone1 = int.parse(value);
              },
              isEnabled: false,
              backgroundColor: CustomColors.backgroundTextFieldDisabled,
              textColor: CustomColors.darkGrayColor,
            )),
        HNComponentCellTableForm(
            40, const EdgeInsets.only(left: 8, right: 16, bottom: 8),
            componentTextInput: HNComponentTextInput(
              labelText: namePhone1,
              textCapitalization: TextCapitalization.words,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                namePhone1 = value;
              },
              isEnabled: false,
              backgroundColor: CustomColors.backgroundTextFieldDisabled,
              textColor: CustomColors.darkGrayColor,
            )),
      ]),
      TableRow(children: [
        HNComponentCellTableForm(40, const EdgeInsets.only(left: 16, right: 8),
            componentTextInput: HNComponentTextInput(
              labelText: phone2.toString(),
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                phone2 = int.parse(value);
              },
              isEnabled: false,
              backgroundColor: CustomColors.backgroundTextFieldDisabled,
              textColor: CustomColors.darkGrayColor,
            )),
        HNComponentCellTableForm(40, const EdgeInsets.only(left: 8, right: 16),
            componentTextInput: HNComponentTextInput(
              labelText: namePhone2,
              textCapitalization: TextCapitalization.words,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                namePhone2 = value;
              },
              isEnabled: false,
              backgroundColor: CustomColors.backgroundTextFieldDisabled,
              textColor: CustomColors.darkGrayColor,
            )),
      ]),
    ];
  }

  Widget getClientUserContainerComponent() {
    return HNComponentContainerBorderText(
      'Usuario de la aplicación',
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 19),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.redPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(16),
          shape: BoxShape.rectangle,
        ),
        child: getClientComponentSimpleForm(userLabels[0], TextInputType.text,
            (value) {
          user = value;
        }),
      ),
      leftPosition: 24,
      rightPosition: 50,
      topPosition: 10,
    );
  }

  Widget getClientComponentSimpleForm(
      String label, TextInputType textInputType, Function(String)? onChange) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contUser == 0) {
      topMargin = 0;
    } else if (contUser == userLabels.length - 1) {
      bottomMargin = 16;
    }
    contUser++;

    return HNComponentSimpleForm(
      label + ':',
      8,
      40,
      const EdgeInsets.only(left: 0),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      componentTextInput: HNComponentTextInput(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textCapitalization: TextCapitalization.none,
        textInputType: textInputType,
        onChange: onChange,
        isEnabled: false,
        backgroundColor: CustomColors.backgroundTextFieldDisabled,
        textColor: CustomColors.darkGrayColor,
        labelText: user,
      ),
      textMargin: const EdgeInsets.only(left: 24),
    );
  }

  deleteWarningUser() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Aviso impoertante'),
              content: const Text(
                  'Esta acción es irreversible. ¿Está seguro de que quiere eliminar el cliente?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Continuar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteUser();
                  },
                )
              ],
            ));
  }

  deleteUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);
    bool conf = await FirebaseUtils.instance
        .deleteDocument("client_info", client.documentId!);

    Navigator.pop(context);
    if (conf) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Usuario eliminado'),
                content:
                    const Text('El usuario ha sido eliminado correctamente.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Parece que ha habido un error. Por favor, inténtelo de nuevo.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                  )
                ],
              ));
    }
  }

  navigateToModifyClient() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifyClientPage(currentUser, client),
        ));

    if (result != null) {
      client = result;
      setState(() {});
    }
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  navigateToOrderDetail(OrderModel orderModel) async {
    InternalUserModel? deliveryPerson;

    if (orderModel.deliveryPerson != null) {
      var futureDeliveryPerson = await FirebaseUtils.instance
          .getInternalUserWithDocumentId(orderModel.deliveryPerson!);
      if (futureDeliveryPerson.exists && futureDeliveryPerson.data() != null) {
        deliveryPerson = InternalUserModel.fromMap(
            futureDeliveryPerson.data()!, futureDeliveryPerson.id);
      }
    }
    if (context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(
                currentUser, client, orderModel, deliveryPerson),
          ));
    }
  }

  navigateToClientAllOrders() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClientAllOrdersPage(currentUser, client),
        ));
  }
}
