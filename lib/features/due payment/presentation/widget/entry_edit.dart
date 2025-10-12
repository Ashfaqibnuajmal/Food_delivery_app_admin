import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/due%20payment/model/payment_entry_model.dart';
import 'package:mera_web/features/due%20payment/services/due_payment_services.dart';

Future<void> customEditEntryDialog({
  required BuildContext context,
  required PaymentEntryModel currentEntry,
}) async {
  final service = DuePaymentService();

  DateTime selectedDate = currentEntry.date;
  String status = currentEntry.status;
  double amount = currentEntry.amount;
  String notes = currentEntry.notes;

  final amountController =
      TextEditingController(text: currentEntry.amount.toString());
  final notesController = TextEditingController(text: currentEntry.notes);

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Entry",
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Date picker
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumBlue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                  onPressed: () async {
                    try {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: AppColors.lightBlue,
                              surface: AppColors.deepBlue,
                              onSurface: AppColors.pureWhite,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        (context as Element).markNeedsBuild();
                      }
                    } catch (e) {
                      log("Date Picker Error: $e");
                    }
                  },
                  icon:
                      const Icon(Icons.date_range, color: AppColors.pureWhite),
                  label: Text(
                    selectedDate.toString().split(" ")[0],
                    style: const TextStyle(color: AppColors.pureWhite),
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Status dropdown (pre-selected)
                DropdownButtonFormField<String>(
                  decoration: inputDecoration("Status"),
                  dropdownColor: AppColors.deepBlue,
                  value: status,
                  style: const TextStyle(color: AppColors.pureWhite),
                  items: const [
                    DropdownMenuItem(value: "Paid", child: Text("Paid")),
                    DropdownMenuItem(
                        value: "Consumed", child: Text("Consumed")),
                  ],
                  onChanged: (v) => status = v ?? "Paid",
                ),
                const SizedBox(height: 20),

                // 🔹 Amount
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration("Enter Amount"),
                  style: const TextStyle(color: AppColors.pureWhite),
                  onChanged: (v) =>
                      amount = double.tryParse(v.trim()) ?? amount,
                ),
                const SizedBox(height: 20),

                // 🔹 Notes
                TextFormField(
                  controller: notesController,
                  keyboardType: TextInputType.text,
                  decoration: inputDecoration("Notes"),
                  style: const TextStyle(color: AppColors.pureWhite),
                  onChanged: (v) => notes = v.trim(),
                ),
                const SizedBox(height: 30),

                // 🔹 Update button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBlue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    try {
                      final updatedEntry = PaymentEntryModel(
                        entryId: currentEntry.entryId,
                        userId: currentEntry.userId,
                        date: selectedDate,
                        status: status,
                        amount: amount,
                        notes: notes,
                      );

                      await service.editPaymentEntry(updatedEntry);
                      log("✅ Updated entry ${currentEntry.entryId}");
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      log("❌ Error updating entry: $e");
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error updating entry"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Update Entry",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// ── same input decoration helper ───────────────────────────
InputDecoration inputDecoration(String label) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: AppColors.darkBlue,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
