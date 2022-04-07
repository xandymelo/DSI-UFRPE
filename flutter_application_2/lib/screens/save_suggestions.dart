import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../DAO/sugestao_dao.dart';
import '../models/sugestao.dart';
import '../widgets/progress.dart';

class SaveSuggestions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: _buildSave(),
    );
  }

  Widget _buildSave() {
    return FutureBuilder(
      future: SugestaoDAO.findLiked(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          // TODO: Handle this case.
            break;
          case ConnectionState.waiting:
            return const Progress();
          case ConnectionState.active:
          // TODO: Handle this case.
            break;
          case ConnectionState.done:
            final sugestoes = snapshot.data as List<Sugestao>;
            debugPrint('${sugestoes.length}');
            if (sugestoes.length != 0) {
              return ListView.builder(
                itemCount: sugestoes.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildRowSaved(sugestoes, index, context);
                },
              );
            }
        }
        return Text('Unknown error');
      },
    );
  }
  Widget _buildRowSaved(List<Sugestao> suggestions, int index, BuildContext context) {
    final List<Sugestao> tilesAsLlist =
    suggestions.where((element) => element.liked == true).toList();
    final Iterable<ListTile> listTiles = tilesAsLlist.map(
          (Sugestao pair) {
        return ListTile(
          title: Text(
            WordPair(pair.first, pair.second).asPascalCase,
            style: SugestaoDAO.biggerFont,
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: listTiles,
    ).toList();
    final item = divided[index];
    return Dismissible(
      child: item,
      key: ValueKey(item),
      onDismissed: (direction) {
        // Remove o item da fonte de dados
        SugestaoDAO.modify(suggestions[index], Sugestao(suggestions[index].first,suggestions[index].second, false));
      },
      background: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.yellow,
              ],
            ),
            borderRadius: BorderRadius.circular(12)),
        child: Align(
          alignment: Alignment(-0.8, 0),
          child: Icon(Icons.delete, color: Colors.black38),
        ),
      ),
    );
  }
}
