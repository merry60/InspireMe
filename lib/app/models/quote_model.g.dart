part of 'quote_model.dart';

class QuoteModelAdapter extends TypeAdapter<QuoteModel> {
  @override
  final int typeId = 0;

  @override
  QuoteModel read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final int key = reader.readByte();
      final dynamic value = reader.read();
      fields[key] = value;
    }
    return QuoteModel(
      id: fields[0] as String? ?? '',
      text: fields[1] as String? ?? '',
      author: fields[2] as String? ?? 'Unknown',
      isFavorite: fields[3] as bool? ?? false,
      fromApi: fields[4] as bool? ?? false,
      savedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, QuoteModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.isFavorite)
      ..writeByte(4)
      ..write(obj.fromApi)
      ..writeByte(5)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
