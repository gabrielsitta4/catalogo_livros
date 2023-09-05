import 'package:catalogo_livros/db/database.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_livros/models/book.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final genreController = TextEditingController();
  final yearController = TextEditingController();

  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _refreshBookList();
  }

  _refreshBookList() async {
    List<Book> freshBooks = await dbHelper.getAllBooks();
    setState(() {
      books = freshBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Livros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEditBookDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return _buildBookListItem(books[index]);
        },
      ),
    );
  }

  Widget _buildBookListItem(Book book) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => _showAddEditBookDialog(book: book),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Excluir',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            await dbHelper.deleteBook(book.id!);
            _refreshBookList();
          },
        ),
      ],
      child: ListTile(
        title: Text(book.title),
        subtitle: Text(book.author),
        onTap: () => _showAddEditBookDialog(book: book),
      ),
    );
  }

  _showAddEditBookDialog({Book? book}) {
    if (book != null) {
      titleController.text = book.title;
      authorController.text = book.author;
      genreController.text = book.genre;
      yearController.text = book.year.toString();
    } else {
      titleController.clear();
      authorController.clear();
      genreController.clear();
      yearController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book == null ? 'Adicionar Livro' : 'Editar Livro'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Autor'),
                ),
                TextField(
                  controller: genreController,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                ),
                TextField(
                  controller: yearController,
                  decoration:
                      const InputDecoration(labelText: 'Ano de Publicação'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                Book newBook = Book(
                  title: titleController.text,
                  author: authorController.text,
                  genre: genreController.text,
                  year: int.parse(yearController.text),
                );

                if (book == null) {
                  await dbHelper.insertBook(newBook);
                } else {
                  await dbHelper.updateBook(book.copy(
                    id: book.id,
                    title: titleController.text,
                    author: authorController.text,
                    genre: genreController.text,
                    year: int.parse(yearController.text),
                  ));
                }

                _refreshBookList();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    genreController.dispose();
    yearController.dispose();
    super.dispose();
  }
}
