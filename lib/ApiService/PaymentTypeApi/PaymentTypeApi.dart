import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:deep_manage_app/Model/PaymentType/PaymentTypeModel.dart';

part 'PaymentTypeApi.g.dart';

@RestApi()
abstract class PaymentTypeApi {
  factory PaymentTypeApi(Dio dio, {String baseUrl}) = _PaymentTypeApi;

  @POST("/payment/add")
  Future<void> addPaymentType(@Body() Map<String, dynamic> data);

  @GET("/payment/view")
  Future<List<PaymentTypeModel>> getPaymentTypes();

  @GET("/payment/view/{id}")
  Future<PaymentTypeModel> getPaymentTypeById(@Path("id") String id);

  @DELETE("/payment/delete/{id}")
  Future<void> deletePaymentType(@Path("id") String id);

  @PUT("/payment/update/{id}")
  Future<void> updatePaymentType(@Path("id") String id, @Body() Map<String, dynamic> data);
}