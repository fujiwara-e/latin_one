import 'package:flutter/material.dart';
import 'package:latin_one/entities/cart.dart';
import 'package:provider/provider.dart';

class CatalogModel {
  static List<String> itemNames = [];
  List<String> categoryNames = [];

  int calculateid(int id, int categorynum) {
    int firstid = 0;
    int productid = 0;

    for (int i = 0; i < categorynum; i++) {
      firstid += catalog[categoryNames[i]]!['itemNames']!.length;
    }

    productid = firstid + id;
    return productid;
  }

  Item getById(int id, String category, int categorynum, {int quantity = 0}) =>
      Item(
          calculateid(id, categorynum),
          catalog[category]!['itemNames']![id],
          catalog[category]!['itemPrices']![id],
          quantity,
          catalog[category]!['itemDescriptions']![id],
          catalog[category]!['itemImagePaths']![id]);

  Map<String, Map<String, List<dynamic>>> catalog = {
    'ITALLY_ROAST': {
      'itemNames': [],
      'itemPrices': [],
      'itemDescriptions': [],
      'itemImagePaths': []
    },
    'FRENCH_ROAST': {
      'itemNames': [],
      'itemPrices': [],
      'itemDescriptions': [],
      'itemImagePaths': []
    },
    'BLEND_COFFEE': {
      'itemNames': [],
      'itemPrices': [],
      'itemDescriptions': [],
      'itemImagePaths': []
    },
    'SPECIALTY_COFFEE': {
      'itemNames': [],
      'itemPrices': [],
      'itemDescriptions': [],
      'itemImagePaths': []
    },
    'SPECIALTY_COFFEE_MEDIUM_ROAST': {
      'itemNames': [],
      'itemPrices': [],
      'itemDescriptions': [],
      'itemImagePaths': []
    }
  };

  Map<String, Map<String, List<dynamic>>> get catalogItems => catalog;

  void setItem(String category, String name, int price, String description,
      String path) {
    catalog[category]!['itemNames']!.add(name);
    catalog[category]!['itemPrices']!.add(price);
    catalog[category]!['itemDescriptions']!.add(description);
    catalog[category]!['itemImagePaths']!.add(path);
  }

  void setCategoryNames(List<String> categorynames) {
    categoryNames = categorynames;
  }
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

  String toString() {
    return 'Item(id: $id, name: $name, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
