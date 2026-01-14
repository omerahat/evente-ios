class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String? bannerImageUrl;
  final int categoryId;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.bannerImageUrl,
    required this.categoryId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['eventTime'] != null 
          ? DateTime.parse(json['eventTime'])
          : DateTime.now(),
      location: json['locationName'] ?? '',
      bannerImageUrl: json['bannerImageUrl'],
      categoryId: json['categoryId'] ?? 0,
    );
  }
}


