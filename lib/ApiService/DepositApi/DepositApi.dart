import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/Deposit/DepositModel.dart';

part 'DepositApi.g.dart';

@RestApi()
abstract class DepositApi {
  factory DepositApi(Dio dio, {String baseUrl}) = _DepositApi;

  @POST("/deposit/add")
  Future<void> addDeposit(@Body() Map<String, dynamic> data);

  @GET("/deposit/view")
  Future<List<DepositModel>> getDeposit();

  @GET("/deposit/view/{id}")
  Future<DepositModel> getDepositById(@Path("id") String id);

  @DELETE("/deposit/delete/{id}")
  Future<void> deleteDeposit(@Path("id") String id);

  @PUT("/deposit/update/{id}")
  Future<void> updateDeposit(@Path("id") String id, @Body() Map<String, dynamic> data);
}