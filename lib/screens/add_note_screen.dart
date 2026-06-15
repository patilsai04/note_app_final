import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/note_model.dart';
import '../providers/note_state_provider.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note,});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}
class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      bodyController.text = widget.note!.body;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null
              ? "Add Note"
              : "Edit Note",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Enter note title...",
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: bodyController,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: "Body",
                  hintText: "Type note details here...",
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty || bodyController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Title and Body cannot be empty!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    Note note = Note(
                      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      body: bodyController.text.trim(),
                      updatedAt: DateTime.now(),
                      syncStatus: SyncStatus.pendingSync,
                    );
                    final navigator = Navigator.of(context);
                    if (widget.note == null) {
                      await ref.read(noteStateProvider.notifier).addNote(note);
                    } else {
                      await ref.read(noteStateProvider.notifier).updateNote(note);
                    }
                    navigator.pop();
                  },
                  child: Text(
                    widget.note == null ? "Save Note" : "Update Note",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}