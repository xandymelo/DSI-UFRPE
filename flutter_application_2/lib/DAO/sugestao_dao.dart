import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import '../models/sugestao.dart';

class SugestaoDAO {
  // static final List<Sugestao> _suggestions = [];
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // static get suggestions => _suggestions;

  static Future armazena20Palavras() async {
    final Iterable<WordPair> wordpairs = generateWordPairs().take(20);
    wordpairs.forEach((element) async {
      await SugestaoDAO.insert(Sugestao(element.first, element.second, false));
    });
  }

  static Future<List<Sugestao>> findAll() async {
    QuerySnapshot query = await db.collection('sugestao').get();
    late List<Sugestao> sugestoes;
    if (query.docs.length == 0) {
      armazena20Palavras();
      sugestoes = await findAll();
    }
    query.docs.forEach((doc) {
      sugestoes
          .add(Sugestao(doc.get('first'), doc.get('second'), doc.get('liked')));
    });
    return sugestoes;
  }

  static Future insert(Sugestao sugestao) async {
    // _suggestions.add(sugestao);
    debugPrint('inserindo...');
    await db.collection('sugestao').doc().set({
      'first': '${sugestao.first}',
      'second': '${sugestao.second}',
      'liked': sugestao.liked
    });
  }


  static Future remove(Sugestao sugestao) async {
    return await db
        .collection('sugestao')
        .where('first', isEqualTo: sugestao.first)
        .where('second', isEqualTo: sugestao.second)
        .where('liked', isEqualTo: sugestao.liked).get().then((id) async {
          if (id != null) {
            await db.collection('sugestao').doc(id.toString()).delete();
          }
    });
  }
  static Future modify(Sugestao sugestaoDB, Sugestao sugestaoNova) async {
    return await db
        .collection('sugestao')
        .where('first', isEqualTo: sugestaoDB.first)
        .where('second', isEqualTo: sugestaoDB.second)
        .where('liked', isEqualTo: sugestaoDB.liked).get().then((id) async {
      if (id != null) {
        await db.collection('sugestao').doc(id.toString()).set({
          'first': sugestaoNova.first,
          'second': sugestaoNova.second,
          'liked': sugestaoNova.liked
        });
      }
    });
  }
}
