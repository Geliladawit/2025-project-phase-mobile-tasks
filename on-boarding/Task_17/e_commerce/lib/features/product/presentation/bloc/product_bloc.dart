import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/get_single_product.dart';
import '../../domain/usecases/update_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ViewAllProductsUsecase getAllProduct;
  final GetSingleProductUsecase getSingleProduct;
  final CreateProductUsecase createProduct;
  final UpdateProductUsecase updateProduct;
  final DeleteProductUsecase deleteProduct;

  ProductBloc({
    required this.getAllProduct,
    required this.getSingleProduct,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(const EmptyState()) {
    on<LoadAllProductEvent>(_onLoadAllProductEvent);
    on<GetSingleProductEvent>(_onGetSingleProductEvent);
    on<CreateProductEvent>(_onCreateProductEvent);
    on<UpdateProductEvent>(_onUpdateProductEvent);
    on<DeleteProductEvent>(_onDeleteProductEvent);
  }

  Future<void> _onLoadAllProductEvent(
    LoadAllProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      final products = await getAllProduct.call();
      emit(LoadedAllProductState(products));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onGetSingleProductEvent(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      final product = await getSingleProduct.call(event.id);
      emit(LoadedSingleProductState(product));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onCreateProductEvent(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      await createProduct.call(event.product);
      // After creating, reload all products
      final products = await getAllProduct.call();
      emit(LoadedAllProductState(products));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateProductEvent(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      await updateProduct.call(event.product);
      // After updating, reload all products
      final products = await getAllProduct.call();
      emit(LoadedAllProductState(products));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteProductEvent(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      await deleteProduct.call(event.id);
      // After deleting, reload all products
      final products = await getAllProduct.call();
      emit(LoadedAllProductState(products));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}

