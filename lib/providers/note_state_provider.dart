import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/note_model.dart';
import '../repositories/note_repository.dart';
import 'note_provider.dart';

class NoteNotifier extends StateNotifier<List<Note>> {
  final NoteRepository repository;
  // Added Ref to access syncServiceProvider and run syncIfOnline checks
  final Ref ref;

  NoteNotifier(this.repository, this.ref) : super([]) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    state = await repository.getNotes();
  }

  Future<void> addNote(Note note) async {
    await repository.addNote(note,);
    await loadNotes();
    // Trigger synchronization immediately if online when a new note is added
    ref.read(syncServiceProvider).syncIfOnline();
  }

  Future<void> updateNote(Note note) async {
    await repository.updateNote(note,);
    await loadNotes();
    // Trigger synchronization immediately if online when a note is updated
    ref.read(syncServiceProvider).syncIfOnline();
  }

  Future<void> deleteNote(String id) async {
    await repository.deleteNote(id,);
    await loadNotes();
  }
}

final noteStateProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
  final repository = ref.read(noteRepositoryProvider);
  // Pass ref instance to the notifier
  return NoteNotifier(repository, ref);
});