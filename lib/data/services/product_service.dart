import 'package:app_carrinho_de_compras/data/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ProductService {
  final Dio dio;

  ProductService(this.dio) {
    dio.options.baseUrl = 'https://fakestoreapi.com';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.next(options),
        onError: (DioException e, handler) => handler.next(e),
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await dio.get('/products');

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception('Erro ao buscar produtos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final msg = e.response != null
          ? 'Erro ${e.response?.statusCode}: ${e.response?.statusMessage}'
          : 'Erro de conexão: ${e.message}';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
