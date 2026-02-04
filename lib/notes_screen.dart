import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final notesRef = FirebaseFirestore.instance
        
        .collection('notes');
    final notesQuery = notesRef.orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notesQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!.docs;
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    title: Text(
                      note['text'],
                      style: const TextStyle(fontSize: 16),
                    ),
                   
                    onTap: () {
                      editNoteDialog(context, notesRef, note.id, note['text']);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => note.reference.delete(),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(context, notesRef),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNote(BuildContext context, CollectionReference notesCollectionRef) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Write note...'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              notesCollectionRef.add({
                'text': controller.text.trim(),
                'createdAt': Timestamp.now(),
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  
  void editNoteDialog(BuildContext context, CollectionReference notesCollectionRef,
      String docId, String oldText) {
    final editController = TextEditingController(text: oldText);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit'),
            content: TextField(
              controller: editController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'update',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  
                  await notesCollectionRef.doc(docId).update({
                    'text': editController.text.trim(),
                     
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
