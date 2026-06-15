import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/note_model.dart';
import '../repositories/note_repository.dart';
import '../providers/note_state_provider.dart';
import 'connectivity_service.dart';

class SyncService {
  final Ref ref;
  final NoteRepository repository = NoteRepository();
  final ConnectivityService connectivityService = ConnectivityService();
  bool hasConflict = false;
  SyncService(this.ref);

  void startListening() {
    // listen() is used to change the connectivity status
    connectivityService.connectivityStream.listen((result) async {
        if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
          await syncNotes();
        }
      },
    );
  }

  Future<void> syncIfOnline() async {
    final result = await connectivityService.connectivity.checkConnectivity();
    if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
      await syncNotes();
    }
  }

  Future<void> syncNotes()
  async {
    List<Note> pendingNotes = await repository.getPendingNotes();
    if (pendingNotes.isEmpty) return;

    bool anySynced = false;
    for (Note note in pendingNotes) {
      bool success = await repository.uploadNote(note);
      if (success) {
        anySynced = true;
        if (hasConflict) {
          note.syncStatus = SyncStatus.conflict;
          await repository.updateNote(note);
        } else {
          await repository.markAsSynced(note);
        }
      }
    }

    if (anySynced) {
      ref.read(noteStateProvider.notifier).loadNotes();
    }
  }
}