import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  List<String> shopNames = [];
  List<String> shopAddresses = [];
  List<String> shopOpeningHours = [];
  List<String> shopClosingHours = [];
  List<String> shopPhoneNumbers = [];
  List<String> shopPaymentMethods = [];
  List<String> shopReguralHolidays = [];
  List<double> shopLatitude = [];
  List<double> shopLongitude = [];

  Shop getById(int id) {
    if (id < 0 || id >= shopNames.length) {
      throw RangeError('Invalid index: $id');
    }
    return Shop(
        id,
        shopNames[id],
        shopAddresses[id],
        shopOpeningHours[id],
        shopClosingHours[id],
        shopPhoneNumbers[id],
        shopPaymentMethods[id],
        shopReguralHolidays[id],
        shopLatitude[id],
        shopLongitude[id]);
  }

  void setItem(
      String shop,
      String address,
      String opening,
      String closing,
      String phone,
      String payment,
      String holiday,
      double latitude,
      double longitude) {
    shopNames.add(shop);
    shopAddresses.add(address);
    shopOpeningHours.add(opening);
    shopClosingHours.add(closing);
    shopPhoneNumbers.add(phone);
    shopPaymentMethods.add(payment);
    shopReguralHolidays.add(holiday);
    shopLatitude.add(latitude);
    shopLongitude.add(longitude);
  }
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
  final double latitude;
  final double longitude;

  Shop(
      this.id,
      this.name,
      this.address,
      this.openingHours,
      this.closingHours,
      this.phoneNumber,
      this.paymentMethods,
      this.reguralHoliday,
      this.latitude,
      this.longitude);

  @override
  int get hashCode => id;
  String toString() {
    return 'Shop(id: $id, name: $name, $address,1: $openingHours,2: $closingHours,$phoneNumber,$paymentMethods,$reguralHoliday,$latitude, $longitude)';
  }

  @override
  bool operator ==(Object other) => other is Shop && other.id == id;
}

class SelectedShopModel extends ChangeNotifier {
  List<String> shopNames = [];
  late ShopModel _shopList;
  Shop? _selectedShop;
  bool _isSelected = false;

  bool get isSelected => _isSelected;
  ShopModel get shopList => _shopList;

  void init() {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    Future<List<String>> shopsnames_from_firebase() async {
      CollectionReference collectionRef = db.collection('shops');
      QuerySnapshot querySnapshot = await collectionRef.get();
      List<String> shopnames = querySnapshot.docs.map((doc) => doc.id).toList();
      return shopnames;
    }

    void shops_from_firebase() async {
      shopNames = await shopsnames_from_firebase();
      shopNames.forEach((shop) {
        var docRef = db.collection("shops").doc(shop);
        docRef.get().then((DocumentSnapshot doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          for (int i = 0; i < data!.length; i++) {
            _shopList.setItem(
                shop,
                doc.get('address'),
                doc.get('opening_hours'),
                doc.get('closing_hours'),
                doc.get('phone_number'),
                doc.get('payment'),
                doc.get('holiday'),
                doc.get('latitude'),
                doc.get('longitude'));
          }
        });
      });
    }

    shops_from_firebase();
  }

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
