class Bookmark {
  final int id, colorCode;
  int ayahId = -1, page = -1;
  final String name;

  Bookmark({
    required this.id,
    required this.colorCode,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ayahId': ayahId,
        'page': page,
        'color': colorCode,
        'name': name,
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json['id'],
        colorCode: json['color'],
        name: json['name'] ?? '',
      )
        ..ayahId = json['ayahId']
        ..page = json['page'];
}
