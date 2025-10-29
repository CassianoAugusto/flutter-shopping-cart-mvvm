import 'package:app_carrinho_de_compras/presentation/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injections/app_injection.dart';
import 'core/routes/app_routes.dart';
import 'presentation/widgets/cart_screen.dart';
import 'presentation/widgets/order_complete_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppInjection.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppInjection.productViewModel..loadProducts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Carrinho de Compras',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.cart: (_) => const CartScreen(),
          AppRoutes.orderComplete: (_) => const OrderCompleteScreen(),
        },
      ),
    );
  }
}
