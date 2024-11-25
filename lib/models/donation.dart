class Donation {
  final String userAccountId;
  final String donationType;
  final String dateTime;
  final double amount;
  final String description;
  final String status;

  Donation({
    required this.userAccountId,
    required this.donationType,
    required this.dateTime,
    required this.amount,
    required this.description,
    required this.status,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      userAccountId: json['userAccountId'],
      donationType: json['donationType'],
      dateTime: json['dateTime'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      status: json['status'],
    );
  }
}
