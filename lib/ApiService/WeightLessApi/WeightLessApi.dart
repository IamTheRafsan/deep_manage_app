import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/WeightLess/WeightLessModel.dart';

part 'WeightLessApi.g.dart';

@RestApi()
abstract class WeightLessApi {
  factory WeightLessApi(Dio dio, {String baseUrl}) = _WeightLessApi;

  @POST("/weight-less/add")
  Future<void> addWeightLess(@Body() Map<String, dynamic> data);

  @GET("/weight-less/view")
  Future<List<WeightLessModel>> getWeightLesses();

  @GET("/weight-less/view/{id}")
  Future<WeightLessModel> getWeightLessById(@Path("id") String id);

  @DELETE("/weight-less/delete/{id}")
  Future<void> deleteWeightLess(@Path("id") String id);

  @PUT("/weight-less/update/{id}")
  Future<void> updateWeightLess(@Path("id") String id, @Body() Map<String, dynamic> data);
}