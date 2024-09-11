import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomerModel extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _mail = '';
  String _zipcode = '';
  String _address = '';
  bool isSeted = false;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get mail => _mail;
  String get address => _address;
  String get zipcode => _zipcode;

  CustomerModel(this._firstName, this._lastName, this._mail, this._zipcode,
      this._address);

  void reset() {
    set('', '', '', '', '');
    isSeted = false;
    notifyListeners();
  }

  void set(
      String first, String last, String mail, String zipcode, String address) {
    _firstName = first;
    _lastName = last;
    _mail = mail;
    _zipcode = zipcode;
    _address = address;
    isSeted = true;
    notifyListeners();
  }
}
