import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
class Sugestao {
  final WordPair wordpair;
  bool liked;

  Sugestao(this.wordpair, this.liked);

  @override
  String toString() {
    return 'Sugestao{wordpair: $wordpair, liked: $liked}';
  }
}