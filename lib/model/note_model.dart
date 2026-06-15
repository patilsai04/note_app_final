import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
enum SyncStatus {
  @HiveField(0)
  synced,

  @HiveField(1)
  pendingSync,

  @HiveField(2)
  conflict,
}

@HiveType(typeId: 0)
class Note {

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  DateTime updatedAt;

  @HiveField(4)
  SyncStatus syncStatus;

  @HiveField(5)
  bool isDeleted;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
    required this.syncStatus,
    this.isDeleted = false,
  });
}