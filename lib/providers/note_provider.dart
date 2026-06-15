import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/note_model.dart';
import '../repositories/note_repository.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

final noteListProvider = FutureProvider<List<Note>>((ref) async {
  final repository = ref.read(noteRepositoryProvider);
  return repository.getNotes();
});

// Added syncServiceProvider to manage the life-cycle of SyncService and start listening to network changes
final syncServiceProvider = Provider<SyncService>((ref) {
  final syncService = SyncService(ref);
  syncService.startListening();
  return syncService;
});

// Added connectivityStreamProvider to monitor active connection status (online/offline) in the UI
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return ConnectivityService().connectivityStream;
});