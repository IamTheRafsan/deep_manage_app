import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/AuthApi/AuthApi.dart';
import '../Model/LoginModel/LoginRequest.dart';
import '../Model/User/UserModel.dart';

class AuthRepository {
  final AuthApi authApi;

  AuthRepository(this.authApi);

  Future<String> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await authApi.login(request);

      final jwt = response.token;
      final user = response.user;

      await _saveToken(jwt);
      await _saveUserData(user);

      return jwt;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('userId', user.userId);
    await prefs.setString('firstName', user.firstName);
    await prefs.setString('lastName', user.lastName);
    await prefs.setString('email', user.email);
    await prefs.setString('gender', user.gender);
    await prefs.setString('mobile', user.mobile);
    await prefs.setString('country', user.country);
    await prefs.setString('city', user.city);
    await prefs.setString('address', user.address);
    await prefs.setStringList('roles', user.roles);
  }

  Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('userId');
    if (userId == null) return null;

    return UserModel(
      userId: userId,
      firstName: prefs.getString('firstName') ?? '',
      lastName: prefs.getString('lastName') ?? '',
      email: prefs.getString('email') ?? '',
      gender: prefs.getString('gender') ?? '',
      mobile: prefs.getString('mobile') ?? '',
      country: prefs.getString('country') ?? '',
      city: prefs.getString('city') ?? '',
      address: prefs.getString('address') ?? '',
      roles: prefs.getStringList('roles') ?? [],
      deleted: false,
      created_date: prefs.getString('created_date'),
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('email');
    await prefs.remove('gender');
    await prefs.remove('mobile');
    await prefs.remove('country');
    await prefs.remove('city');
    await prefs.remove('address');
    await prefs.remove('roles');
  }

  Future<bool> validateToken() async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        print('❌ No token found');
        return false;
      }

      // Check if token is expired
      if (JwtDecoder.isExpired(token)) {
        print('❌ Token expired');
        return false;
      }

      print('✅ Token is valid (not expired)');

      // Optional: Get token info
      final expiryDate = JwtDecoder.getExpirationDate(token);
      final timeLeft = expiryDate.difference(DateTime.now());
      print('⏰ Token expires in: ${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m');

      return true;
    } catch (e) {
      print('❌ Token validation error: $e');
      return false;
    }
  }
}