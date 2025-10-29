import 'package:app_carrinho_de_compras/core/result.dart';

class RemoveFromCartCommand {
  Future<Result<void>> execute(int productId, Map<int, int> cart) async {
    try {
      if (cart.containsKey(productId)) {
        final qty = cart[productId]!;
        if (qty > 1) {
          cart[productId] = qty - 1;
        } else {
          cart.remove(productId);
        }
      }
      await Future.delayed(const Duration(milliseconds: 200));
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        "Erro ao remover produto do carrinho: ${e.toString()}",
      );
    }
  }
}
