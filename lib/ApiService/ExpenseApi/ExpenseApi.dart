// lib/ApiService/ExpenseApi/ExpenseApi.dart
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/Expense/ExpenseModel.dart';

part 'ExpenseApi.g.dart';

@RestApi()
abstract class ExpenseApi {
  factory ExpenseApi(Dio dio, {String baseUrl}) = _ExpenseApi;

  @POST("/expense/add")
  Future<void> addExpense(@Body() Map<String, dynamic> data);

  @GET("/expense/view")
  Future<List<ExpenseModel>> getExpense();

  @GET("/expense/view/{id}")
  Future<ExpenseModel> getExpenseById(@Path("id") String id);

  @DELETE("/expense/delete/{id}")
  Future<void> deleteExpense(@Path("id") String id);

  @PUT("/expense/update/{id}")
  Future<void> updateExpense(@Path("id") String id, @Body() Map<String, dynamic> data);
}