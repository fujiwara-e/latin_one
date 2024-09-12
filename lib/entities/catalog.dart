import 'package:flutter/material.dart';

class CatalogModel {
  static List<String> itemNames = [];

  Item getById_ITALLY(int id, {int quantity = 0}) => Item(
      id,
      catalog['ITALLY_ROAST']!['itemNames']![id],
      catalog['ITALLY_ROAST']!['itemPrices']![id],
      quantity,
      catalog['ITALLY_ROAST']!['itemDescriptions']![id],
      catalog['ITALLY_ROAST']!['itemImagePaths']![id]);

  Item getById_FRENCH(int id, {int quantity = 0}) => Item(
      id,
      catalog['FRENCH_ROAST']!['itemNames']![id],
      catalog['FRENCH_ROAST']!['itemPrices']![id],
      quantity,
      catalog['FRENCH_ROAST']!['itemDescriptions']![id],
      catalog['FRENCH_ROAST']!['itemImagePaths']![id]);

  Item getById_BLEND(int id, {int quantity = 0}) => Item(
      id,
      catalog['BLEND_COFFEE']!['itemNames']![id],
      catalog['BLEND_COFFEE']!['itemPrices']![id],
      quantity,
      catalog['BLEND_COFFEE']!['itemDescriptions']![id],
      catalog['BLEND_COFFEE']!['itemImagePaths']![id]);

  Item getById_SPEACIAL(int id, {int quantity = 0}) => Item(
      id,
      catalog['SPEACIALTY_COFFEE']!['itemNames']![id],
      catalog['SPEACIALTY_COFFEE']!['itemPrices']![id],
      quantity,
      catalog['SPEACIALTY_COFFEE']!['itemDescriptions']![id],
      catalog['SPEACIALTY_COFFEE']!['itemImagePaths']![id]);

  Item getById_SPEACIALTY_COFFEE_MEDIUM_ROAST(int id, {int quantity = 0}) =>
      Item(
          id,
          catalog['SPEACIALTY_COFFEE_MEDIUM_ROAST']!['itemNames']![id],
          catalog['SPEACIALTY_COFFEE_MEDIUM_ROAST']!['itemPrices']![id],
          quantity,
          catalog['SPEACIALTY_COFFEE_MEDIUM_ROAST']!['itemDescriptions']![id],
          catalog['SPEACIALTY_COFFEE_MEDIUM_ROAST']!['itemImagePaths']![id]);

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

  void set_ITALLY(String name, int price, String description, String path) {
    catalog['ITALLY_ROAST']!['itemNames']!.add(name);
    catalog['ITALLY_ROAST']!['itemPrices']!.add(price);
    catalog['ITALLY_ROAST']!['itemDescriptions']!.add(description);
    catalog['ITALLY_ROAST']!['itemImagePaths']!.add(path);
  }

  void set_BLEND(String name, int price, String description, String path) {
    catalog['BLEND_COFFEE']!['itemNames']!.add(name);
    catalog['BLEND_COFFEE']!['itemPrices']!.add(price);
    catalog['BLEND_COFFEE']!['itemDescriptions']!.add(description);
    catalog['BLEND_COFFEE']!['itemImagePaths']!.add(path);
  }

  void set_FRENCH(String name, int price, String description, String path) {
    catalog['FRENCH_ROAST']!['itemNames']!.add(name);
    catalog['FRENCH_ROAST']!['itemPrices']!.add(price);
    catalog['FRENCH_ROAST']!['itemDescriptions']!.add(description);
    catalog['FRENCH_ROAST']!['itemImagePaths']!.add(path);
  }

  void set_SPECIAL(String name, int price, String description, String path) {
    catalog['SPECIALTY_COFFEE']!['itemNames']!.add(name);
    catalog['SPECIALTY_COFFEE']!['itemPrices']!.add(price);
    catalog['SPECIALTY_COFFEE']!['itemDescriptions']!.add(description);
    catalog['SPECIALTY_COFFEE']!['itemImagePaths']!.add(path);
  }

  void set_SPECIAL_MEDIUM(
      String name, int price, String description, String path) {
    catalog['SPECIALTY_COFFEE_MEDIUM_ROAST']!['itemNames']!.add(name);
    catalog['SPECIALTY_COFFEE_MEDIUM_ROAST']!['itemPrices']!.add(price);
    catalog['SPECIALTY_COFFEE_MEDIUM_ROAST']!['itemDescriptions']!
        .add(description);
    catalog['SPECIALTY_COFFEE_MEDIUM_ROAST']!['itemImagePaths']!.add(path);
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

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
