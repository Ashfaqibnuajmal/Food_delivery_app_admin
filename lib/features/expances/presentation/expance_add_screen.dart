import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mera_web/features/expances/provider/expance_provider.dart';
import 'package:provider/provider.dart';

Future<void> customAddExpenseDialog({
  required BuildContext context,
  required void Function() onPressed, // to call provider.addExpense()
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      final provider = Provider.of<ExpenseProvider>(context);

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
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) provider.setDate(picked);
                  } catch (e) {
                    log("Date Picker Error: $e");
                  }
                },
                icon: const Icon(Icons.date_range, color: Colors.white),
                label: Text(
                  provider.date != null
                      ? provider.date.toString().split(" ")[0]
                      : "Pick Date",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Category Dropdown
              DropdownButtonFormField<String>(
                decoration: inputDecoration("Category"),
                value: provider.category,
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
                  if (val != null) provider.setCategory(val);
                },
              ),
              const SizedBox(height: 20),

              // ✅ Amount Input
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Enter Amount"),
                style: const TextStyle(color: Colors.white),
                onChanged: (val) {
                  if (val.isNotEmpty)
                    provider.setAmount(int.tryParse(val) ?? 0);
                },
              ),
              const SizedBox(height: 20),

              // ✅ Status Dropdown
              DropdownButtonFormField<String>(
                decoration: inputDecoration("Status"),
                value: provider.status,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: "Paid", child: Text("Paid")),
                  DropdownMenuItem(value: "Consumed", child: Text("Consumed")),
                ],
                onChanged: (val) {
                  if (val != null) provider.setStatus(val);
                },
              ),
              const SizedBox(height: 30),

              // ✅ Add Button
              ElevatedButton(
                onPressed: () {
                  onPressed(); // trigger provider.addExpense or services
                  Navigator.pop(context); // close dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Add Expense",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

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
