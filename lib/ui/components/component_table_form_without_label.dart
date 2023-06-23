import 'package:flutter/material.dart';

/// Forms table component.
/// Its TableRow's are made up of ComponentCellTableForm.

class HNComponentTableFormWithoutLabel extends StatelessWidget {
  final TableCellVerticalAlignment defaultVerticalAlignment;
  final List<TableRow> tableChildren;
  final EdgeInsets containerMargin;
  final Map<int, TableColumnWidth>? columnWidths;

  const HNComponentTableFormWithoutLabel(
      this.defaultVerticalAlignment, this.tableChildren, this.containerMargin,
      {Key? key, this.columnWidths})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: containerMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            columnWidths: columnWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: tableChildren,
          )
        ],
      ),
    );
  }
}
