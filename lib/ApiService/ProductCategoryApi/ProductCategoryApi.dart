import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/ProductCategory/ProductCategoryModel.dart';

part 'ProductCategoryApi.g.dart';

@RestApi()
abstract class ProductCategoryApi {
  factory ProductCategoryApi(Dio dio, {String baseUrl}) = _ProductCategoryApi;

  @POST("/category/add")
  Future<void> addProductCategory(@Body() Map<String, dynamic> data);

  @GET("/category/view")
  Future<List<ProductCategoryModel>> getProductCategory();

  @GET("/category/view/{id}")
  Future<ProductCategoryModel> getProductCategoryById(@Path("id") String id);

  @DELETE("/category/delete/{id}")
  Future<void> deleteProductCategory(@Path("id") String id);

  @PUT("/category/update/{id}")
  Future<void> updateProductCategory(@Path("id") String id, @Body() Map<String, dynamic> data);
}