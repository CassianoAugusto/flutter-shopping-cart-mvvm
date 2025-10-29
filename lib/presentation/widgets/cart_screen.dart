import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/viewmodel/product_view_model.dart';
import '../../core/routes/app_routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, vm, _) {
        final cartProducts = vm.products
            .where((p) => vm.getProductQuantity(p.id) > 0)
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Carrinho')),
          body: cartProducts.isEmpty
              ? const Center(child: Text('Carrinho vazio'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartProducts.length,
                        itemBuilder: (context, index) {
                          final product = cartProducts[index];
                          final quantity = vm.getProductQuantity(product.id);
                          return ListTile(
                            leading: Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.title),
                            subtitle: Text(
                              ' Qtd: $quantity\n Unitário: R\$ ${product.price.toStringAsFixed(2)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => vm.removeFromCart(product),
                                ),
                                Text(quantity.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => vm.addToCart(product),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSummaryRow('Subtotal', vm.subtotal),
                          _buildSummaryRow('Frete', vm.shipping),
                          _buildSummaryRow('Total', vm.total, isTotal: true),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final cartProducts = vm.products
                                    .where(
                                      (p) => vm.getProductQuantity(p.id) > 0,
                                    )
                                    .toList();

                                if (cartProducts.isEmpty) return;

                                final quantities = {
                                  for (var p in cartProducts)
                                    p.id: vm.getProductQuantity(p.id),
                                };
                                final subtotal = cartProducts.fold(
                                  0.0,
                                  (sum, p) => sum + p.price * quantities[p.id]!,
                                );
                                const shipping = 12.0;
                                final total = subtotal + shipping;

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                final result = await vm.checkout();
                                Navigator.pop(context);

                                if (result.isSuccess) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.orderComplete,
                                    (route) => false,
                                    arguments: {
                                      'products': cartProducts,
                                      'quantities': quantities,
                                      'subtotal': subtotal,
                                      'total': total,
                                    },
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(14),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Finalizar Pedido'),
                            ),
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

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }
}
