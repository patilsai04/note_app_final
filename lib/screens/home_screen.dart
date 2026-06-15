import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/note_model.dart';
import '../providers/note_state_provider.dart';
import '../providers/note_provider.dart';
import 'add_note_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  Widget _buildSyncBadge(SyncStatus status) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status) {
      case SyncStatus.synced:
        bgColor = const Color(0xFFECFDF5);
        textColor = const Color(0xFF059669);
        icon = Icons.check_circle_outline_rounded;
        text = "Synced";
        break;
      case SyncStatus.pendingSync:
        bgColor = const Color(0xFFFFF7ED);
        textColor = const Color(0xFFD97706);
        icon = Icons.sync_rounded;
        text = "Pending Sync";
        break;
      case SyncStatus.conflict:
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFDC2626);
        icon = Icons.error_outline_rounded;
        text = "Conflict";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   // active in background
    ref.watch(syncServiceProvider);

    final connectionAsync = ref.watch(connectivityStreamProvider);
    final bool isOnline = connectionAsync.when(
      data: (result) => result.isNotEmpty && !result.contains(ConnectivityResult.none),
      error: (_, __) => false,
      loading: () => true,
    );

    final notes = ref.watch(noteStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App",),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isOnline ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isOnline ? const Color(0xFFA7F3D0) : const Color(0xFFFCA5A5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isOnline ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isOnline ? "Online" : "Offline",
                    style: TextStyle(
                      color: isOnline ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: notes.isEmpty ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "No Notes Available",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Tap the '+' button below to add your first note.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ) : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          Note note = notes[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          note.body,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildSyncBadge(note.syncStatus),
                            const SizedBox(width: 12),
                            Text(
                              _formatDate(note.updatedAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 20, color: Colors.grey.shade500),
                        onPressed: () async {
                          await Navigator.push(context,
                            MaterialPageRoute(
                              builder: (_) => AddNoteScreen(note: note,),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red.shade400),
                        onPressed: () async {
                          await ref.read(noteStateProvider.notifier).deleteNote(note.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add,),
      ),
    );
  }
}