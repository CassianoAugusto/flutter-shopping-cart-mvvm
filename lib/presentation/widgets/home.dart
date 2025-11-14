import 'package:app_carrinho_de_compras/core/routes/app_routes.dart';
import 'package:app_carrinho_de_compras/injections/app_injection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/product_view_model.dart';
import '../widgets/product_card.dart';
import '../widgets/connection_error_page.dart';

class HomeScreen extends StatefulWidget {
  final ProductViewModel? viewModel;
  const HomeScreen({super.key, this.viewModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = widget.viewModel ?? AppInjection.productViewModel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<ProductViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Produtos'),
              actions: [_CartButton(vm: vm)],
            ),
            body: _buildBody(vm),
          );
        },
      ),
    );
  }

  Widget _buildBody(ProductViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return ConnectionErrorPage(onRetry: vm.loadProducts);
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: vm.products.length,
      itemBuilder: (_, i) => ProductCard(product: vm.products[i], vm: vm),
    );
  }
}

class _CartButton extends StatelessWidget {
  final ProductViewModel vm;
  const _CartButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart, arguments: vm);
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
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
