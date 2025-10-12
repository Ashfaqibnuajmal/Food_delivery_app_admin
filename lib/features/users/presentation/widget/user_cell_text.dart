import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';

class DataCellText extends StatelessWidget {
  final String data;
  const DataCellText(this.data, {super.key});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Center(
          child: Text(
            data,
            style: CustomTextStyles.text,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
}
