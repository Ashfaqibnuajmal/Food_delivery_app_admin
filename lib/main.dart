import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mera_web/core/provider/pick_image.dart';
import 'package:mera_web/features/categories/services/category_sevices.dart';
import 'package:mera_web/core/constants/firebase_options.dart';
import 'package:mera_web/features/expances/provider/expance_provider.dart';
import 'package:mera_web/core/provider/user_search_provider.dart';
import 'package:mera_web/features/foods/presentation/screens/fooditem_screen.dart';
import 'package:mera_web/features/foods/provider/dialogstateprovider.dart';
import 'package:mera_web/features/foods/services/food_item_services.dart';
import 'package:mera_web/features/home/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategorySevices>(
          create: (_) => CategorySevices(),
        ),
        ChangeNotifierProvider<ImageProviderModel>(
          create: (_) => ImageProviderModel(),
        ),
        ChangeNotifierProvider(create: (_) => UserSearchProvider()),
        ChangeNotifierProvider<ExpenseProvider>(
          // ✅ Added Expense Provider
          create: (_) => ExpenseProvider(),
        ),
        ChangeNotifierProvider<FoodItemServices>(
          create: (_) => FoodItemServices(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(), // 👈 Launches your expense page UI
      ),
    );
  }
}
