import 'package:flutter/material.dart';
import 'change_pin_screen.dart';
import 'pin_screen.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../services/pin_service.dart';
import '../widgets/note_form.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NoteService noteService;
  late PinService _pinService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    noteService = NoteService();
    _pinService = PinService();
    _initializeNoteService();
  }

  Future<void> _initializeNoteService() async {
    try {
      await noteService.initialize();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing NoteService: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePinScreen(),
                ),
              );
              final isLoggedIn = await _pinService.isLoggedIn();
              if (!isLoggedIn) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PinScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<List<Note>>(
              valueListenable: noteService.notesNotifier,
              builder: (context, notes, _) {
                if (notes.isEmpty) {
                  return const Center(child: Text('No notes available'));
                } else {
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.content),
                              const SizedBox(height: 8),
                              Text(
                                'Created: ${note.createdAt.toString()}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Last Edited: ${note.lastEditedAt.toString()}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await noteService.delete(note);
                            },
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteForm(note: note),
                              ),
                            );
                            // Note: No need to initialize here, ValueNotifier will update UI
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteForm(),
            ),
          );
          // Note: No need to initialize here, ValueNotifier will update UI
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    noteService.dispose();
    super.dispose();
  }
}
