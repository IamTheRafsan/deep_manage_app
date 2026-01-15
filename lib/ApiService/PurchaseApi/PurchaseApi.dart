import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/Purchase/PurchaseModel.dart';

part 'PurchaseApi.g.dart';

@RestApi()
abstract class PurchaseApi {
  factory PurchaseApi(Dio dio, {String baseUrl}) = _PurchaseApi;

  @POST("/purchase/add")
  Future<void> addPurchase(@Body() Map<String, dynamic> data);

  @GET("/purchase/view")
  Future<List<PurchaseModel>> getPurchases();

  @GET("/purchase/view/{id}")
  Future<PurchaseModel> getPurchaseById(@Path("id") String id);

  @DELETE("/purchase/delete/{id}")
  Future<void> deletePurchase(@Path("id") String id);

  @PUT("/purchase/update/{id}")
  Future<void> updatePurchase(@Path("id") String id, @Body() Map<String, dynamic> data);
}