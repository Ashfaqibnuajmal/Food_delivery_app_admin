import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/due%20payment/model/payment_entry_model.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_details_screen/due_details_table_row.dart';
import 'package:mera_web/features/due%20payment/services/due_payment_services.dart';

class DuePaymentTableBody extends StatelessWidget {
  final List<PaymentEntryModel> entries;
  final DuePaymentService service;

  const DuePaymentTableBody({
    super.key,
    required this.entries,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkBlue.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return DuePaymentRow(
              entry: entry,
              service: service,
            );
          },
        ),
      ),
    );
  }
}
