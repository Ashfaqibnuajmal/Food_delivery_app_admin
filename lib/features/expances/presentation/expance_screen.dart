import 'package:flutter/material.dart';
import 'package:mera_web/features/categories/presentation/widget/confiorm_dilog.dart';
import 'package:mera_web/features/expances/models/expance_model.dart';
import 'package:mera_web/features/expances/presentation/expance_add_dilog.dart';
import 'package:mera_web/features/expances/presentation/expance_edit_dilog.dart';
import 'package:mera_web/features/expances/provider/expance_provider.dart';
import 'package:mera_web/features/expances/services/expance_services.dart';
import 'package:provider/provider.dart';

class ExpanceScreen extends StatelessWidget {
  const ExpanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseService = ExpanceServices();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expanse Management",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    onPressed: () {
                      customAddExpenseDialog(
                        context: context,
                        onPressed: () {
                          final provider = Provider.of<ExpenseProvider>(context,
                              listen: false);

                          if (provider.date != null &&
                              provider.category != null &&
                              provider.amount != null &&
                              provider.status != null) {
                            expenseService.addExpance(
                              date: provider.date!,
                              category: provider.category!,
                              amount: provider.amount!.toDouble(),
                              status: provider.status!,
                            );

                            // clear form
                            provider.clearDate();
                            provider.clearCategory();
                            provider.clearAmount();
                            provider.clearStatus();
                          }
                        },
                      );
                    },
                    child: const Text("Add Expanse",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Summary Cards (Realtime Net Balance)
              StreamBuilder<List<ExpenseModel>>(
                stream: expenseService.fetchExpenses(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }

                  final expenses = snapshot.data!;
                  double gasTotal = 0;
                  double rentTotal = 0;
                  double electricityTotal = 0;
                  double stationaryTotal = 0;

                  for (var exp in expenses) {
                    double value = exp.amount;
                    if (exp.status == "Consumed") {
                      value = -value; // subtract if consumed
                    }
                    switch (exp.category) {
                      case "Gas":
                        gasTotal += value;
                        break;
                      case "Room Rent":
                        rentTotal += value;
                        break;
                      case "Electricity":
                        electricityTotal += value;
                        break;
                      case "Stationary":
                        stationaryTotal += value;
                        break;
                    }
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SummaryCard(
                        title: "Gas",
                        amount: gasTotal,
                        icon: const Icon(Icons.gas_meter, color: Colors.white),
                      ),
                      SummaryCard(
                        title: "Room Rent",
                        amount: rentTotal,
                        icon: const Icon(Icons.home, color: Colors.white),
                      ),
                      SummaryCard(
                        title: "Electricity",
                        amount: electricityTotal,
                        icon: const Icon(Icons.electric_bolt_outlined,
                            color: Colors.white),
                      ),
                      SummaryCard(
                        title: "Stationary",
                        amount: stationaryTotal,
                        icon: const Icon(Icons.shopping_cart,
                            color: Colors.white),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // ✅ Expense Table (Realtime from Firestore)
              Expanded(
                child: StreamBuilder<List<ExpenseModel>>(
                  stream: expenseService.fetchExpenses(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: Colors.white));
                    }

                    final expenses = snapshot.data!;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          // Header Row
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                )),
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text("Date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)))),
                                Expanded(
                                    child: Center(
                                        child: Text("Category",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)))),
                                Expanded(
                                    child: Center(
                                        child: Text("Amount",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)))),
                                Expanded(
                                    child: Center(
                                        child: Text("Status",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)))),
                                Expanded(
                                    child: Center(
                                        child: Text("Edit",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)))),
                                Expanded(
                                    child: Center(
                                        child: Text("Delete",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)))),
                              ],
                            ),
                          ),

                          // Body
                          Expanded(
                            child: ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                final expense = expenses[index];
                                return ExpenseRow(
                                  expense: expense,
                                  onEdit: () {
                                    showEditExpenseDialog(
                                      context: context,
                                      currentDate: expense.date,
                                      currentCategory: expense.category,
                                      currentAmount: expense.amount,
                                      currentStatus: expense.status,
                                      onSave: (newDate, newCategory, newAmount,
                                          newStatus) {
                                        final updated = ExpenseModel(
                                          expanseUid: expense.expanseUid,
                                          date: newDate,
                                          category: newCategory,
                                          amount: newAmount,
                                          status: newStatus,
                                        );
                                        expenseService.editExpanse(updated);
                                      },
                                    );
                                  },
                                  onDelete: () {
                                    customDeleteDilog(context, () async {
                                      await expenseService
                                          .deleteExpense(expense.expanseUid);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ Summary Card
class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Icon icon;

  const SummaryCard(
      {super.key,
      required this.title,
      required this.amount,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  child: icon,
                )
              ],
            ),
            const Spacer(),
            Text(
              amount.toStringAsFixed(2),
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Row Widget
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
              child:
                  Center(child: Text(expense.date.toString().split(" ")[0]))),
          Expanded(child: Center(child: Text(expense.category))),
          Expanded(
              child: Center(
                  child: Text(expense.amount.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold)))),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: onEdit,
                child:
                    const Text("Edit", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: onDelete,
                child:
                    const Text("Delete", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
