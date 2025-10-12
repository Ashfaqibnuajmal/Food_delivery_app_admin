import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/due%20payment/model/payment_entry_model.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_details_screen/due_details_header_info.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_details_screen/due_details_table.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_payment_screen/due_payment_table_header.dart';
import 'package:mera_web/features/due%20payment/services/due_payment_services.dart';

class UserEntriesCard extends StatelessWidget {
  final String userId;
  final String userName;
  final DuePaymentService service;

  const UserEntriesCard({
    super.key,
    required this.userId,
    required this.userName,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          width: 780,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.deepBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: StreamBuilder<List<PaymentEntryModel>>(
            stream: service.fetchUserEntries(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.pureWhite),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No entries yet!",
                    style: TextStyle(
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }

              final entries = snapshot.data!;
              double balance = 0;
              for (final e in entries) {
                if (e.status == "Consumed") {
                  balance += e.amount;
                } else if (e.status == "Paid") {
                  balance -= e.amount;
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserBalanceHeader(userName: userName, balance: balance),
                  const SizedBox(height: 20),
                  const DuePaymentTableHeader(),
                  const SizedBox(height: 8),
                  DuePaymentTableBody(entries: entries, service: service),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
