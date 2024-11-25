class Event {
  final String id;
  final String name;
  final String description;
  final String startTime;
  final String endTime;
  final String status;
  final String createdDate;
  final String modifiedDate;
  final bool isDeleted;
  final double amount;
  final String childId;
  final List<String>
      imageUrls; // Add this line if the images are in a list of URLs.

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdDate,
    required this.modifiedDate,
    required this.isDeleted,
    required this.amount,
    required this.childId,
    required this.imageUrls, // Include imageUrls in the constructor
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      createdDate: json['createdDate'],
      modifiedDate: json['modifiedDate'],
      isDeleted: json['isDeleted'],
      amount: json['amount'],
      childId: json['childId'],
      imageUrls:
          List<String>.from(json['imageUrls'] ?? []), // Parse imageUrls here
    );
  }
}
