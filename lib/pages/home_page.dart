import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/service/hive_service.dart';
import '../models/note_model.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static const id = "/home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> list = [];

  void loadNotes() async {
    list = await DBService.loadNotes();
    setState(() {});
  }

  void _openDetail() async {
    var result = await Navigator.pushNamed(context, DetailPage.id);
    if (result != null && result == true) {
      loadNotes();
    }
  }

  Future<void> _openDetailWithNote(Note note) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  note: note,
                )));
    if (result != null && result == true) {
      loadNotes();
    }
  }

  @override
  void initState() {
    loadNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Note"),
      ),
      body: MasonryGridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        itemCount: list.length,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _openDetailWithNote(list[index]);
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    list[index].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
                  Center(
                      child: Text(
                    list[index].content,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )),
                  const SizedBox(height: 5),
                  Center(
                      child: Text(
                    list[index].createTime.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  )),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openDetail();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
