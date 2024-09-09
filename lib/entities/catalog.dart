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
  static List<String> itemDescription = [
    '柔らかな苦味とコク．中米の甘い風味のブレンド．',
    'マイルドな深みと甘い風味．',
    '甘い香りと深い味わい．アラビカ種ブレンド．',
    'まったりとした奥深いバランスの取れた味わい．'
  ];
  static List<String> itemImagePath = [
    'assets/images/CoffeeBean.jpg',
    'assets/images/CoffeeBean.jpg',
    'assets/images/CoffeeBean.jpg',
    'assets/images/CoffeeBean.jpg'
  ];

  Item getById(int id, {int quantity = 0}) => Item(id, itemNames[id],
      itemPrices[id], quantity, itemDescription[id], itemImagePath[id]);

  Item getByPosition(int position) => getById(position);
}

@immutable
class Item {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imagePath;
  final int quantity;

  Item(this.id, this.name, this.price, this.quantity, this.description,
      this.imagePath);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
