import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Hello extends StatefulWidget {
  @override
  _HelloState createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  DateTime now = DateTime.now();
  int _flag = 0;
  String _message = '';

  void _time_check() {
    setState(() {
      if( 5 <= now.hour && now.hour <= 10) {
        _flag = 0;
      } else if( 10 <= now.hour && now.hour <= 17 ) {
        _flag = 1;
      }else _flag = 2;

    });
  }

  void _create_message(){
    setState(() {
      if(_flag == 0) {
        _message = 'おはようございます';
      }else if (_flag == 1) {
        _message = 'こんにちは';
      }
      else _message = 'こんばんは';
    });
  }
  @override
  Widget build(BuildContext context) {
    _time_check();
    _create_message();
    return Text(_message,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'gothic',
        ));
  }
}