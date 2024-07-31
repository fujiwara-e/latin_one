import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/size_config.dart';

class UrlLauncher {
  Future makePhoneCall(String phoneNumber) async {
    final Uri getPhoneNumber = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(getPhoneNumber);
  }
}

class AddressItem extends StatelessWidget {
  final String text;

  const AddressItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        Column(
          children: <Widget>[
            SizedBox(
              width:SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 10,
              child :Row(
            children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20,top: 0, right: 0, bottom: 0),
              height: SizeConfig.blockSizeVertical * 10,
              width: SizeConfig.screenWidth * 0.8,
              child: Text(
                  text,
                  style: TextStyle(fontSize:10,
                    color: Colors.black,
                    fontFamily: 'gothic',)
              ),
            ),
              IconButton(onPressed: () {
                print(SizeConfig.blockSizeVertical);
                final urlLauncher = UrlLauncher();
                urlLauncher.makePhoneCall('088-846-0408'); }, icon: Icon(Icons.phone))
          ]
        ),
            ),
        Container(height: 2,
          width: SizeConfig.screenWidth,
          color: Colors.black12,),
    ]
    );
    }
  }

  class ShopItem extends StatelessWidget {
    final String column_name;
    final String text;

    const ShopItem({
      Key? key,
      required this.column_name,
      required this.text,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Column(
          children: <Widget>[
            SizedBox(
              height: SizeConfig.blockSizeVertical * 10,
              child:Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20,top: 0, right: 0, bottom: 0),
                        width: 100,
                        child:Text(
                          column_name,
                          style: TextStyle(fontSize:10,
                            color: Colors.black54,
                            fontFamily: 'gothic',),
                        )
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 200,
                        child:Align(
                          alignment: Alignment.centerLeft, //任意のプロパティ
                          child: Text(
                              text,
                              style: TextStyle(fontSize:10,
                                color: Colors.black,
                                fontFamily: 'gothic',)
                              ),
                        ),
                    ),
                  ]),
            ),
            Container(height: 2,
              width: 1000,
              color: Colors.black12,),
        ],
      );
    }
  }
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