import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  String company = "";
  String direction = "";
  String cif = "";
  int phone = -1;
  String namePhone = "";
  int xlDozen = 0;
  int xlBox = 0;
  int lDozen = 0;
  int lBox = 0;
  int mDozen = 0;
  int mBox = 0;
  int sDozen = 0;
  int sBox = 0; 
  String paymentMethod = "";
  Timestamp deliveryTimestamp = Timestamp.now();
  String deliveryDatetimeStr = "";//Utils().parseTimestmpToString(deliveryTimestamp) ?? "";

  int cont = 0;

  List<String> companyItems = [];
  List<String> paymentMethodItems = [];

  TextEditingController dateController = TextEditingController();
  DateTime minDate = DateTime.now().add(const Duration(days: 3));
  Timestamp? datePickerTimestamp;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {

    if (companyItems.isEmpty) {
      for (String key in Constants().paymentMethods.keys) {
        companyItems.add(key);
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Nuevo usuario interno',
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getAllFormElements(),
                      const SizedBox(
                        height: 32,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      getButtonsComponent(),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

  Widget getAllFormElements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getDropdownComponentSimpleForm('Empresa', null, TextInputType.text,
            (value) => {
          company = value!
        }, companyItems),   // TODO: Hay que sacar las empresas de bbdd
        getTextComponentSimpleForm('Dirección', null, TextInputType.text, (value) {
          direction = value;
        }),
        getTextComponentSimpleForm('CIF', null, TextInputType.text, (value) {
          cif = value;
        }),
        // TODO: Campo de teléfono
        Text("Pedido"),
        Text("XL"),
        Text("L"),
        Text("M"),
        Text("S"),
        // TODO: Campos del pedido
        getTextComponentSimpleForm('Dirección', null, TextInputType.text, (value) {
          direction = value;
        }),
        getDropdownComponentSimpleForm('Empresa', null, TextInputType.text,
            (value) => {
          company = value!
        }, paymentMethodItems), 
        getTextComponentSimpleForm('Fecha de entrega', null, TextInputType.text, 
          (value) async {
            // TODO: Cambiar el color
            DateTime? pickedDate = await showDatePicker(
              context: context, 
              initialDate: minDate, 
              firstDate: minDate, 
              lastDate: DateTime(
                DateTime.now().year + 1,
                DateTime.now().month,
                minDate.day
              )
            );
            if (pickedDate != null) {
              setState(() {
                datePickerTimestamp = Timestamp.fromDate(pickedDate);
                dateController.text = dateFormat.format(pickedDate);
              });
            }
          },
          textEditingController: dateController),
      ],
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, () {}, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton('Cancelar', null, null, () {}, () {}),
        ],
      ),
    );
  }

  Widget getDropdownComponentSimpleForm(String label, String? labelInputText, 
      TextInputType textInputType, Function(dynamic)? onChange, List<String> items,
      {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
        double topMargin = 4;
        double bottomMargin = 4;
        if (cont == 0) {
          topMargin = 8;
        } else if (cont == 14) {
          bottomMargin = 32;
        }
        cont++;
        
        return HNComponentSimpleForm(
        '$label:',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin,),
        componentDropdown: 
          HNComponentDropdown(
            items,
            labelText: labelInputText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textInputType: textInputType,
            onChange: onChange,
          ),
        );
  }

  Widget getTextComponentSimpleForm(String label, String? labelInputText,
      TextInputType textInputType, Function(String)? onChange,
      {TextCapitalization textCapitalization = TextCapitalization.sentences, 
      TextEditingController? textEditingController}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (cont == 0) {
      topMargin = 8;
    } else if (cont == 14) {
      bottomMargin = 32;
    }
    cont++;

    return HNComponentSimpleForm(
        label + ':',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        componentTextInput: HNComponentTextInput(
          textCapitalization: textCapitalization,
          labelText: labelInputText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textInputType: textInputType,
          onChange: onChange,
          textEditingController: textEditingController
        ),);
  }
  
}