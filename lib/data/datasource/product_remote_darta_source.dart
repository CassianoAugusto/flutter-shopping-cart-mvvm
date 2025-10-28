import '../models/product_model.dart';
import '../services/product_service.dart';

abstract class ProductRemoteDataSources {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSource implements ProductRemoteDataSources {
  final ProductService _service;

  ProductRemoteDataSource(this._service);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    return await _service.fetchProducts();
  }
}
