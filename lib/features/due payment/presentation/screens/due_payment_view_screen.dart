import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/due%20payment/model/payment_entry_model.dart';
import 'package:mera_web/features/due%20payment/presentation/screens/entry_add.dart';
import 'package:mera_web/features/due%20payment/presentation/screens/entry_edit.dart';
import 'package:mera_web/features/due%20payment/services/due_payment_services.dart';

class DuePaymentViewScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const DuePaymentViewScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final service = DuePaymentService();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 🔹 Heading Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: AppColors.pureWhite,
                        ),
                      ),
                      Text(
                        "$userName's Due Details",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mediumBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    onPressed: () {
                      customAddEntryDialog(context: context, userId: userId);
                    },
                    child: const Text(
                      "Add Entry",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 User card + entries table
              Expanded(
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.pureWhite),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "No entries yet",
                              style: TextStyle(color: AppColors.pureWhite),
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
                            // User header info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.pureWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkBlue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.person,
                                      color: AppColors.pureWhite),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Total Balance Due: ₹${balance.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: balance > 0
                                      ? Colors.redAccent.shade200
                                      : Colors.greenAccent.shade200,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 20),

                            // Table Header Row
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.mediumBlue.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Date",
                                        style: TextStyle(
                                          color: AppColors.pureWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                          color: AppColors.pureWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Amount",
                                        style: TextStyle(
                                          color: AppColors.pureWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Notes",
                                        style: TextStyle(
                                          color: AppColors.pureWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: AppColors.pureWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: AppColors.pureWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Table body rows
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.darkBlue.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListView.builder(
                                  itemCount: entries.length,
                                  itemBuilder: (context, index) {
                                    final entry = entries[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.darkBlue.withOpacity(0.3),
                                        border: Border(
                                          bottom: BorderSide(
                                              color: AppColors.deepBlue
                                                  .withOpacity(0.8)),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                entry.date
                                                    .toString()
                                                    .split(" ")[0],
                                                style: const TextStyle(
                                                    color: AppColors.pureWhite),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                entry.status,
                                                style: TextStyle(
                                                  color: entry.status == "Paid"
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "₹${entry.amount.toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                    color: AppColors.pureWhite),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                entry.notes,
                                                style: const TextStyle(
                                                    color: AppColors.pureWhite),
                                              ),
                                            ),
                                          ),
                                          // 🔹 Edit button
                                          Expanded(
                                            child: Center(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.deepBlue,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  customEditEntryDialog(
                                                    context: context,
                                                    currentEntry: entry,
                                                  );
                                                },
                                                child: const Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.pureWhite),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // 🔹 Delete button
                                          Expanded(
                                            child: Center(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  await service
                                                      .deletePaymentEntry(
                                                          entry.userId,
                                                          entry.entryId);
                                                  log("🗑️ Deleted entry ${entry.entryId}");
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.pureWhite),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
