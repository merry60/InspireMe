import 'package:hive/hive.dart';

part 'quote_model.g.dart';

@HiveType(typeId: 0)
class QuoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final bool isFavorite;

  @HiveField(4)
  final bool fromApi;

  @HiveField(5)
  final DateTime? savedAt;

  QuoteModel({
    required this.id,
    required this.text,
    required this.author,
    this.isFavorite = false,
    this.fromApi = false,
    this.savedAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
      isFavorite: json['isFavorite'] as bool? ?? false,
      fromApi: json['fromApi'] as bool? ?? false,
      savedAt:
          json['savedAt'] != null
              ? DateTime.tryParse(json['savedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'isFavorite': isFavorite,
      'fromApi': fromApi,
      'savedAt': savedAt?.toIso8601String(),
    };
  }

  QuoteModel copyWith({
    String? id,
    String? text,
    String? author,
    bool? isFavorite,
    bool? fromApi,
    DateTime? savedAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
      fromApi: fromApi ?? this.fromApi,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  String toString() =>
      'QuoteModel(id: $id, author: $author, isFavorite: $isFavorite)';
}
