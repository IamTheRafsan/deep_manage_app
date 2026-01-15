import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/Product/ProductModel.dart';

part 'ProductApi.g.dart';

@RestApi()
abstract class ProductApi {
  factory ProductApi(Dio dio, {String baseUrl}) = _ProductApi;

  @POST("/product/add")
  Future<void> addProduct(@Body() Map<String, dynamic> data);

  @GET("/product/view")
  Future<List<ProductModel>> getProduct();

  @GET("/product/view/{id}")
  Future<ProductModel> getProductById(@Path("id") String id);

  @DELETE("/product/delete/{id}")
  Future<void> deleteProduct(@Path("id") String id);

  @PUT("/product/update/{id}")
  Future<void> updateProduct(@Path("id") String id, @Body() Map<String, dynamic> data);
}