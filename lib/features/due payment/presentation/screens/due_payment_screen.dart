import 'package:flutter/material.dart';
import 'package:mera_web/features/due%20payment/model/due_user_model.dart';
import 'package:mera_web/features/due%20payment/presentation/screens/due_payment_add.dart';
import 'package:mera_web/features/due%20payment/presentation/screens/due_payment_edit.dart';
import 'package:mera_web/features/due%20payment/presentation/screens/due_payment_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/users/provider/user_search_provider.dart';

import '../../services/due_payment_services.dart';

class DuePaymentScreen extends StatelessWidget {
  const DuePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserSearchProvider>();
    final dueService = DuePaymentService();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹Title & Add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Due Payment Tracker',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mediumBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      customAddDuePaymentDialog(context: context);
                    },
                    child: const Text(
                      "Add Due Payment",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 🔹Search bar
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.mediumBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.pureWhite),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: AppColors.pureWhite),
                        decoration: const InputDecoration(
                          hintText: 'Search by name...',
                          hintStyle: TextStyle(color: AppColors.pureWhite),
                          border: InputBorder.none,
                        ),
                        onChanged: provider.updateQuery,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(
                          provider.isListening ? Icons.mic : Icons.mic_none,
                          color: provider.isListening
                              ? Colors.redAccent
                              : AppColors.pureWhite,
                        ),
                        onPressed: provider.toggleVoiceListening,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 🔹Firestore Table
              Expanded(
                child: StreamBuilder<List<DueUserModel>>(
                  stream: dueService.fetchDueUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.pureWhite),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No due users found",
                          style: TextStyle(color: AppColors.pureWhite),
                        ),
                      );
                    }

                    // Filter results by typed name
                    final users = snapshot.data!;
                    final filtered = users
                        .where((u) => u.name
                            .toLowerCase()
                            .contains(provider.query.toLowerCase()))
                        .toList();

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue.withOpacity(0.1),
                        border: Border.all(color: AppColors.deepBlue, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              color: AppColors.deepBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: const Row(
                              children: [
                                HeaderCell(title: "Name"),
                                HeaderCell(title: "Phone No"),
                                HeaderCell(title: "Email"),
                                HeaderCell(title: "Balance Due"),
                                HeaderCell(title: "View"),
                                HeaderCell(title: "Edit"),
                                HeaderCell(title: "Delete"),
                              ],
                            ),
                          ),

                          // Rows
                          Expanded(
                            child: ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final user = filtered[index];
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.lightBlue.withOpacity(0.05),
                                    border: const Border(
                                      bottom: BorderSide(color: Colors.black26),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            user.name,
                                            style: const TextStyle(
                                                color: AppColors.pureWhite),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            user.phone,
                                            style: const TextStyle(
                                                color: AppColors.pureWhite),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            user.email,
                                            style: const TextStyle(
                                                color: AppColors.pureWhite),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "₹${user.balance.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.pureWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DuePaymentViewScreen(
                                                          userId: user.userId,
                                                          userName: user.name),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              "View",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.deepBlue,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              customEditDuePaymentDialog(
                                                context: context,
                                                currentUser:
                                                    user, // pass the DueUserModel for that row
                                              );
                                            },
                                            child: const Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: AppColors.pureWhite),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () async {
                                              await dueService
                                                  .deleteDueUser(user.userId);
                                            },
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: AppColors.pureWhite),
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
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// reusable header cell
class HeaderCell extends StatelessWidget {
  final String title;
  const HeaderCell({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.pureWhite,
            ),
          ),
        ),
      );
}
