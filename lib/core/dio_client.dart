import 'package:dio/dio.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
  static Dio get instance => _dio;
}