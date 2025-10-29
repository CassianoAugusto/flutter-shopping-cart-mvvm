import 'package:app_carrinho_de_compras/core/result.dart';
import 'package:app_carrinho_de_compras/data/datasource/product_remote_darta_source.dart';
import 'package:app_carrinho_de_compras/data/models/product_model.dart';

class FetchProductsCommand {
  final ProductRemoteDataSource _remoteDataSource;

  FetchProductsCommand(this._remoteDataSource);

  Future<Result<List<ProductModel>>> execute() async {
    try {
      final products = await _remoteDataSource.fetchProducts();
      return Result.success(products);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
