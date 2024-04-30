class SupportModel {
  final String id;
  final String name;
  final String email;
  final String reply;
  final String userVendorId;
  final String taruffId;
  final String message;
  final String createdDate;

  SupportModel({
    required this.id,
    required this.name,
    required this.email,
    required this.reply,
    required this.userVendorId,
    required this.taruffId,
    required this.message,
    required this.createdDate,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      reply: json['reply'],
      userVendorId: json['user_vendor_id'],
      taruffId: json['taruff_id'],
      message: json['message'],
      createdDate: json['created_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'message': message,

    };
  }

}
