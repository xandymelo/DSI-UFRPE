import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../DAO/sugestao_dao.dart';
import '../models/sugestao.dart';
import '../widgets/progress.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  bool gridPressed = false;
  // @override
  // void InitState() {
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(onPressed: _pushSaved, icon: Icon(Icons.list)),
          IconButton(
              onPressed: () =>
                  setState(() {
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
        // return ListView.builder(itemBuilder: (context, index) {
        //   return _buildRow(SugestaoDAO.suggestions[index], index);
        // },
        // itemCount: SugestaoDAO.suggestions.length,);
        return FutureBuilder<List<Sugestao>>(
      // padding: const EdgeInsets.all(16),
      // count: suggestions.length,
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
            List<Sugestao> sugestoes = [];
            if (snapshot.data != null) {
              sugestoes = snapshot.data as List<Sugestao>;
            }
            debugPrint('FutureBuilder: ${sugestoes.length}');
              return ListView.builder(
                itemCount: sugestoes.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildRow(sugestoes[index], index);
                },
              );
        }
        return Text('Unknown error');
      }
      );
      case true:
        return FutureBuilder<List<Sugestao>>(
          // padding: const EdgeInsets.all(16),
          // count: suggestions.length,
            initialData: [],
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
                    return GridView.builder(
                        itemCount: sugestoes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (BuildContext _context, int index) {
                          return _buildRow(sugestoes[index], index);
                        });
                  }
              }
              return Text('Unknown error');
            }
        );
    }
    return Text('nada');
  }




  Widget _buildRow(Sugestao pair, int index) {
    final alreadySaved = pair.liked;
    return ListTile(
      title: Text(
        WordPair(pair.first, pair.second).asPascalCase,
        style: SugestaoDAO.biggerFont,
      ),
      trailing: InkWell(
        onTap: () async {
          //ao tocar no coração
          if (alreadySaved) {
            await SugestaoDAO.modify(pair, Sugestao(pair.first, pair.second, false));
            pair.liked = false;
          } else {
            await SugestaoDAO.modify(pair, Sugestao(pair.first, pair.second, true));
            pair.liked = true;
          }
          setState(() {});
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
          (newWord) async {
        final List<String> users = newWord as List<String>;
        //caso o index -1 é o caso do floating action button,ou seja, adicionar a lista
        if (index == -1 && newWord[0] == 'M') {
          debugPrint('floatingbutton');
          SugestaoDAO.insert(Sugestao(newWord[1], newWord[2], false));
          setState(() {});
        } else if (newWord[0] == 'M' && newWord[1] != '' && newWord[2] != '') {
          debugPrint('modificar');
          await SugestaoDAO.modify(
              pair, Sugestao(newWord[1], newWord[2], pair.liked));
          setState(() {});
        } else if (newWord[0] == 'D' ||
            (newWord[1] == '' && newWord[2] == '')) {
          debugPrint('deletar');
          await SugestaoDAO.remove(pair);
          setState(() {});
        }
      },
    );
  }

  Future _pushSaved() async {
    return await Navigator.pushNamed(context, '/saved').then((algo) {
      setState(() {});
    });
  }
}
