class Sugestao {
  final String first;
  final String second;
  bool liked;


  Sugestao(this.first, this.second, this.liked);

  @override
  String toString() {
    return 'Sugestao{first: $first, second: $second, liked: $liked}';
  }
}