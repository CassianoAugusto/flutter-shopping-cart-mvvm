import 'package:app_carrinho_de_compras/data/datasource/product_remote_darta_source.dart';
import 'package:app_carrinho_de_compras/data/services/product_service.dart';
import 'package:app_carrinho_de_compras/domain/commands/fetch_products_command.dart';
import 'package:app_carrinho_de_compras/presentation/viewmodel/product_view_model.dart';
import 'package:dio/dio.dart';

class AppInjection {
  static late final Dio dio;
  static late final ProductService productService;
  static late final ProductRemoteDataSource productDataSource;
  static late final FetchProductsCommand fetchProductsCommand;
  static late final ProductViewModel productViewModel;

  static void setup() {
    dio = Dio();

    productService = ProductService(dio);
    productDataSource = ProductRemoteDataSource(productService);
    fetchProductsCommand = FetchProductsCommand(productDataSource);
    productViewModel = ProductViewModel(fetchProductsCommand);
  }
}
