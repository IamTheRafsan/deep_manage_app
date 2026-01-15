import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/Brand/BrandModel.dart';

part 'BrandApi.g.dart';

@RestApi()
abstract class BrandApi {
  factory BrandApi(Dio dio, {String baseUrl}) = _BrandApi;

  @POST("/brand/add")
  Future<void> addBrand(@Body() Map<String, dynamic> data);

  @GET("/brand/view")
  Future<List<BrandModel>> getBrand();

  @GET("/brand/view/{id}")
  Future<BrandModel> getBrandById(@Path("id") String id);

  @DELETE("/brand/delete/{id}")
  Future<void> deleteBrand(@Path("id") String id);

  @PUT("/brand/update/{id}")
  Future<void> updateBrand(@Path("id") String id, @Body() Map<String, dynamic> data);
}