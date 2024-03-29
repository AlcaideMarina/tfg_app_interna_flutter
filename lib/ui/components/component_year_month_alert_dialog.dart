import 'package:flutter/material.dart';

import '../../custom/custom_colors.dart';

class HNComponentYearMonthAlertDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const HNComponentYearMonthAlertDialog({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  }) : super(key: key);

  @override
  _HNComponentYearMonthAlertDialogState createState() =>
      _HNComponentYearMonthAlertDialogState();
}

class _HNComponentYearMonthAlertDialogState
    extends State<HNComponentYearMonthAlertDialog> {
  late int selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year;
  }

  void _onMonthChanged(int? month) {
    if (month != null) {
      setState(() {
        selectedMonth = month;
      });
    }
  }

  void _onYearChanged(int? year) {
    if (year != null) {
      setState(() {
        selectedYear = year;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];

    return AlertDialog(
      title: const Text('Seleccionar fecha'),
      content: Row(
        children: [
          Expanded(
            child: DropdownButton<int>(
              value: selectedMonth,
              onChanged: _onMonthChanged,
              items: months.asMap().entries.map(
                (entry) {
                  final int index = entry.key + 1;
                  final String monthName = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(monthName),
                    ),
                  );
                },
              ).toList(),
              dropdownColor:
                  Colors.white,
              icon: const Icon(Icons
                  .arrow_drop_down_rounded),
              iconSize: 24,
              isExpanded: true,
              underline: Container(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<int>(
              value: selectedYear,
              onChanged: _onYearChanged,
              items: List<int>.generate(
                21,
                (int index) => widget.firstDate.year + index - 10,
              ).map(
                (int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(year.toString()),
                    ),
                  );
                },
              ).toList(),
              dropdownColor:
                  Colors.white,
              icon: const Icon(Icons
                  .arrow_drop_down_rounded),
              iconSize: 24,
              isExpanded: true,
              underline: Container(),
            ),
          ),
        ],
      ),
      actionsPadding: EdgeInsets
          .zero,
      actions: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                height: 1,
                color: CustomColors.redPrimaryColor,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: 1,
                    height: 48,
                    color: CustomColors.redPrimaryColor,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: TextButton(
                        onPressed: () {
                          final DateTime selectedDate =
                              DateTime(selectedYear, selectedMonth);
                          Navigator.pop(context, selectedDate);
                        },
                        child: Text('Aceptar'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            16),
      ),
    );
  }
}
