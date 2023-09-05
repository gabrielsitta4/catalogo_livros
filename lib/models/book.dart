class Book {
  int? id;
  String title;
  String author;
  String genre;
  int year;

  Book(
      {this.id,
      required this.title,
      required this.author,
      required this.genre,
      required this.year});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'year': year,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      genre: map['genre'],
      year: map['year'],
    );
  }

  Book copy({
    int? id,
    String? title,
    String? author,
    String? genre,
    int? year,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      year: year ?? this.year,
    );
  }
}
