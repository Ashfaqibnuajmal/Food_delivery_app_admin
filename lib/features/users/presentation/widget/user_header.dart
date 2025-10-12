import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';

class HeaderCell extends StatelessWidget {
  final String title;
  const HeaderCell({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Center(
          child: Text(title, style: CustomTextStyles.addCategory),
        ),
      );
}
