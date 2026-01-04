import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/Warehouse/WarehouseModel.dart';

part 'WarehouseApi.g.dart';

@RestApi()
abstract class WarehouseApi {
  factory WarehouseApi(Dio dio, {String baseUrl}) = _WarehouseApi;

  @POST("/warehouse/add")
  Future<void> addWarehouse(@Body() Map<String, dynamic> data);

  @GET("/warehouse/view")
  Future<List<WarehouseModel>> getWarehouse();

  @GET("/warehouse/view/{id}")
  Future<WarehouseModel> getWarehouseById(@Path("id") String id);

  @DELETE("/warehouse/delete/{id}")
  Future<void> deleteWarehouse(@Path("id") String id);

  @PUT("/warehouse/update/{id}")
  Future<void> updateWarehouse(@Path("id") String id, @Body() Map<String, dynamic> data);
}