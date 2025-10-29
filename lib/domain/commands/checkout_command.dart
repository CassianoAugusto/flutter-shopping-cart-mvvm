import 'package:app_carrinho_de_compras/core/result.dart';

class CheckoutCommand {
  Future<Result<void>> execute(Map<int, int> cart) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return Result.success(null);
    } catch (e) {
      return Result.failure("Erro no checkout: ${e.toString()}");
    }
  }
}
