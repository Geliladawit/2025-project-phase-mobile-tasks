import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_product.dart'; 
import '../../domain/usecases/update_product.dart';


part 'product_event.dart';
part 'product_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ViewAllProductsUsecase viewAllProductsUsecase;
  final GetProduct getProductUsecase; 
  final CreateProductUsecase createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  ProductBloc({
    required this.viewAllProductsUsecase,
    required this.getProductUsecase,
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
  }) : super(InitialState()) {
    
    on<LoadAllProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await viewAllProductsUsecase.call();
      
      result.fold(
        (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
        (products) => emit(LoadedAllProductState(products: products)),
      );
    });

    on<GetSingleProductEvent>((event, emit) async {
      emit(LoadingState());
       final result = await getProductUsecase.call(event.id);
       
       result.fold(
         (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
         (product) => emit(LoadedSingleProductState(product: product)),
       );
    });

    on<CreateProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await createProductUsecase.call(event.product);

      result.fold(
        (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
        (_) {
          add(LoadAllProductEvent());
        },
      );
    });

    on<UpdateProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await updateProductUsecase.call(event.product);

      result.fold(
        (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
        (_) {
          add(LoadAllProductEvent());
        },
      );
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await deleteProductUsecase.call(event.id);

      result.fold(
        (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
        (_) {
          add(LoadAllProductEvent());
        },
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}