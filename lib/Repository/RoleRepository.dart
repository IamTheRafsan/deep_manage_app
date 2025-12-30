import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/RoleApi/RoleApi.dart';
import '../Model/RoleModel/RoleModel.dart';

class RoleRepository {
  final RoleApi roleApi;

  RoleRepository(this.roleApi);

  Future<void> createRole(String name, List<String> permissions) async {
    final data = {
      "name": name,
      "permission": permissions,
    };

    await roleApi.createRole(data);
  }

  Future<List<RoleModel>> getRole(){
    return roleApi.getRole();
  }

  Future<RoleModel> getRoleById(String id){
    return roleApi.getRoleById(id);
  }

  Future<void> deleteRole(String id) {
    return roleApi.deleteRole(id);
  }

  Future<void> updateRole(String id, Map<String, dynamic> data){
    return roleApi.updateRole(id, data);
  }



}