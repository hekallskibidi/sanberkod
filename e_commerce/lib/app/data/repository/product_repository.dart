import '../../core/network/dio_exception.dart';
import '../../core/network/result.dart';
import '../models/product_model.dart';
import '../remote/product_remote_datasource.dart';

/// Contract used by the presentation layer to request product data.
abstract class ProductRepository {
  Future<Result<List<ProductModel>, String>> fetchProducts();
}

/// Converts remote data-source outcomes into a predictable Result type.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async {
    try {
      final products = await _remoteDataSource.fetchProducts();
      return Success<List<ProductModel>, String>(products);
    } on NetworkFailure catch (error) {
      return Failure<List<ProductModel>, String>(error.message);
    } catch (error) {
      final failure = ErrorHandler.handle(error);
      return Failure<List<ProductModel>, String>(failure.message);
    }
  }
}
