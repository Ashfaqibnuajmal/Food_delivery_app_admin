import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mera_web/features/auth/screens/login_screen.dart';
import 'package:mera_web/features/categories/provider/pick_image.dart';
import 'package:mera_web/features/categories/services/category_sevices.dart';
import 'package:mera_web/core/constants/firebase_options.dart';
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
            create: (_) => ImageProviderModel())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: LoginScreen()),
    );
  }
}
