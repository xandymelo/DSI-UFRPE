import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../DAO/sugestao_dao.dart';
import '../models/sugestao.dart';
import '../widgets/progress.dart';


//RESOLVER PROBLEMA DO _BUILDROW COM UMA QUERY WHERE LIKED = TRUE
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  bool gridPressed = false;
  final _biggerFont = const TextStyle(fontSize: 18);

  // @override
  // void InitState() {
  //   super.initState();
  //   SugestaoDAO.armazena20Palavras();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(onPressed: _pushSaved, icon: Icon(Icons.list)),
          IconButton(
              onPressed: () => setState(() {
                    if (gridPressed) {
                      gridPressed = false;
                    } else {
                      gridPressed = true;
                    }
                  }),
              icon: Icon(Icons.grid_goldenratio))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pushEdit(Sugestao('', '', false), -1),
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    switch (gridPressed) {
      case false:
        return FutureBuilder<List<Sugestao>>(
            // padding: const EdgeInsets.all(16),
            // count: SugestaoDAO.suggestions.length,
            future: SugestaoDAO.findAll(),
            builder: (context, snapshot) {
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
                        return _buildRow(sugestoes[index], index);
                      },
                    );
                  }
              }
              return Text('Unknown error');
            }
            // (BuildContext _context, int i) {
            // if (i.isOdd) {
            //   return Divider();
            // }

            // final int index = i ~/ 2;
            // if (index >= SugestaoDAO.suggestions.length) {
            //   final Iterable<WordPair> wordsGenerated =
            //       generateWordPairs().take(10);
            //   final List<Sugestao> wordsConverted = [];
            //   wordsGenerated.forEach((element) {
            //     wordsConverted.add(Sugestao(element.first.toString(),
            //         element.second.toString(), false));
            //   });
            //   SugestaoDAO.suggestions.addAll(wordsConverted);
            // }
            // return _buildRow(SugestaoDAO.suggestions[i], i);
            // }
            );
      case true:
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext _context, int i) {
              final int index = i;
              if (index >= SugestaoDAO.suggestions.length) {
                final Iterable<WordPair> wordsGenerated =
                    generateWordPairs().take(10);
                final List<Sugestao> wordsConverted = [];
                wordsGenerated.forEach((element) {
                  wordsConverted.add(Sugestao(element.first.toString(),
                      element.second.toString(), false));
                });
                SugestaoDAO.suggestions.addAll(wordsConverted);
              }
              return _buildRow(SugestaoDAO.suggestions[index], index);
            });
    }
    return Text('nada');
  }

  Widget _buildRowSaved(int index) {
    final List<Sugestao> tilesAsLlist = SugestaoDAO.suggestions
        .where((element) => element.liked == true)
        .toList();
    final Iterable<ListTile> listTiles = tilesAsLlist.map(
      (Sugestao pair) {
        return ListTile(
          title: Text(
            WordPair(pair.first, pair.second).asPascalCase,
            style: _biggerFont,
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
        setState(() {
          SugestaoDAO.suggestions[index].liked = false;
        });
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

  Widget _buildSave() {
    /*switch (gridPressed) {
      case false:*/
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: SugestaoDAO.suggestions
          .where((element) => element.liked == true)
          .toList()
          .length,
      itemBuilder: (context, index) {
        return _buildRowSaved(index);
      },
    );
    /*case true:
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: SugestaoDAO.suggestions.where((element) => element.liked == true).toList().length,
            itemBuilder: (BuildContext _context, int i) {
              return _buildRowSaved(i);
            });
    }*/
  }

  Widget _buildRow(Sugestao pair, int index) {
    final alreadySaved = SugestaoDAO.suggestions[index].liked;
    return ListTile(
      title: Text(
        WordPair(pair.first, pair.second).asPascalCase,
        style: _biggerFont,
      ),
      trailing: InkWell(
        onTap: () {
          //ao tocar no coração
          setState(() {
            if (alreadySaved) {
              /*SugestaoDAO.suggestions[index].liked = false;*/
              pair.liked = false;
            } else {
              /*SugestaoDAO.suggestions[index].liked = true;*/
              pair.liked = true;
            }
          });
        },
        child: Icon(
          //aparecer o ícone de coração
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
      ),
      onTap: () {
        _pushEdit(pair, index);
      },
    );
  }

  void _pushEdit(Sugestao pair, int index) async {
    return await Navigator.pushNamed(context, '/edit', arguments: {
      'first': pair.first,
      'second': pair.second,
    }).then(
      (newWord) {
        final List<String> users = newWord as List<String>;
        //caso o index -1 é o caso do floating action button,ou seja, adicionar a lista
        if (index == -1 && newWord[0] == 'M') {
          debugPrint('floatingbutton');
          setState(() {
            SugestaoDAO.insert(Sugestao(newWord[1], newWord[2], false));
            debugPrint('${SugestaoDAO.suggestions[0]}');
          });
        } else if (newWord[0] == 'M' && newWord[1] != '' && newWord[2] != '') {
          debugPrint('modificar');
          setState(
            () {
              SugestaoDAO.suggestions[index] =
                  Sugestao(newWord[1], newWord[2], pair.liked);
            },
          );
        } else if (newWord[0] == 'D' ||
            (newWord[1] == '' && newWord[2] == '')) {
          debugPrint('deletar');
          setState(() {
            SugestaoDAO.suggestions.remove(pair);
          });
        }
      },
    );
  }

  Future _pushSaved() async {
    return await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: _buildSave(),
          );
        },
      ),
    );
  }
}
