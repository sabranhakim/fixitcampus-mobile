class Report {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final String status;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.status,
  });
}
