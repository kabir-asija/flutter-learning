import 'package:flutter/material.dart';
import 'package:notes_app/database/notes_db.dart';
import 'package:notes_app/screens/note_card.dart';
import 'package:notes_app/screens/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  List<Color> noteColors = [
    Colors.white70,
    Colors.black45,
    Colors.red.shade300,
    Colors.blue.shade300,
    Colors.green.shade300,
    Colors.orange.shade300,
    Colors.purple.shade300,
    Colors.teal.shade300,
    Colors.yellow.shade300,
    Colors.blueGrey.shade300,
    Colors.pink.shade300,
    Colors.cyan.shade300,
    Colors.indigo.shade300,
    Colors.lime.shade300,
  ];

  Future<void> fetchNotes() async {
    final fetchNotes = await NotesDb.instance.getNotes();

    setState(() {
      notes = fetchNotes;
    });
  }

  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NoteDialog(
          colorIndex: colorIndex,
          title: title,
          content: content,
          noteId: id,
          noteColors: noteColors,
          onNoteSaved:
              (
                String newTitle,
                String newDescription,
                int selectedColorIndex,
                String currentDate,
              ) async {
                if (id == null) {
                  await NotesDb.instance.addNote(
                    newTitle,
                    newDescription,
                    currentDate,
                    selectedColorIndex,
                  );
                } else {
                  await NotesDb.instance.updateNote(
                    id,
                    newTitle,
                    newDescription,
                    currentDate,
                    selectedColorIndex,
                  );
                }
                fetchNotes();
              },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
      ),

      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 80,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No notes found!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(
                    note: note,
                    onDelete: () async {
                      await NotesDb.instance.deleteNote(note['id']);
                      fetchNotes();
                    },
                    onEdit: () {
                      showNoteDialog(
                        id: note['id'],
                        title: note['title'],
                        content: note['description'],
                        colorIndex: note['color'],
                      );
                    },

                    onTap: () {
                      showNoteDialog(
                        id: note['id'],
                        title: note['title'],
                        content: note['description'],
                        colorIndex: note['color'],
                      );
                    },
                    noteColors: noteColors,
                  );
                },
              ),
            ),
    );
  }
}
