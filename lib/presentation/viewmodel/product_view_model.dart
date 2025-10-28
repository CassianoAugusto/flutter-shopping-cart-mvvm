import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../domain/commands/fetch_products_command.dart';

class ProductViewModel extends ChangeNotifier {
  final FetchProductsCommand _fetchProductsCommand;

  ProductViewModel(this._fetchProductsCommand);

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;

  final Map<int, int> _cart = {};

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get cartCount => _cart.values.fold(0, (sum, q) => sum + q);
  int getProductQuantity(int productId) => _cart[productId] ?? 0;

  double getSubtotal(ProductModel product) =>
      product.price * getProductQuantity(product.id);

  double getTotal() => _cart.entries
      .map((e) {
        final product = _products.firstWhere(
          (p) => p.id == e.key,
          orElse: () => ProductModel(
            id: e.key,
            title: 'Produto',
            price: 0,
            image: '',
            description: '',
            category: '',
          ),
        );
        return product.price * e.value;
      })
      .fold(0, (sum, val) => sum + val);

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _fetchProductsCommand.execute();
    if (result.isSuccess) {
      _products = result.data!;
    } else {
      _error = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  void addToCart(ProductModel product) {
    _cart[product.id] = (_cart[product.id] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    if (_cart.containsKey(product.id)) {
      final current = _cart[product.id]!;
      if (current > 1) {
        _cart[product.id] = current - 1;
      } else {
        _cart.remove(product.id);
      }
      notifyListeners();
    }
  }

  Future<void> removeFromCartWithError(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final hasError = DateTime.now().millisecond % 2 == 0;
    if (hasError) {
      throw Exception("Erro ao remover o item do carrinho.");
    } else {
      removeFromCart(product);
    }
  }

  Future<void> checkout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      final success = DateTime.now().millisecond % 2 == 0;

      if (!success) {
        throw Exception("Erro no checkout");
      }

      _cart.clear();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
