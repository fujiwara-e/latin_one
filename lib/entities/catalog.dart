import 'package:flutter/material.dart';

class CatalogModel{
  static List<String> itemNames = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
  
  ];
  static List<int> itemPrices = [
    42,
    99,
    149,
    199,
    249,
    299,
    349,
    399,
    449,
    499,
  ];

  Item getById(int id) => Item(id, itemNames[id],itemPrices[id]);

  Item getByPosition(int position) => getById(position);

}

@immutable
class Item {
  final int id;
  final String name;
  final int price;
  Item(this.id, this.name, this.price);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;

}