import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/expances/models/expance_model.dart';

class ExpenseRow extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseRow({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = expense.status == "Paid";
    return Container(
      color: AppColors.lightBlue.withOpacity(0.1), // row background color
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
              child: Center(
                  child: Text(expense.date.toString().split(" ")[0],
                      style: const TextStyle(color: AppColors.pureWhite)))),
          Expanded(
              child: Center(
                  child: Text(expense.category,
                      style: const TextStyle(color: AppColors.pureWhite)))),
          Expanded(
              child: Center(
                  child: Text(expense.amount.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.pureWhite)))),
          Expanded(
            child: Center(
              child: Text(
                expense.status,
                style: TextStyle(
                    color: isPaid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue),
                onPressed: onEdit,
                child: const Text("Edit",
                    style: TextStyle(color: AppColors.pureWhite)),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: onDelete,
                child: const Text("Delete",
                    style: TextStyle(color: AppColors.pureWhite)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
