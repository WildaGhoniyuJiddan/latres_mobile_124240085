import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../notification_helper.dart';

class FavoriteSpellScreen extends StatefulWidget {
  const FavoriteSpellScreen({super.key});

  @override
  State<FavoriteSpellScreen> createState() => _FavoriteSpellScreenState();
}

class _FavoriteSpellScreenState extends State<FavoriteSpellScreen> {
  late Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('favorites');
  }

  Future<void> _deleteFavorite(dynamic key, String namaSpell) async {
    await _box.delete(key);

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
            Text('$namaSpell removed from fav list!'),
          ],
        ),
      ),
    );

    await showNotification(
      'Delete notification',
      'You deleted $namaSpell from your fav list!',
    );
  }

  @override
  Widget build(BuildContext context) {
    List daftarFavorite = _box.values.toList();
    List daftarKey = _box.keys.toList();

    return Scaffold(
      backgroundColor: Color(0xFFF5F1F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F1F8),
        title: Text('Favorite Spell'),
      ),
      body: daftarFavorite.isEmpty
          ? Center(child: Text('Belum ada spell favorite'))
          : ListView.builder(
              padding: EdgeInsets.all(12.0),
              itemCount: daftarFavorite.length,
              itemBuilder: (context, index) {
                Map data = daftarFavorite[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.menu_book),
                    title: Text(data['spell']),
                    subtitle: Text(data['use']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteFavorite(daftarKey[index], data['spell']);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
