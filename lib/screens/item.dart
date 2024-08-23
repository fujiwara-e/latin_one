import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/size_config.dart';
import 'order.dart';

enum TabItem {
  home,
  shops,
  order,
}

class UrlLauncher {
  Future makePhoneCall(String phoneNumber) async {
    final Uri getPhoneNumber = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(getPhoneNumber);
  }
}

class OrderItem extends StatelessWidget{
  final String text;
  final Image image;
  final Widget widget;
  final int selectedstore;

  const OrderItem({
    Key? key,
    required this.text,
    required this.image,
    required this.widget,
    required this.selectedstore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isGrayedOut = selectedstore == 0;

    return Opacity(opacity: isGrayedOut ? 0.5 :1.0 ,
      child:
      InkWell(
          onTap: isGrayedOut ? null : () {
            print("on tap\n");
          },
          child: Column(
            children: <Widget>[
              SizedBox(
                width:SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 10,
                child :Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20,top: 0, right: 0, bottom: 0),
                        child: image,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20,top: 0, right: 0, bottom: 0),
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.screenWidth * 0.73,
                        child: Text(
                            text,
                            style: TextStyle(fontSize:12,
                              color: Colors.black,
                              fontFamily: 'gothic',)
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 0,top: 0, right: 0, bottom: 0),
                        child: Icon(Icons.arrow_forward_ios),
                      )
                    ]
                ),
              ),
              Container(height: 2,
                width: SizeConfig.screenWidth,
                color: Colors.black12,),
            ],
          )
      )
      );

  }// widget build
}

class StoreItem extends StatefulWidget{
  const StoreItem({
    Key? key,
    required this.text,
    required this.image,
    required this.widget,
    required this.selectstore,
  }) : super(key: key);

  final String text;
  final Image image;
  final Widget widget;
  final Function(int) selectstore;

  @override
  State<StoreItem> createState() => _StoreItemState();
}

class _StoreItemState extends State<StoreItem> {
  @override
  Widget build(BuildContext context) {

    return
      InkWell(
          onTap:(){
            print("on tap\n");
            setState((){widget.selectstore(1);});
          },
          child: Column(
            children: <Widget>[
              SizedBox(
                width:SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 10,
                child :Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20,top: 0, right: 0, bottom: 0),
                        child: widget.image,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20,top: 0, right: 0, bottom: 0),
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.screenWidth * 0.73,
                        child: Text(
                            widget.text,
                            style: TextStyle(fontSize:12,
                              color: Colors.black,
                              fontFamily: 'gothic',)
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 0,top: 0, right: 0, bottom: 0),
                        child: Icon(Icons.arrow_forward_ios),
                      )
                    ]
                ),
              ),
              Container(height: 2,
                width: SizeConfig.screenWidth,
                color: Colors.black12,),
            ],
          )
        );
  }// widget build
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
                  width: SizeConfig.screenWidth * 0.67,
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
                  urlLauncher.makePhoneCall('088-846-0408'); }, icon: Icon(Icons.phone)
                ),
                  IconButton(onPressed: () async{
                    print(SizeConfig.blockSizeVertical);
                    final url = Uri.parse("https://maps.app.goo.gl/zTAPviyi3NyRxvwt5");
                    await launchUrl(url);
                    }, icon: Icon(Icons.map_outlined))
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