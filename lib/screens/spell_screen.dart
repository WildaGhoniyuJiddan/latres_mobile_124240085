import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/spell.dart';
import '../models/spell_favorite.dart';
import 'character_screen.dart';
import 'favorite_spell_screen.dart';
import 'login_screen.dart';

class SpellScreen extends StatefulWidget {
  const SpellScreen({super.key});

  @override
  State<SpellScreen> createState() => _SpellScreenState();
}

class _SpellScreenState extends State<SpellScreen> {
  List<Spell> _spells = [];
  bool _isLoading = true;
  String _error = '';
  late Box<SpellFavorite> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<SpellFavorite>('favorites');
    _fetchSpells();
  }

  Future<void> _fetchSpells() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://potterapi-fedeperin.vercel.app/en/spells'),
      );
      final data = jsonDecode(response.body);

      List<Spell> hasil = [];
      for (var item in data) {
        hasil.add(Spell(
          spell: item['spell'] ?? '-',
          use: item['use'] ?? '-',
          index: item['index'] ?? 0,
        ));
      }

      setState(() {
        _spells = hasil;
        _isLoading = false;
      });
    } catch (e) {
      print('Gagal ambil data spell: $e');
      setState(() {
        _error = 'Gagal mengambil data spell';
        _isLoading = false;
      });
    }
  }

  bool _isFavorite(Spell spell) {
    return _box.containsKey(spell.index);
  }

  Future<void> _toggleFavorite(Spell spell) async {
    if (_isFavorite(spell)) {
      await _box.delete(spell.index);

      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Remove!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${spell.spell} removed from fav list!'),
            ],
          ),
        ),
      );
    } else {
      await _box.put(
        spell.index,
        SpellFavorite(
          spell: spell.spell,
          use: spell.use,
          index: spell.index,
        ),
      );

      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${spell.spell} successfully added to fav list!'),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Success!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Logged out Successfully'),
          ],
        ),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F1F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F1F8),
        title: Text('Harry Potter Spells Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFE8D9F5),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoriteSpellScreen()),
          ).then((_) {
            setState(() {});
          });
        },
        child: Icon(Icons.favorite, color: Colors.red),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CharacterScreen()),
              );
            },
            child: Text('Characters'),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != '') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchSpells,
              child: Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: _spells.length,
      itemBuilder: (context, index) {
        Spell spell = _spells[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            leading: Icon(Icons.menu_book),
            title: Text(spell.spell),
            subtitle: Text(spell.use),
            trailing: IconButton(
              icon: Icon(
                _isFavorite(spell) ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite(spell) ? Colors.red : Colors.black87,
              ),
              onPressed: () {
                _toggleFavorite(spell);
              },
            ),
          ),
        );
      },
    );
  }
}
