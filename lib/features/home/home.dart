import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:mera_web/features/categories/presentation/screens/catagories_screen.dart';
import 'package:mera_web/features/chat/chat_screen.dart';
import 'package:mera_web/features/dashboard/dashboard_screen.dart';
import 'package:mera_web/features/foods/fooditem_screen.dart';
import 'package:mera_web/features/orders/order_screen.dart';
import 'package:mera_web/features/users/users_screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              hoverColor: Colors.white10,
              selectedColor: Colors.blueAccent,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              unselectedTitleTextStyle: const TextStyle(color: Colors.blue),
              unselectedIconColor: Colors.blue,
              backgroundColor: Colors.black,
            ),
            title: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Hotel Admin',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            items: [
              SideMenuItem(
                title: 'Dashboard',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.dashboard, color: Colors.blue),
              ),
              SideMenuItem(
                title: 'Orders',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.reorder, color: Colors.blue),
              ),
              SideMenuItem(
                title: 'Food Items',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.fastfood, color: Colors.blue),
              ),
              SideMenuItem(
                title: 'Users',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.people, color: Colors.blue),
              ),
              SideMenuItem(
                title: 'Chat',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.chat, color: Colors.blue),
              ),
              SideMenuItem(
                title: 'Categories',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.category, color: Colors.blue),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                const DashboardScreen(),
                const OrderScreen(),
                const FooditemScreen(),
                const UsersScreens(),
                const ChatScreen(),
                CatagoriesScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
