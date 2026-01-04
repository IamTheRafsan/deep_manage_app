// lib/ApiService/ExpenseCategoryApi/ExpenseCategoryApi.dart
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/ExpenseCategory/ExpenseCategoryModel.dart';

part 'ExpenseCategoryApi.g.dart';

@RestApi()
abstract class ExpenseCategoryApi {
  factory ExpenseCategoryApi(Dio dio, {String baseUrl}) = _ExpenseCategoryApi;

  @POST("/expense-category/add")
  Future<void> addExpenseCategory(@Body() Map<String, dynamic> data);

  @GET("/expense-category/view")
  Future<List<ExpenseCategoryModel>> getExpenseCategory();

  @GET("/expense-category/view/{id}")
  Future<ExpenseCategoryModel> getExpenseCategoryById(@Path("id") String id);

  @DELETE("/expense-category/delete/{id}")
  Future<void> deleteExpenseCategory(@Path("id") String id);

  @PUT("/expense-category/update/{id}")
  Future<void> updateExpenseCategory(@Path("id") String id, @Body() Map<String, dynamic> data);
}