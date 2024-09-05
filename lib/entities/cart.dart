import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:latin_one/entities/catalog.dart';

class CartModel extends ChangeNotifier {
  late CatalogModel _catalog;
  final List<Item> _items = [];

  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    notifyListeners();
  }

  List<Item> get items => _items;
  int get totalPrice => items.fold(
      0, (total, current) => total + (current.price * current.quantity));

  void add(Item item) {
    final existingItem = _items.firstWhere((i) => i.id == item.id,
        orElse: () => Item(item.id, item.name, item.price, 0));
    if (existingItem.quantity == 0) {
      _items.add(Item(item.id, item.name, item.price, 1));
    } else {
      _items[_items.indexOf(existingItem)] =
          Item(item.id, item.name, item.price, existingItem.quantity + 1);
    }
    notifyListeners();
  }

  void remove(Item item) {
    final existingItem = _items.firstWhere((i) => i.id == item.id,
        orElse: () => Item(item.id, item.name, item.price, 0));

    if (existingItem.quantity > 1) {
      _items[_items.indexOf(existingItem)] =
          Item(item.id, item.name, item.price, existingItem.quantity - 1);
    } else {
      _items.remove(existingItem);
    }
    notifyListeners();
  }

  int count(Item item) {
    final existingItem = _items.firstWhere((i) => i.id == item.id,
        orElse: () => Item(item.id, item.name, item.price, 0));
    return existingItem.quantity;
  }
}
