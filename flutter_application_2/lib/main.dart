import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData.dark(
        //primaryColor: Colors.red,
        //secondaryHeaderColor: :Colors.red[200]
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18); 
  @override
  Widget build(BuildContext context) {
    return Scaffold (           
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(onPressed: _pushSaved, icon: Icon(Icons.list)),
        ],
      ),
      body: _buildSuggestions(),
    );                
  }
  Widget _buildSuggestions() {
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
        return _buildRow(_suggestions[index]);
      }
    );
  }
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon( //aparecer o ícone de coração
      alreadySaved ? Icons.favorite : Icons.favorite_border,
      color: alreadySaved ? Colors.red : null,
    ),
    onTap: () {  //ao tocar no coração
      setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else {
          _saved.add(pair);
        }
      });
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

  Widget _buildSave () {
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
                Scaffold
                    .of(context)
                    .showSnackBar(
                      SnackBar(
                        content: 
                        Text(
                          "$item foi removido"),
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
                  borderRadius: BorderRadius.circular(12)
                  ), 
                child: Align(
                  alignment: Alignment(-0.8,0),
                  child: Icon(Icons.delete, color: Colors.black38),
                ),
              ),


          );
      },
    );
  }

}