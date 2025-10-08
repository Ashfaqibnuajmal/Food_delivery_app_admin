import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/users/model/user_model.dart';
import 'package:mera_web/features/users/services/user_services.dart';

class UsersScren extends StatefulWidget {
  const UsersScren({super.key});

  @override
  State<UsersScren> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScren> {
  final userService = UserServices();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                ),
              ),
              const SizedBox(height: 20),

              // 🔍 Simple Search bar at top
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.mediumBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  style: const TextStyle(color: AppColors.pureWhite),
                  decoration: const InputDecoration(
                    hintText: 'Search by name...',
                    hintStyle:
                        TextStyle(color: AppColors.pureWhite, fontSize: 14),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: AppColors.pureWhite),
                  ),
                  onChanged: (val) => setState(() => searchQuery = val),
                ),
              ),
              const SizedBox(height: 25),

              // 🔁 Table with Realtime Firestore data
              Expanded(
                child: StreamBuilder<List<UserModel>>(
                  stream: userService.fetchUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.pureWhite,
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No users found',
                            style: TextStyle(color: AppColors.pureWhite)),
                      );
                    }

                    final users = snapshot.data!;
                    final filtered = users
                        .where((u) => u.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

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
                            decoration: BoxDecoration(
                              color: AppColors.deepBlue,
                              borderRadius: const BorderRadius.only(
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
                          // Data rows
                          Expanded(
                            child: ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, idx) {
                                final user = filtered[idx];
                                final isActive =
                                    user.status.toLowerCase() == 'active';
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black26),
                                    ),
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
                                              color: isActive
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isActive
                                                  ? AppColors.deepBlue
                                                  : Colors.green,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (isActive) {
                                                userService.blockUser(user.uid);
                                              } else {
                                                userService
                                                    .unblockUser(user.uid);
                                              }
                                            },
                                            child: Text(
                                              isActive ? "Block" : "Unblock",
                                              style: const TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}

//
// small reusable header + cell widgets for cleaner layout
//
class HeaderCell extends StatelessWidget {
  final String title;
  const HeaderCell({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
}

class DataCellText extends StatelessWidget {
  final String data;
  const DataCellText(this.data, {super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          data,
          style: const TextStyle(color: AppColors.pureWhite),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
