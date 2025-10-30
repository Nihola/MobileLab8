import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PartCScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Part C – Full CRUD',
      initialRoute: '/',
      routes: {
        '/': (_) => NoteListScreen(),
        '/detail': (_) => NoteDetailScreen(),
      },
    );
  }
}

class NoteListScreen extends StatefulWidget {
  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Database db;
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  Future<void> _initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    db = await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)');
    });
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final result = await db.query('notes');
    if (mounted) setState(() => notes = result);
  }

  void _openDetail(Map<String, dynamic>? note) async {
    await Navigator.pushNamed(context, '/detail', arguments: {'db': db, 'note': note});
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Notes')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note['title']),
            subtitle: Text(note['content']),
            onTap: () => _openDetail(note),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDetail(null),
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteDetailScreen extends StatefulWidget {
  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Database db;
  Map<String, dynamic>? note;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    db = args['db'];
    note = args['note'];
    if (note != null) {
      _titleController.text = note!['title'];
      _contentController.text = note!['content'];
    }
  }

  Future<void> _saveNote() async {
    final data = {
      'title': _titleController.text,
      'content': _contentController.text,
    };
    if (note == null) {
      await db.insert('notes', data);
    } else {
      await db.update('notes', data, where: 'id = ?', whereArgs: [note!['id']]);
    }
    Navigator.pop(context);
  }

  Future<void> _deleteNote() async {
    if (note != null) {
      await db.delete('notes', where: 'id = ?', whereArgs: [note!['id']]);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = note != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          if (isEditing)
            IconButton(icon: Icon(Icons.delete), onPressed: _deleteNote),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: _contentController, decoration: InputDecoration(labelText: 'Content')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveNote, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
