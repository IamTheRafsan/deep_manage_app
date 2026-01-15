import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/WeightWastage/WeightWastageModel.dart';

part 'WeightWastageApi.g.dart';

@RestApi()
abstract class WeightWastageApi {
  factory WeightWastageApi(Dio dio, {String baseUrl}) = _WeightWastageApi;

  @POST("/weight-wastage/add")
  Future<void> addWeightWastage(@Body() Map<String, dynamic> data);

  @GET("/weight-wastage/view")
  Future<List<WeightWastageModel>> getWeightWastages();

  @GET("/weight-wastage/view/{id}")
  Future<WeightWastageModel> getWeightWastageById(@Path("id") String id);

  @DELETE("/weight-wastage/delete/{id}")
  Future<void> deleteWeightWastage(@Path("id") String id);

  @PUT("/weight-wastage/update/{id}")
  Future<void> updateWeightWastage(@Path("id") String id, @Body() Map<String, dynamic> data);
}