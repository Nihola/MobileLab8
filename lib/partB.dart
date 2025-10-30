import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PartBScreen extends StatefulWidget {
  @override
  State<PartBScreen> createState() => _PartBScreenState();
}

class _PartBScreenState extends State<PartBScreen> {
  late Database db;
  List<Map<String, dynamic>> notes = [];

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  Future<void> _initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    db = await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT
        )
      ''');
    });
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final result = await db.query('notes');
    if (mounted) setState(() => notes = result);
  }

  Future<void> _addDummyNote() async {
    await db.insert('notes', {
      'title': 'Dummy Note',
      'content': 'This is a sample note.',
    });
    _loadNotes();
  }

  Future<void> _editNote(Map<String, dynamic> note) async {
    _titleController.text = note['title'];
    _contentController.text = note['content'];

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: _contentController, decoration: InputDecoration(labelText: 'Content')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await db.update(
                'notes',
                {
                  'title': _titleController.text,
                  'content': _contentController.text,
                },
                where: 'id = ?',
                whereArgs: [note['id']],
              );
              Navigator.pop(context);
              _loadNotes();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNote(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      await db.delete('notes', where: 'id = ?', whereArgs: [id]);
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Part B – SQLite Basics')),
      body: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _addDummyNote, child: Text('Add Note')),
              ElevatedButton(onPressed: _loadNotes, child: Text('View Notes')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note['title']),
                  subtitle: Text(note['content']),
                  onTap: () => _editNote(note),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteNote(note['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
