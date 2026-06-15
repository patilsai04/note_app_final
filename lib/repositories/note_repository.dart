import '../model/note_model.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

class NoteRepository {

  final HiveService hiveService = HiveService();
  final ApiService apiService = ApiService();

  Future<void> addNote(Note note) async {
    await hiveService.addNote(note);
  }

  Future<List<Note>> getNotes() async {
    return await hiveService.getNotes();
  }

  Future<void> updateNote(Note note) async {
    await hiveService.updateNote(note);
  }

  Future<void> deleteNote(String id) async {
    await hiveService.deleteNote(id);
  }

  //Api
  Future<List<Note>> getPendingNotes() async {
    return await hiveService.getPendingNotes();
  }

  // upload note to server
  Future<bool> uploadNote(Note note) async {
    return await apiService.uploadNote(note);
  }

  Future<void> markAsSynced(Note note) async {
    await hiveService.markAsSynced(note);
  }

}