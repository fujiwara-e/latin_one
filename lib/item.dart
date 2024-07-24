import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductItem extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String text;

  const ProductItem({
    Key? key,
    required this.onTap,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
          border: Border(
            bottom: BorderSide(
              color: Colors.white,
              width: 10,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize:50,
            color: Colors.white,
            fontFamily: 'gothic',),
        ),
      ),
    );
  }
}