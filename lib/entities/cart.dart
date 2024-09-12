import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/entities/catalog.dart';

class CartModel extends ChangeNotifier {
  late CatalogModel _catalog;
  final List<Item> _items = [];
  int _totalprice = 0;

  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    notifyListeners();
  }

  List<Item> get items => _items;
  int get totalPrice => _totalprice;

  void totalprice() {
    _totalprice = 0;
    for (int i = 0; i < _items.length; i++) {
      _totalprice = _totalprice + (_items[i].price * _items[i].quantity);
    }
  }

  void add(Item item) {
    final existingItem = _items.firstWhere((i) => i.id == item.id,
        orElse: () => Item(item.id, item.name, item.price, 0, item.description,
            item.imagePath));
    if (existingItem.quantity == 0) {
      _items.insert(
          0,
          Item(item.id, item.name, item.price, 1, item.description,
              item.imagePath));
    } else {
      _items[_items.indexOf(existingItem)] = Item(
          item.id,
          item.name,
          item.price,
          existingItem.quantity + 1,
          item.description,
          item.imagePath);
    }
    totalprice();
    notifyListeners();
  }

  void reset() {
    _items.clear();
    _totalprice = 0;
    notifyListeners();
  }

  void remove(Item item) {
    final existingItem = _items.firstWhere((i) => i.id == item.id,
        orElse: () => Item(item.id, item.name, item.price, 0, item.description,
            item.imagePath));

    if (existingItem.quantity > 1) {
      _items[_items.indexOf(existingItem)] = Item(
          item.id,
          item.name,
          item.price,
          existingItem.quantity - 1,
          item.description,
          item.imagePath);
    } else {
      _items.remove(existingItem);
    }

    totalprice();

    notifyListeners();
  }

  int count(Item item) {
    final existingItem = _items.firstWhere((i) => i.id == item.id,
        orElse: () => Item(item.id, item.name, item.price, 0, item.description,
            item.imagePath));
    return existingItem.quantity;
  }
}
