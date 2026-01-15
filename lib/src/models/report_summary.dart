class ReportSummary {
  final int openTickets;
  final int closedTickets;
  final int totalTickets;

  ReportSummary({
    required this.openTickets,
    required this.closedTickets,
    required this.totalTickets,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      openTickets: json['open_tickets'],
      closedTickets: json['closed_tickets'],
      totalTickets: json['total_tickets'],
    );
  }
}
