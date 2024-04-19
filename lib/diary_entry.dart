class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final double latitude;
  final double longitude;
  final String date;
  final String? place;
  final String? imagePath;

  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.place,
    this.imagePath,
  });

  DiaryEntry copyWith({
    int? id,
    String? title,
    String? content,
    double? latitude,
    double? longitude,
    String? date,
    String? place,
    String? imagePath,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      date: date ?? this.date,
      place: place ?? this.place,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> data) => DiaryEntry(
        id: data['id'],
        title: data['title'],
        content: data['content'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        date: data['date'],
        place: data['place'],
        imagePath:data['imagePath']
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'latitude': latitude,
        'longitude': longitude,
        'date': date,
        "place": place,
        'imagePath': imagePath
      };
}
