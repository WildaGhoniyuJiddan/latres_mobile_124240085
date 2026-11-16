import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/character.dart';
import 'character_detail_screen.dart';
import 'login_screen.dart';
import 'spell_screen.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  List<Character> _characters = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://potterapi-fedeperin.vercel.app/en/characters'),
      );
      final data = jsonDecode(response.body);

      List<Character> hasil = [];
      for (var item in data) {
        hasil.add(Character(
          fullName: item['fullName'] ?? '-',
          nickname: item['nickname'] ?? '-',
          hogwartsHouse: item['hogwartsHouse'] ?? '-',
          interpretedBy: item['interpretedBy'] ?? '-',
          children: item['children'] ?? [],
          image: item['image'] ?? '',
          birthdate: item['birthdate'] ?? '-',
          index: item['index'] ?? 0,
        ));
      }

      setState(() {
        _characters = hasil;
        _isLoading = false;
      });
    } catch (e) {
      print('Gagal ambil data karakter: $e');
      setState(() {
        _error = 'Gagal mengambil data karakter';
        _isLoading = false;
      });
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
        title: Text('Harry Potter'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SpellScreen()),
              );
            },
            child: Text('Spells'),
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
              onPressed: _fetchCharacters,
              child: Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: _characters.length,
      itemBuilder: (context, index) {
        Character karakter = _characters[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(karakter.image),
            ),
            title: Text(karakter.fullName),
            subtitle: Text(karakter.interpretedBy),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CharacterDetailScreen(character: karakter),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
