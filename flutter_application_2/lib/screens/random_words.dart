import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_application_1/screens/edit_suggestion.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  bool gridPressed = false;

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
                      debugPrint('$gridPressed');
                    } else {
                      gridPressed = true;
                      debugPrint('$gridPressed');
                    }
                  }),
              icon: Icon(Icons.grid_goldenratio))
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    switch (gridPressed) {
      case false:
        return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext _context, int i) {
              if (i.isOdd) {
                return Divider();
              }

              final int index = i ~/ 2;
              if (index >= _suggestions.length) {
                _suggestions.addAll(generateWordPairs().take(10));
              }
              return _buildRow(_suggestions[index], index);
            });
      case true:
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext _context, int i) {
              final int index = i;
              if (index >= _suggestions.length) {
                _suggestions.addAll(generateWordPairs().take(10));
              }
              return _buildRow(_suggestions[index], index);
            });
    }
    return Text('nada');
  }

  Widget _buildRow(WordPair pair, int index) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: InkWell(
        onTap: () {
          //ao tocar no coração
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EditSuggestion(suggestion: pair.toString());
        })).then(
          (newWord) {
            if (newWord != null) {
              setState(
                () {
                  _suggestions[index] = WordPair('teste1', 'teste2');
                },
              );
            }
          },
        );
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
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

  Widget _buildSave() {
    final divided = ListTile.divideTiles(
        context: context,
        tiles: _saved.map(
          (WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        )).toList();

    switch (gridPressed) {
      case false:
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _saved.length,
          itemBuilder: (context, index) {
            final item = divided[index];
            return Dismissible(
              child: item,
              key: ValueKey(item),
              onDismissed: (direction) {
                // Remove o item da fonte de dados
                setState(() {
                  _saved.removeAt(index);
                });
                // Exibe o snackbar
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$item foi removido"),
                  ),
                );
              },
              background: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.red,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Align(
                  alignment: Alignment(-0.8, 0),
                  child: Icon(Icons.delete, color: Colors.black38),
                ),
              ),
            );
          },
        );
      case true:
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: _saved.length,
            itemBuilder: (BuildContext _context, int i) {
              return _buildRow(_saved[i], i);
            });
    }
    return Text("nada");
  }
}
