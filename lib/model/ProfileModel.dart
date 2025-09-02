class ProfileModel {
  final int id;
  final String firstName;
  final String secondName;
  final String thirdName;
  final String email;
  final String? phone;
  final String role;
  final String? profileImage;
  final int ordersCount;
  final int shipmentsCount;
  final String customerStatus;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
    required this.email,
    this.phone,
    required this.role,
    this.profileImage,
    required this.ordersCount,
    required this.shipmentsCount,
    required this.customerStatus,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      secondName: json['second_name'] ?? '',
      thirdName: json['third_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profile_image'],
      ordersCount: json['orders_count'] ?? 0,
      shipmentsCount: json['shipments_count'] ?? 0,
      customerStatus: json['customer_status'] ?? '',
    );
  }

  String get fullName => '$firstName $secondName $thirdName'.trim();

  String get initials {
    String first = firstName.isNotEmpty ? firstName[0] : '';
    String second = secondName.isNotEmpty ? secondName[0] : '';
    return (first + second).toUpperCase();
  }
}