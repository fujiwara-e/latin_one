import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShopModel {
  static List<String> shopNames = [
    'JAVANICAN',
  ];

  static List<String> shopAddresses = [
    '高知県高知市布師田3061ラテンコーヒー',
  ];

  static List<String> shopOpeningHours = [
    '9:00',
  ];

  static List<String> shopClosingHours = [
    '18:00',
  ];

  static List<String> shopPhoneNumbers = [
    '090-1234-5678',
  ];

  static List<String> shopPaymentMethods = [
    '現金のみ',
  ];

  static List<String> shopReguralHolidays = [
    '不定休',
  ];

  Shop getById(int id) => Shop(
      id,
      shopNames[id],
      shopAddresses[id],
      shopOpeningHours[id],
      shopClosingHours[id],
      shopPhoneNumbers[id],
      shopPaymentMethods[id],
      shopReguralHolidays[id]);
}

@immutable
class Shop {
  final int id;
  final String name;
  final String address;
  final String openingHours;
  final String closingHours;
  final String phoneNumber;
  final String paymentMethods;
  final String reguralHoliday;

  Shop(this.id, this.name, this.address, this.openingHours, this.closingHours,
      this.phoneNumber, this.paymentMethods, this.reguralHoliday);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Shop && other.id == id;
}

class SelectedShopModel extends ChangeNotifier {
  late ShopModel _shopList;
  Shop? _selectedShop;
  bool _isSelected = false;

  bool get isSelected => _isSelected;
  ShopModel get shopList => _shopList;

  set shopList(ShopModel newShopList) {
    _shopList = newShopList;
    notifyListeners();
  }

  Shop? get selectedShop => _selectedShop;

  set selectedShop(Shop? newSelectedShop) {
    _selectedShop = newSelectedShop;
    notifyListeners();
  }

  void reset() {
    _isSelected = false;
    notifyListeners();
  }

  void set(Shop newSelectedShop) {
    _selectedShop = newSelectedShop;
    _isSelected = true;
    notifyListeners();
  }
}
