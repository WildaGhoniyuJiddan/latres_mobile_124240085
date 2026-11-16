import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    String daftarAnak = character.children.isEmpty
        ? '-'
        : character.children.join(', ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F1F8),
        title: Text(character.fullName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  character.image,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              _buildData('Full Name', character.fullName),
              _buildData('Nickname', character.nickname),
              _buildData('Hogwarts House', character.hogwartsHouse),
              _buildData('Interpreted By', character.interpretedBy),
              _buildData('Birthdate', character.birthdate),
              _buildData('Children', daftarAnak),
              _buildData('Index', character.index.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildData(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
