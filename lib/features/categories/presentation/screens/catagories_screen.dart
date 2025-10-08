import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/categories/presentation/widget/body.dart';
import 'package:mera_web/features/categories/presentation/widget/header.dart';

// ignore: must_be_immutable
class CatagoriesScreen extends StatelessWidget {
  TextEditingController catagorynameController = TextEditingController();
  CatagoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Header(catagorynameController: catagorynameController),
              const SizedBox(height: 10),
              Body(catagorynameController: catagorynameController),
            ],
          ),
        ),
      ),
    );
  }
}
