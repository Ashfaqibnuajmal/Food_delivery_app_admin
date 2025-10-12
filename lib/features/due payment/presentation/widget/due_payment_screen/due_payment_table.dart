import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/due%20payment/model/due_user_model.dart';
import 'package:mera_web/features/due%20payment/presentation/screens/due_payment_view_screen.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_payment_screen/due_payment_edit.dart';
import 'package:mera_web/features/due%20payment/services/due_payment_services.dart';

class DuePaymentTable extends StatelessWidget {
  final List<DueUserModel> users;

  const DuePaymentTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final dueService = DuePaymentService();

    return Expanded(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.05),
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
                  style: CustomTextStyles.text,
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  user.phone,
                  style: CustomTextStyles.text,
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  user.email,
                  style: CustomTextStyles.text,
                ))),
                Expanded(
                  child: Center(
                    child: Text(
                      "₹${user.balance.toStringAsFixed(2)}",
                      style: CustomTextStyles.text,
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
                            builder: (context) => DuePaymentViewScreen(
                              userId: user.userId,
                              userName: user.name,
                            ),
                          ),
                        );
                      },
                      child:
                          const Text("View", style: CustomTextStyles.viewStyle),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        customEditDuePaymentDialog(
                            context: context, currentUser: user);
                      },
                      child: const Text("Edit", style: CustomTextStyles.text),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        await dueService.deleteDueUser(user.userId);
                      },
                      child: const Text("Delete", style: CustomTextStyles.text),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
