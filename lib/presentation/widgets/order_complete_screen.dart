import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../viewmodel/product_view_model.dart';
import '../../data/models/product_model.dart';

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context, listen: false);

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final List<ProductModel> products =
        (args?['products'] as List<ProductModel>?) ?? [];
    final Map<int, int> quantities =
        (args?['quantities'] as Map<int, int>?) ?? {};
    final subtotal = (args?['subtotal'] as double?) ?? 0.0;
    const shipping = 12.0;
    final total = (args?['total'] as double?) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido Finalizado'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 12),
            const Text(
              "Seu pedido foi finalizado com sucesso!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final product = products[i];
                  final quantity = quantities[product.id] ?? 0;
                  final subtotalItem = product.price * quantity;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.title),
                      subtitle: Text(
                        'Qtd: $quantity • Unitário: R\$ ${product.price.toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        'R\$ ${subtotalItem.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1),
            _buildSummaryRow('Subtotal', subtotal),
            _buildSummaryRow('Frete', shipping),
            _buildSummaryRow('Total', total, isTotal: true),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  vm.clearCart();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Novo Pedido',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
