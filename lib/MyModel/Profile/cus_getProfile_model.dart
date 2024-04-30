class UserProfile {
  final String name;
  final String image;
  final String phone;
  final String otp;

  UserProfile({
    required this.name,
    required this.image,
    required this.phone,
    required this.otp,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      image: json['image'],
      phone: json['phone'],
      otp: json['otp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'phone_number': phone,
    };
  }
}
