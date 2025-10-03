import 'dart:developer';
import 'package:flutter/material.dart';

Future<void> showEditExpenseDialog({
  required BuildContext context,
  required DateTime currentDate,
  required String currentCategory,
  required double currentAmount,
  required String currentStatus,
  required void Function(DateTime newDate, String newCategory, double newAmount,
          String newStatus)
      onSave,
}) async {
  final amountController =
      TextEditingController(text: currentAmount.toString());

  // Temporary values used while editing
  DateTime selectedDate = currentDate;
  String category = currentCategory;
  String status = currentStatus;

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Date Picker
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                ),
                onPressed: () async {
                  try {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      selectedDate = picked;
                    }
                  } catch (e) {
                    log("Date Picker Error: $e");
                  }
                },
                icon: const Icon(Icons.date_range, color: Colors.white),
                label: Text(
                  selectedDate.toString().split(" ")[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Category Dropdown
              DropdownButtonFormField<String>(
                value: category,
                decoration: inputDecoration("Category"),
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(
                      value: "Electricity", child: Text("Electricity")),
                  DropdownMenuItem(
                      value: "Stationary", child: Text("Stationary")),
                  DropdownMenuItem(value: "Gas", child: Text("Gas")),
                  DropdownMenuItem(
                      value: "Room Rent", child: Text("Room Rent")),
                ],
                onChanged: (val) {
                  if (val != null) category = val;
                },
              ),
              const SizedBox(height: 20),

              // ✅ Amount Input
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Edit Amount"),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // ✅ Status Dropdown
              DropdownButtonFormField<String>(
                value: status,
                decoration: inputDecoration("Status"),
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: "Paid", child: Text("Paid")),
                  DropdownMenuItem(value: "Consumed", child: Text("Consumed")),
                ],
                onChanged: (val) {
                  if (val != null) status = val;
                },
              ),
              const SizedBox(height: 30),

              // ✅ Save Changes Button
              ElevatedButton(
                onPressed: () {
                  final newAmount =
                      double.tryParse(amountController.text) ?? currentAmount;
                  onSave(selectedDate, category, newAmount, status);

                  Navigator.pop(context); // Close dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// ✅ Same InputDecoration style used in AddExpense
InputDecoration inputDecoration(String label) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.black,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
