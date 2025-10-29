import 'package:app_carrinho_de_compras/domain/commands/checkout_command.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/product_model.dart';
import '../../domain/commands/fetch_products_command.dart';
import '../../core/result.dart';

class ProductViewModel extends ChangeNotifier {
  final FetchProductsCommand fetchProductsCommand;
  final CheckoutCommand checkoutCommand;

  final List<ProductModel> _products = [];
  final Map<int, int> _cart = {};
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  ProductViewModel({
    required this.fetchProductsCommand,
    required this.checkoutCommand,
  });

  List<ProductModel> get products => List.unmodifiable(_products);
  int get cartCount => _cart.values.fold(0, (a, b) => a + b);
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get subtotal => _cart.entries.fold(0, (sum, entry) {
    final product = _products.firstWhere(
      (p) => p.id == entry.key,
      orElse: () => ProductModel(
        id: entry.key,
        title: 'Produto',
        price: 0,
        image: '',
        description: '',
        category: '',
      ),
    );
    return sum + product.price * entry.value;
  });

  double get shipping => 12.0;
  double get total => subtotal + shipping;

  int getProductQuantity(int productId) => _cart[productId] ?? 0;
  double getSubtotal(ProductModel product) =>
      product.price * (_cart[product.id] ?? 0);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (!_disposed) notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    if (!_disposed) notifyListeners();
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    _setError(null);

    final Result<List<ProductModel>> result = await fetchProductsCommand
        .execute();

    if (result.isSuccess) {
      _products.clear();
      _products.addAll(result.data!);
    } else {
      _setError(result.error);
    }

    _setLoading(false);
  }

  void addToCart(ProductModel product) {
    _cart[product.id] = (_cart[product.id] ?? 0) + 1;
    if (!_disposed) notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    final current = _cart[product.id] ?? 0;
    if (current > 1) {
      _cart[product.id] = current - 1;
    } else {
      _cart.remove(product.id);
    }
    notifyListeners();
  }

  Future<Result<void>> checkout() async {
    _setLoading(true);

    final result = await checkoutCommand.execute(Map.from(_cart));
    if (result.isSuccess) {
      _cart.clear();
    }

    _setLoading(false);
    if (!_disposed) notifyListeners();
    return result;
  }

  void clearCart() {
    _cart.clear();
    if (!_disposed) notifyListeners();
  }
}
