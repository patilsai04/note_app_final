import 'package:hive/hive.dart';
import '../model/note_model.dart';

class HiveService {

  final Box<Note> noteBox =
  Hive.box<Note>('notes');

  // Create
  Future<void> addNote(Note note) async {
    await noteBox.put(note.id, note,);
  }
  // Read
  Future<List<Note>> getNotes() async {
    return noteBox.values.toList();
  }
  // Update
  Future<void> updateNote(Note note) async {
    await noteBox.put(note.id, note,);
  }
  // Delete
  Future<void> deleteNote(String id) async {
    await noteBox.delete(id,);
  }

  Future<List<Note>> getPendingNotes() async {
    return noteBox.values
        .where((note) => note.syncStatus == SyncStatus.pendingSync,).toList();
  }

  //after update the status it will sav again into the hive
  Future<void> markAsSynced(Note note) async {
    note.syncStatus = SyncStatus.synced;
    await noteBox.put(note.id, note,);
  }
}