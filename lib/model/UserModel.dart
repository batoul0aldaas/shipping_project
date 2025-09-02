class UserModel {
  int? id;
  String firstName;
  String secondName;
  String thirdName;
  String email;
  String? phone;
  String? token;
  bool isVerified = false;
  final String password;
  String? commercialRegister;

  UserModel({
    this.id,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
    required this.email,
    this.phone,
    this.token,
    required this.password,
    required this.isVerified,
    this.commercialRegister,
  });

  Map<String, String> toRegisterMap() {
    return {
      'first_name': firstName,
      'second_name': secondName,
      'third_name': thirdName,
      'email': email,
      'phone': phone ?? '',
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      secondName: json['second_name'] ?? '',
      thirdName: json['third_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      commercialRegister: json['commercial_register'],
      password: '',
      isVerified: false,
    );
  }

  void setTOKEN(String token) {
    this.token = token;
  }

  void setIsVerified(bool value) {
    isVerified = value;
  }
}
