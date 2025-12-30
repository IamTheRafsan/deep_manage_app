import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Save token and user data
  static Future<void> saveUserData(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();

    // Extract token and user
    String token = response['token']['token'];
    Map<String, dynamic> user = response['token']['user'];

    // Save token
    await prefs.setString('token', token);
    // Save user data as JSON string
    String userJson = jsonEncode(user);
    await prefs.setString('user_data', jsonEncode(user));
  }

  // Retrieve token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Retrieve user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_data');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  // Clear all saved data (logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_data');
  }
}
