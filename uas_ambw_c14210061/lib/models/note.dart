import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime lastEditedAt;

  @HiveField(4)
  String key;

  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastEditedAt,
    String? key,
  }) : key = key ?? const Uuid().v4(); // Generate UUID if key is not provided

  Note copyWith({
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? lastEditedAt,
    String? key,
  }) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      lastEditedAt: lastEditedAt ?? this.lastEditedAt,
      key: key ?? this.key,
    );
  }
}
