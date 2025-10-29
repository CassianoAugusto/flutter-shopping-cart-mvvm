import 'package:dio/dio.dart';
import '../data/datasource/product_remote_darta_source.dart';
import '../data/services/product_service.dart';
import '../domain/commands/fetch_products_command.dart';
import '../domain/commands/checkout_command.dart';
import '../domain/commands/remove_from_cart_command.dart';
import '../presentation/viewmodel/product_view_model.dart';

class AppInjection {
  static late final ProductRemoteDataSource productDataSource;
  static late final FetchProductsCommand fetchProductsCommand;
  static late final CheckoutCommand checkoutCommand;
  static late final RemoveFromCartCommand removeFromCartCommand;
  static late final ProductViewModel productViewModel;

  static void setup() {
    final dio = Dio();
    final productService = ProductService(dio);

    productDataSource = ProductRemoteDataSource(productService);
    fetchProductsCommand = FetchProductsCommand(productDataSource);
    checkoutCommand = CheckoutCommand();
    removeFromCartCommand = RemoveFromCartCommand();

    productViewModel = ProductViewModel(
      fetchProductsCommand: fetchProductsCommand,
      checkoutCommand: checkoutCommand,
      removeFromCartCommand: removeFromCartCommand,
    );
  }
}
