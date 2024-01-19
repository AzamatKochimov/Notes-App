import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/service/hive_service.dart';

class DetailPage extends StatefulWidget {
  static const id = "/detail_page";
  final Note? note;
  const DetailPage({super.key, this.note});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String formattedDate = DateFormat('yyyy-MM-dd, HH:mm').format(DateTime.now());

  Future<void> _store() async {
    if (widget.note == null) {
      Note note = Note(
          id: titleController.text.hashCode,
          createTime: formattedDate,
          title: titleController.text,
          content: contentController.text);
      List<Note> list = await DBService.loadNotes();
      list.add(note);
      await DBService.storeNote(list);
      Navigator.pop(context, true);
    } else {
      Note note = Note(
          id: widget.note!.id,
          createTime: widget.note!.createTime,
          title: titleController.text,
          content: contentController.text,
          editTime: formattedDate);
      List<Note> list = await DBService.loadNotes();
      list.removeWhere((element) => element.id == note.id);
      list.add(note);
      await DBService.storeNote(list);
      Navigator.pop(context, true);
    }
  }

  Future<void> _delete() async {
    if (widget.note != null) {
      List<Note> list = await DBService.loadNotes();
      list.removeWhere((element) => element.id == widget.note!.id);
      await DBService.storeNote(list);

      Navigator.pop(context, true);
    }
  }


  void loadNote(Note? note) {
    if (note != null) {
      setState(() {
        titleController.text = note.title;
        contentController.text = note.content;
      });
    }
  }

  @override
  void initState() {
    loadNote(widget.note);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await _delete();
            },
            icon: const Icon(Icons.delete_outline, size: 28),
          ),
          IconButton(
            onPressed: () async {
              await _store();
            },
            icon: const Icon(Icons.done_outline),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: titleController,
              maxLength: 25,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          Expanded(
            flex: 8,
            child: TextField(
              controller: contentController,
              maxLines: 50,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  hintText: "Content",
                  hintStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
