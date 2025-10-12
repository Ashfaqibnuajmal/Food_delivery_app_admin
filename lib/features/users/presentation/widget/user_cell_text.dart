import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';

class DataCellText extends StatelessWidget {
  final String data;
  const DataCellText(this.data, {super.key});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Center(
          child: Text(
            data,
            style: const TextStyle(color: AppColors.pureWhite),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
}
