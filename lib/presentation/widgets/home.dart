import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/product_view_model.dart';
import '../widgets/product_card.dart';
import '../widgets/connection_error_page.dart';
import '../../core/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, vm, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Produtos'),
          actions: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, size: 35),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.cart);
                  },
                ),
                if (vm.cartCount > 0)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      vm.cartCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.error != null
            ? ConnectionErrorPage(onRetry: vm.loadProducts)
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: vm.products.length,
                itemBuilder: (context, index) {
                  final product = vm.products[index];
                  return ProductCard(product: product, vm: vm);
                },
              ),
      ),
    );
  }
}
