import 'package:flutter/material.dart';

class CatalogModel {
  static List<String> itemNames = [
    'Bean A',
    'Bean B',
    'Bean C',
    'Bean D',
  ];
  static List<int> itemPrices = [
    395,
    495,
    595,
    530,
  ];

  Item getById(int id, {int quantity = 0}) =>
      Item(id, itemNames[id], itemPrices[id], quantity);

  Item getByPosition(int position) => getById(position);
}

@immutable
class Item {
  final int id;
  final String name;
  final int price;
  final int quantity;

  Item(this.id, this.name, this.price, this.quantity);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
