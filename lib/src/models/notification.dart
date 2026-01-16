class Notification {
  final String id;
  final String event;
  final String message;
  final DateTime createdAt; // Changed to DateTime

  Notification({
    required this.id,
    required this.event,
    required this.message,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'],
      event: json['event'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(), // Parse as DateTime and convert to local time
    );
  }
}
