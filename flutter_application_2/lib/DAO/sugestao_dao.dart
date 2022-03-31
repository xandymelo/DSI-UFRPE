import 'package:english_words/english_words.dart';
import '../models/sugestao.dart';

class SugestaoDAO {
  static final List<Sugestao> _suggestions = [];

  static get suggestions => _suggestions;

  void armazenaPalavras()  {
    final Iterable<WordPair> wordpairs = generateWordPairs().take(20);
    wordpairs.forEach((element) { _suggestions.add(Sugestao(element.first, element.second, false)); });
  }

  List<Sugestao> findAll() {
    return _suggestions;
  }

  void insert(Sugestao sugestao) {
    _suggestions.add(sugestao);
  }

  static void addAll(Iterable<Sugestao> sugestoes) {
    sugestoes.forEach((element) { _suggestions.add(element); });
  }

  static void remove(Sugestao sugestao) {
    _suggestions.remove(sugestao);
  }
}
