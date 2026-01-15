// lib/ApiService/DepositCategoryApi/DepositCategoryApi.dart
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/DepositCategory/DepositCategoryModel.dart';

part 'DepositCategoryApi.g.dart';

@RestApi()
abstract class DepositCategoryApi {
  factory DepositCategoryApi(Dio dio, {String baseUrl}) = _DepositCategoryApi;

  @POST("/deposit-category/add")
  Future<void> addDepositCategory(@Body() Map<String, dynamic> data);

  @GET("/deposit-category/view")
  Future<List<DepositCategoryModel>> getDepositCategory();

  @GET("/deposit-category/view/{id}")
  Future<DepositCategoryModel> getDepositCategoryById(@Path("id") String id);

  @DELETE("/deposit-category/delete/{id}")
  Future<void> deleteDepositCategory(@Path("id") String id);

  @PUT("/deposit-category/update/{id}")
  Future<void> updateDepositCategory(@Path("id") String id, @Body() Map<String, dynamic> data);
}