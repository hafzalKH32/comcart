
import 'package:com_cart/core/dio_client.dart';
import 'package:com_cart/features/products/data/models/product_model.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final Dio _dio = DioClient.instance;

  Future<ProductListResponse> getProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final res = await _dio.get(
        '/products',
        queryParameters: {"limit": limit, "skip": skip},
      );

      print("✅ getProducts -> ${res.data['products']?.length} items");
      return ProductListResponse.fromJson(res.data);
    } on DioException catch (e) {
      print("❌ Dio error: $e");
      throw Exception(e.response?.data["message"] ?? "Failed fetching products");
    } catch (e) {
      print("❌ Unknown error: $e");
      throw Exception("Failed fetching products");
    }
  }


Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load product');
    }
    catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<Product> updateProduct({
    required int id,
    required String title,
    required String description,
    required double price,
  }) async {
    try {
      final response = await _dio.put(
        '/products/$id',
        data: {
          'title': title,
          'description': description,
          'price': price,
        },
      );

      print('UPDATE RESPONSE: ${response.data}'); // Debug

      // return correct updated product structure
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('product')) {
        return Product.fromJson(response.data['product']);
      }

      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to update product');
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

}