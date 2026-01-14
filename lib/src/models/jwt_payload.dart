class JwtPayload {
  final int userId;
  final String role;

  JwtPayload({
    required this.userId,
    required this.role,
  });

  factory JwtPayload.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    return JwtPayload(
      userId: data['user_id'],
      role: data['role'],
    );
  }
}
