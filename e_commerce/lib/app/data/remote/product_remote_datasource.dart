import '../../core/network/dio_client.dart';
import '../models/product_model.dart';

/// Contract for retrieving products from a remote source.
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

/// DummyJSON implementation of [ProductRemoteDataSource].
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;

  ProductRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/products/category/mens-shoes',
    );
    final payload = response.data;

    if (payload is! Map<String, dynamic>) {
      throw const FormatException('Respons server bukan objek JSON.');
    }

    final rawProducts = payload['products'];
    if (rawProducts is! List) {
      throw const FormatException(
        'Field products tidak ditemukan pada respons server.',
      );
    }

    final products = <ProductModel>[];
    for (final item in rawProducts) {
      if (item is Map) {
        products.add(ProductModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    return products;
  }
}
