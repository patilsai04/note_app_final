import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/note_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000/notes";
  Future<bool> uploadNote(Note note) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": note.id,
          "title": note.title,
          "body": note.body,
          "updatedAt": note.updatedAt.toIso8601String(),
          "syncStatus": note.syncStatus.name,
          "isDeleted": note.isDeleted,
        }),
      );
      if (response.statusCode == 201) {
        print("Note Synced Successfully",);
        return true;
      } else {
        print("Sync Failed",);
        return false;
      }
    } catch (e) {
      print("Sync Failed with exception: $e",);
      return false;
    }
  }
}