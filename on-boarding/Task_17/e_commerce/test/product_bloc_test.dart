import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:e_commerce/core/error/failures.dart';
import 'package:e_commerce/features/product/domain/entities/product.dart';
import 'package:e_commerce/features/product/domain/usecases/create_product.dart';
import 'package:e_commerce/features/product/domain/usecases/delete_product.dart';
import 'package:e_commerce/features/product/domain/usecases/get_product.dart';
import 'package:e_commerce/features/product/domain/usecases/update_product.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';

@GenerateMocks([
  ViewAllProductsUsecase,
  GetProduct,
  CreateProductUsecase,
  UpdateProductUsecase,
  DeleteProductUsecase
])
import 'product_bloc_test.mocks.dart';

void main() {
  late ProductBloc bloc;
  late MockViewAllProductsUsecase mockViewAll;
  late MockGetProduct mockGetProduct;
  late MockCreateProductUsecase mockCreate;
  late MockUpdateProductUsecase mockUpdate;
  late MockDeleteProductUsecase mockDelete;

  setUp(() {
    mockViewAll = MockViewAllProductsUsecase();
    mockGetProduct = MockGetProduct();
    mockCreate = MockCreateProductUsecase();
    mockUpdate = MockUpdateProductUsecase();
    mockDelete = MockDeleteProductUsecase();

    bloc = ProductBloc(
      viewAllProductsUsecase: mockViewAll,
      getProductUsecase: mockGetProduct,
      createProductUsecase: mockCreate,
      updateProductUsecase: mockUpdate,
      deleteProductUsecase: mockDelete,
    );
  });

  const tProduct = Product(
      id: '1', name: 'Test', description: 'Desc', price: 100, imageUrl: 'img', category: 'Cat');

  test('initial state should be InitialState', () {
    expect(bloc.state, InitialState());
  });

  group('LoadAllProductEvent', () {
    blocTest<ProductBloc, ProductState>(
      'emits [LoadingState, LoadedAllProductState] when data is gotten successfully',
      build: () {
        when(mockViewAll.call()).thenAnswer((_) async => const Right([tProduct]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProductEvent()),
      expect: () => [
        LoadingState(),
        const LoadedAllProductState(products: [tProduct]),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [LoadingState, ErrorState] when getting data fails',
      build: () {
        when(mockViewAll.call()).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProductEvent()),
      expect: () => [
        LoadingState(),
        const ErrorState(message: 'Server Failure'),
      ],
    );
  });
}