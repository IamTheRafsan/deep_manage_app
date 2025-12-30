import 'package:deep_manage_app/Model/User/UserModel.dart';

import '../ApiService/UserApi/UserApi.dart';

class UserRepository{
  final UserApi userApi;

  UserRepository({required this.userApi});

  //Create new user
  Future<void> addUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    required int mobile,
    required String country,
    required String city,
    required String address,
    required List<String> roleId,
    List<int>? warehouse,
    List<int>? outlet,
  }) async {
    final data = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "gender": gender,
      "mobile": mobile,
      "country": country,
      "city": city,
      "address": address,
      "role_id": roleId,
      "warehouse": warehouse,
      "outlet": outlet,
    };

    await userApi.addUser(data);
  }

  //View all the users
  Future<List<UserModel>> getUser(){
    return userApi.getUser();
  }


  //View user by id
  Future<UserModel> getUserById(String id) {
    return userApi.getUserById(id);
  }

  //delete user by id
  Future<void> deleteUser(String id) {
    return userApi.deleteUser(id);
  }

  Future<void> updateUser(String id, Map<String, dynamic> data){
    return userApi.updateUser(id, data);
  }
}