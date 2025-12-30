import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../Model/RoleModel/RoleModel.dart';

part 'RoleApi.g.dart';

@RestApi()
abstract class RoleApi {
  factory RoleApi(Dio dio, {String baseUrl}) = _RoleApi;

  @POST("/role/add")
  Future<void> createRole(@Body() Map<String, dynamic> data);

  @GET("/role/view")
  Future<List<RoleModel>> getRole();

  @GET("/role/view/{id}")
  Future<RoleModel> getRoleById(
      @Path("id") String id
      );

  @DELETE("/role/delete/{id}")
  Future<void> deleteRole(
      @Path("id") String id
      );

  @PUT("/role/update/{id}")
  Future<void> updateRole(@Path("id") String id, @Body() Map<String, dynamic> data);
}