class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String mobile;
  final String country;
  final String city;
  final String address;
  final List<String> roles;
  final bool deleted;
  final String? created_date;
  final String? created_time;
  final String? updated_date;
  final String? updated_time;


  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.mobile,
    required this.country,
    required this.city,
    required this.address,
    required this.roles,
    this.deleted = false,
    this.created_date,
    this.created_time,
    this.updated_date,
    this.updated_time,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      gender: json['gender'],
      mobile: json['mobile'],
      country: json['country'],
      city: json['city'],
      address: json['address'],
      roles: List<String>.from(json['roles']),
      deleted: json['deleted'] ?? false,
      created_date: json['created_date'] ?? '',
      created_time: json['created_time'] ?? '',
      updated_date: json['updated_date'] ?? '',
      updated_time: json['updated_time'] ?? '',
    );
  }
}
