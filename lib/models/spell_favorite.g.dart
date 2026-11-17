part of 'spell_favorite.dart';

class SpellFavoriteAdapter extends TypeAdapter<SpellFavorite> {
  @override
  final int typeId = 0;

  @override
  SpellFavorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpellFavorite(
      spell: fields[0] as String,
      use: fields[1] as String,
      index: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SpellFavorite obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.spell)
      ..writeByte(1)
      ..write(obj.use)
      ..writeByte(2)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpellFavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
