class Notification {
  final String id;
  final String event;
  final String message;
  final String createdAt;

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
      createdAt: json['createdAt'],
    );
  }
}
