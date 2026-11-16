import 'package:hive/hive.dart';

part 'spell_favorite.g.dart';

@HiveType(typeId: 0)
class SpellFavorite extends HiveObject {
  @HiveField(0)
  String spell;

  @HiveField(1)
  String use;

  @HiveField(2)
  int index;

  SpellFavorite({
    required this.spell,
    required this.use,
    required this.index,
  });
}
