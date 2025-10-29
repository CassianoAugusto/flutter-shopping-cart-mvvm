import 'package:app_carrinho_de_compras/presentation/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_carrinho_de_compras/presentation/viewmodel/product_view_model.dart';
import 'package:app_carrinho_de_compras/data/models/product_model.dart';
import 'package:app_carrinho_de_compras/presentation/widgets/product_card.dart';
import 'package:app_carrinho_de_compras/presentation/widgets/connection_error_page.dart';

class MockProductViewModel extends Mock implements ProductViewModel {}

void main() {
  late MockProductViewModel mockVM;

  setUp(() {
    mockVM = MockProductViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(home: HomeScreen(viewModel: mockVM));
  }

  testWidgets('exibe loading quando isLoading é true', (tester) async {
    when(() => mockVM.isLoading).thenReturn(true);
    when(() => mockVM.error).thenReturn(null);
    when(() => mockVM.products).thenReturn([]);
    when(() => mockVM.loadProducts()).thenAnswer((_) => Future.value());
    when(() => mockVM.cartCount).thenReturn(0);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('exibe erro quando error não é null', (tester) async {
    when(() => mockVM.isLoading).thenReturn(false);
    when(() => mockVM.error).thenReturn('Erro ao carregar');
    when(() => mockVM.products).thenReturn([]);
    when(() => mockVM.loadProducts()).thenAnswer((_) => Future.value());
    when(() => mockVM.cartCount).thenReturn(0);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(ConnectionErrorPage), findsOneWidget);
  });

  testWidgets('exibe lista de produtos quando sucesso', (tester) async {
    final products = [
      ProductModel(
        id: 1,
        title: 'Produto 1',
        price: 10,
        description: '',
        image: '',
        category: '',
      ),
      ProductModel(
        id: 2,
        title: 'Produto 2',
        price: 20,
        description: '',
        image: '',
        category: '',
      ),
    ];

    when(() => mockVM.isLoading).thenReturn(false);
    when(() => mockVM.error).thenReturn(null);
    when(() => mockVM.products).thenReturn(products);
    when(() => mockVM.loadProducts()).thenAnswer((_) => Future.value());
    when(() => mockVM.cartCount).thenReturn(0);

    for (var product in products) {
      when(() => mockVM.getProductQuantity(product.id)).thenReturn(0);
    }

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(find.text('Produto 1'), findsOneWidget);
    expect(find.text('Produto 2'), findsOneWidget);
  });

  testWidgets('exibe contador do carrinho quando cartCount > 0', (
    tester,
  ) async {
    when(() => mockVM.isLoading).thenReturn(false);
    when(() => mockVM.error).thenReturn(null);
    when(() => mockVM.products).thenReturn([]);
    when(() => mockVM.loadProducts()).thenAnswer((_) => Future.value());
    when(() => mockVM.cartCount).thenReturn(3);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });
}
