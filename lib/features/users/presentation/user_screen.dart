import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/users/model/user_model.dart';
import 'package:mera_web/features/users/services/user_services.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserServices();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "User Management",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                ),
              ),
              const SizedBox(height: 30),

              // ✅ Summary Cards Row (Realtime)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder<int>(
                    stream: userService.totalUsersCount(),
                    builder: (context, snapshot) => SummaryCard(
                      title: "Total User's",
                      count: snapshot.data?.toString() ?? "0",
                      icon: Icons.person,
                      iconBg: AppColors.darkBlue,
                      cardColor: AppColors.mediumBlue,
                    ),
                  ),
                  StreamBuilder<int>(
                    stream: userService.activeUsersCount(),
                    builder: (context, snapshot) => SummaryCard(
                      title: "Active User's",
                      count: snapshot.data?.toString() ?? "0",
                      icon: Icons.verified_user,
                      iconBg: Colors.green,
                      cardColor: AppColors.mediumBlue,
                    ),
                  ),
                  StreamBuilder<int>(
                    stream: userService.blockedUsersCount(),
                    builder: (context, snapshot) => SummaryCard(
                      title: "Blocked User's",
                      count: snapshot.data?.toString() ?? "0",
                      icon: Icons.person_off,
                      iconBg: Colors.red,
                      cardColor: AppColors.mediumBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ✅ User Table (Realtime)
              Expanded(
                child: StreamBuilder<List<UserModel>>(
                  stream: userService.fetchUsers(),
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
                          "No users found.",
                          style: TextStyle(color: AppColors.pureWhite),
                        ),
                      );
                    }

                    final allUsers = snapshot.data!;

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue.withOpacity(0.1),
                        border: Border.all(color: AppColors.deepBlue, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          // ✅ Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: const BoxDecoration(
                              color: AppColors.deepBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.pureWhite),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Phone No",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.pureWhite),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.pureWhite),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.pureWhite),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Action",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.pureWhite),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ✅ Table Rows (Realtime)
                          Expanded(
                            child: ListView.builder(
                              itemCount: allUsers.length,
                              itemBuilder: (context, index) {
                                final user = allUsers[index];
                                return UserRow(
                                  user: user,
                                  onToggle: () {
                                    if (user.status == "active") {
                                      userService.blockUser(user.uid);
                                    } else {
                                      userService.unblockUser(user.uid);
                                    }
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 🧭 Summary Card Widget
//
class SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconBg;
  final Color cardColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconBg,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 120,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite),
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(5)),
              child: Icon(icon, color: AppColors.pureWhite, size: 18),
            )
          ]),
          const Spacer(),
          Text(
            count,
            style: const TextStyle(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}

//
// 👥 User Table Row Widget
//
class UserRow extends StatelessWidget {
  final UserModel user;
  final VoidCallback onToggle;

  const UserRow({
    super.key,
    required this.user,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = user.status.toLowerCase() == "active";

    return Container(
      color: AppColors.lightBlue.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                user.name,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                user.phone,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                user.email,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                isActive ? "Active" : "Blocked",
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? AppColors.deepBlue : Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: onToggle,
                child: Text(
                  isActive ? "Block" : "Unblock",
                  style: const TextStyle(color: AppColors.pureWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
