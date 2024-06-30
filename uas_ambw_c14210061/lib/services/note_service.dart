import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/note.dart';

class NoteService {
  static const String _boxName = 'notes';
  Box<Note>? _box;
  ValueNotifier<List<Note>> _notesNotifier = ValueNotifier<List<Note>>([]);
  bool _initialized = false;

  NoteService() {
    _init();
  }

  Future<void> initialize() async {
    await _init();
  }

  Future<void> _init() async {
    if (_initialized) return; // Prevent reinitializing
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(NoteAdapter());
      }
      _box = await Hive.openBox<Note>(_boxName);
      _updateNotesList();
      _initialized = true;
      print("NoteService initialized successfully.");
    } catch (e) {
      print('Error initializing Hive or opening box: $e');
      rethrow;
    }
  }

  ValueNotifier<List<Note>> get notesNotifier => _notesNotifier;

  Future<void> addOrUpdate(Note note) async {
    await _ensureBoxInitialized();
    try {
      print("Adding/updating note with key: ${note.key}...");
      await _box!.put(note.key, note);
      print("Note added/updated successfully");
      _updateNotesList();
    } catch (e, stackTrace) {
      print("Error adding/updating note: $e");
      print(stackTrace);
    }
  }

  Future<void> delete(Note note) async {
    await _ensureBoxInitialized();
    try {
      if (note.key.isNotEmpty) {
        print("Deleting note with key: ${note.key}...");
        await _box!.delete(note.key);
        print("Note deleted successfully");
        _updateNotesList();
      } else {
        print("Note key is empty, cannot delete.");
      }
    } catch (e, stackTrace) {
      print("Error deleting note: $e");
      print(stackTrace);
    }
  }

  Future<void> _ensureBoxInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await _init();
    }
  }

  void _updateNotesList() {
    _notesNotifier.value = _box!.values.toList();
  }

  void dispose() {
    _notesNotifier.dispose();
    _box!.close();
  }
}
