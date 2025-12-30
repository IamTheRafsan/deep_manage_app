import 'package:deep_manage_app/Model/User/UserModel.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'UserApi.g.dart';

@RestApi()
abstract class UserApi{
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;
  
  @POST("/user/add")
  Future<void> addUser(@Body() Map<String, dynamic> data);

  @GET("/user/view")
  Future<List<UserModel>> getUser();

  @GET("/user/view/{id}")
  Future<UserModel> getUserById(@Path("id") String id);
  
  @DELETE("/user/delete/{id}")
  Future<void> deleteUser(@Path("id") String id);

  @PUT("/user/update/{id}")
  Future<void> updateUser(@Path("id") String id, @Body() Map<String, dynamic> data);

}