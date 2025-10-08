import 'package:flutter/material.dart';
import 'package:mera_web/features/users/presentation/widget/voice_search.bar.dart';
import 'package:provider/provider.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/users/model/user_model.dart';
import 'package:mera_web/features/users/services/user_services.dart';
import 'package:mera_web/features/users/provider/user_search_provider.dart';

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
              // 🔹 Title
              const Text(
                'User Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                ),
              ),
              const SizedBox(height: 25),
              const VoiceSearchBar(),
              const SizedBox(height: 30),

              // 🔹 Summary Cards
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

              // 🔁 Firestore Stream + Provider update
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
                        child: Text('No users found',
                            style: TextStyle(color: AppColors.pureWhite)),
                      );
                    }

                    // ✅ update provider directly (one‑way) — no loop
                    context.read<UserSearchProvider>().setUsers(snapshot.data!);

                    // ✅ build table body that listens to provider
                    return const _UserTableBody();
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

//───────────────────────────────────────
// 🧭 Summary Card Widget
//───────────────────────────────────────
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

//───────────────────────────────────────
// 👥 Table Body (Provider consumer)
//───────────────────────────────────────
class _UserTableBody extends StatelessWidget {
  const _UserTableBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserSearchProvider>();
    final userService = UserServices(); // for block/unblock actions
    final filtered = provider.filteredUsers;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.1),
        border: Border.all(color: AppColors.deepBlue, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.deepBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: const Row(
              children: [
                HeaderCell(title: 'Name'),
                HeaderCell(title: 'Phone No'),
                HeaderCell(title: 'Email'),
                HeaderCell(title: 'Status'),
                HeaderCell(title: 'Action'),
              ],
            ),
          ),

          // Filtered data rows
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final user = filtered[i];
                final isActive = user.status.toLowerCase() == 'active';
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: Row(
                    children: [
                      DataCellText(user.name),
                      DataCellText(user.phone),
                      DataCellText(user.email),
                      Expanded(
                        child: Center(
                          child: Text(
                            isActive ? 'Active' : 'Blocked',
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
                              backgroundColor:
                                  isActive ? AppColors.deepBlue : Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (isActive) {
                                userService.blockUser(user.uid);
                              } else {
                                userService.unblockUser(user.uid);
                              }
                            },
                            child: Text(
                              isActive ? 'Block' : 'Unblock',
                              style:
                                  const TextStyle(color: AppColors.pureWhite),
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
  }
}

//───────────────────────────────────────
// 🧩 Reusable header + cells
//───────────────────────────────────────
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
              fontSize: 15,
              color: AppColors.pureWhite,
            ),
          ),
        ),
      );
}

class DataCellText extends StatelessWidget {
  final String data;
  const DataCellText(this.data, {super.key});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Center(
          child: Text(
            data,
            style: const TextStyle(color: AppColors.pureWhite),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
}
