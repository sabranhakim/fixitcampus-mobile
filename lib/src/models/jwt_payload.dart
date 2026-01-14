class JwtPayloadModel {
  final int userId;
  final String role;

  JwtPayloadModel({
    required this.userId,
    required this.role,
  });

  factory JwtPayloadModel.fromJson(Map<String, dynamic> json) {
    return JwtPayloadModel(
      userId: json['user_id'],
      role: json['role'],
    );
  }
}
