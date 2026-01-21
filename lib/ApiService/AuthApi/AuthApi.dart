import 'package:deep_manage_app/Model/LoginModel/LoginRequest.dart';
import 'package:deep_manage_app/Model/LoginModel/LoginResponse.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'AuthApi.g.dart';

@RestApi(baseUrl: "")
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest loginRequest);

}
