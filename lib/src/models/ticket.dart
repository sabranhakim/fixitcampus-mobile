class Ticket {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String status;
  final DateTime? createdAt; // Dibuat nullable

  Ticket({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      // Periksa null sebelum parsing
      createdAt: json.containsKey('created_at') && json['created_at'] != null 
                 ? DateTime.parse(json['created_at']) 
                 : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
