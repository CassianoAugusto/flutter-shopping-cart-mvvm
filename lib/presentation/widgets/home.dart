import 'package:app_carrinho_de_compras/injections/app_injection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/product_view_model.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_screen.dart';
import '../widgets/connection_error_page.dart';

class HomeScreen extends StatelessWidget {
  final ProductViewModel? viewModel;
  const HomeScreen({super.key, this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductViewModel>.value(
      value: viewModel ?? AppInjection.productViewModel
        ..loadProducts(),
      child: Consumer<ProductViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Produtos'),
              actions: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: vm,
                              child: const CartScreen(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, size: 35),
                    ),
                    if (vm.cartCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            vm.cartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
          );
        },
      ),
    );
  }
}
