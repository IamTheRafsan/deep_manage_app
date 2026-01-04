// lib/ApiService/OutletApi/OutletApi.dart
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/Outlet/OutletModel.dart';

part 'OutletApi.g.dart';

@RestApi()
abstract class OutletApi {
  factory OutletApi(Dio dio, {String baseUrl}) = _OutletApi;

  @POST("/outlet/add")
  Future<void> addOutlet(@Body() Map<String, dynamic> data);

  @GET("/outlet/view")
  Future<List<OutletModel>> getOutlet();

  @GET("/outlet/view/{id}")
  Future<OutletModel> getOutletById(@Path("id") String id);

  @DELETE("/outlet/delete/{id}")
  Future<void> deleteOutlet(@Path("id") String id);

  @PUT("/outlet/update/{id}")
  Future<void> updateOutlet(@Path("id") String id, @Body() Map<String, dynamic> data);
}