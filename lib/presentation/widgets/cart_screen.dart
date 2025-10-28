import 'package:app_carrinho_de_compras/presentation/widgets/order_complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/product_view_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, vm, _) {
        final cartItems = vm.products
            .where((p) => vm.getProductQuantity(p.id) > 0)
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text("Carrinho")),
          body: cartItems.isEmpty
              ? const Center(child: Text("Carrinho vazio"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: cartItems.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final product = cartItems[index];
                          final quantity = vm.getProductQuantity(product.id);
                          final subtotal = vm.getSubtotal(product);
                          return ListTile(
                            leading: Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.title),
                            subtitle: Text(
                              "Unitário: R\$ ${product.price.toStringAsFixed(2)}\nSubtotal: R\$ ${subtotal.toStringAsFixed(2)}",
                            ),
                            trailing: SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () async {
                                      try {
                                        await vm.removeFromCartWith(product);
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      vm.addToCart(product);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Subtotal: R\$ ${cartItems.map((p) => vm.getSubtotal(p)).fold(0.0, (a, b) => a + b).toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Frete: R\$ 12,00",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Total: R\$ ${(cartItems.map((p) => vm.getSubtotal(p)).fold(0.0, (a, b) => a + b) + 12).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: vm.cartCount == 0
                                ? null
                                : () async {
                                    try {
                                      await vm.checkout();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const OrderCompleteScreen(),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: vm.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Finalizar Pedido"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
