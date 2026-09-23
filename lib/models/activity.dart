class Activity {
  final String id;
  String title;
  String category;
  String description;
  DateTime deadline;
  bool isDone;
  bool isFavorite;

  Activity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.deadline,
    this.isDone = false,
    this.isFavorite = false,
  });

  Activity copyWith({
    String? title,
    String? category,
    String? description,
    DateTime? deadline,
    bool? isDone,
    bool? isFavorite,
  }) {
    return Activity(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isDone: isDone ?? this.isDone,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

const List<String> kCategoriOptions = [
  'Kuliah',
  'Organisasi',
  'Pribadi',
  'Tugas',
];
