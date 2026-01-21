import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onTap;
  final List<Color> noteColors;

  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
    required this.noteColors,
  });

  @override
  Widget build(BuildContext context) {
    final int colorIndex = (note['color'] ?? 0) % noteColors.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: noteColors[colorIndex],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note['date'] ?? '',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),

            const SizedBox(height: 8),

            Text(
              note['title'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Text(
                note['description'] ?? '',
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.5,
                ),
                overflow: TextOverflow.fade,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
