class Note {
  String title;
  String content;
  DateTime date;

  Note({this.title, this.content, this.date});
}

final Map<String, int> categories = {
  'Тэмдэглэл': 112,
  'Ажил': 58,
  'Хувийн': 23,
  'Гүйцэтгэсэн': 31,
};

final List<Note> notes = [
  Note(
    title: 'Buy ticket',
    content: 'Buy airplane ticket through Kayak for \$318.38',
    date: DateTime(2019, 10, 10, 8, 30),
  ),
  Note(
    title: 'Walk with dog',
    content: 'Walk on the street with my favorite dog.',
    date: DateTime(2019, 10, 10, 8, 30),
  ),
];
