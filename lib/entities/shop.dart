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
  List<String> shopMail = [];
  List<String> shopMapUrl = [];

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
        shopLongitude[id],
        shopMail[id],
        shopMapUrl[id]);
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
      double longitude,
      String mail,
      String mapurl) {
    shopNames.add(shop);
    shopAddresses.add(address);
    shopOpeningHours.add(opening);
    shopClosingHours.add(closing);
    shopPhoneNumbers.add(phone);
    shopPaymentMethods.add(payment);
    shopReguralHolidays.add(holiday);
    shopLatitude.add(latitude);
    shopLongitude.add(longitude);
    shopMail.add(mail);
    shopMapUrl.add(mapurl);
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
  final String mail;
  final double latitude;
  final double longitude;
  final String mapurl;

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
      this.longitude,
      this.mail,
      this.mapurl);

  @override
  int get hashCode => id;
  String toString() {
    return 'Shop(id: $id, name: $name, $address,1: $openingHours,2: $closingHours,$phoneNumber,$paymentMethods,$reguralHoliday,$latitude, $longitude)';
  }

  @override
  bool operator ==(Object other) => other is Shop && other.id == id;
}

class SelectedShopModel extends ChangeNotifier {
  late ShopModel _shopList;
  Shop? _selectedShop;
  bool _isSelected = false;

  bool get isSelected => _isSelected;
  ShopModel get shopList => _shopList;

  Future<List<Shop>> init() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    List<Shop> shopList = [];
    _shopList = ShopModel();

    try {
      CollectionReference collectionRef = db.collection('shops');
      QuerySnapshot querySnapshot = await collectionRef.get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final shopId = doc.id;

        _shopList.setItem(
          shopId,
          data['address'] ?? '',
          data['opening_hours'] ?? '',
          data['closing_hours'] ?? '',
          data['phone_number'] ?? '',
          data['payment'] ?? '',
          data['holiday'] ?? '',
          data['latitude'] ?? 0.0,
          data['longitude'] ?? 0.0,
          data['mail_address'] ?? '',
          data['map_url'] ?? '',
        );
      }

      for (int i = 0; i < _shopList.shopNames.length; i++) {
        shopList.add(_shopList.getById(i));
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching shops: $e");
    }

    return shopList;
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
