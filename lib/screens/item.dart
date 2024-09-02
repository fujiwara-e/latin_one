import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/screens/product.dart';
import 'package:latin_one/screens/shops.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latin_one/config/size_config.dart';
import 'package:latin_one/screens/order.dart';

enum TabItem {
  home,
  shops,
  order,
}

enum SubTabItem {
  home,
  inbox,
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

class OrderItem extends StatelessWidget {
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

    return Opacity(
        opacity: isGrayedOut ? 0.5 : 1.0,
        child: InkWell(
            onTap: isGrayedOut
                ? null
                : () {
                    print("on tap\n");
                  },
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockSizeVertical * 10,
                  child: Row(children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          left: 20, top: 0, right: 0, bottom: 0),
                      child: image,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          left: 20, top: 0, right: 0, bottom: 0),
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.screenWidth * 0.73,
                      child: Text(text,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'gothic',
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin:
                          EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                      child: Icon(Icons.arrow_forward_ios),
                    )
                  ]),
                ),
                Container(
                  height: 2,
                  width: SizeConfig.screenWidth,
                  color: Colors.black12,
                ),
              ],
            )));
  } // widget build
}

class StoreItem extends StatefulWidget {
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
    return InkWell(
        onTap: () {
          print("on tap\n");
          setState(() {
            widget.selectstore(1);
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.widget),
          );
        },
        child: Column(
          children: <Widget>[
            SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 10,
              child: Row(children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                  child: widget.image,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                  height: SizeConfig.blockSizeVertical * 10,
                  width: SizeConfig.screenWidth * 0.73,
                  child: Text(widget.text,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'gothic',
                      )),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                  child: Icon(Icons.arrow_forward_ios),
                )
              ]),
            ),
            Container(
              height: 2,
              width: SizeConfig.screenWidth,
              color: Colors.black12,
            ),
          ],
        ));
  } // widget build
}

class AddressItem extends StatelessWidget {
  final String text;

  const AddressItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.blockSizeVertical * 10,
        child: Row(children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
            height: SizeConfig.blockSizeVertical * 10,
            width: SizeConfig.screenWidth * 0.67,
            child: Text(text,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontFamily: 'gothic',
                )),
          ),
          IconButton(
              onPressed: () {
                print(SizeConfig.blockSizeVertical);
                final urlLauncher = UrlLauncher();
                urlLauncher.makePhoneCall('088-846-0408');
              },
              icon: Icon(Icons.phone)),
          IconButton(
              onPressed: () async {
                print(SizeConfig.blockSizeVertical);
                final url =
                    Uri.parse("https://maps.app.goo.gl/zTAPviyi3NyRxvwt5");
                await launchUrl(url);
              },
              icon: Icon(Icons.map_outlined))
        ]),
      ),
      Container(
        height: 2,
        width: SizeConfig.screenWidth,
        color: Colors.black12,
      ),
    ]);
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
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    margin:
                        EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                    width: 100,
                    child: Text(
                      column_name,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                        fontFamily: 'gothic',
                      ),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  width: 200,
                  child: Align(
                    alignment: Alignment.centerLeft, //任意のプロパティ
                    child: Text(text,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontFamily: 'gothic',
                        )),
                  ),
                ),
              ]),
        ),
        Container(
          height: 2,
          width: 1000,
          color: Colors.black12,
        ),
      ],
    );
  }
}

class HomeItem extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String text;

  const HomeItem({
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
          style: TextStyle(
            fontSize: 50,
            color: Colors.white,
            fontFamily: 'gothic',
          ),
        ),
      ),
    );
  }
}

class BottomSheetItem extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const BottomSheetItem({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 10,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => {},
                    icon: Icon(
                      Icons.favorite_outline,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => ShopPage(),
                        fullscreenDialog: true,
                      ),
                    ),
                    icon: Icon(
                      Icons.info_outline,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                height: SizeConfig.blockSizeVertical * 30 * 0.2,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "JAVANICAN",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'gothic',
                    ),
                  ),
                ),
              ),
              Container(
                height: SizeConfig.blockSizeVertical * 30 * 0.2,
                margin: EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                color: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "高知県高知市布師田３０６１",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontFamily: 'ozworld',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellow[800],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ProductPage()),
                      (route) => route.isFirst,
                    ),
                    child: Text('選択する'),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class ProductsItem extends StatelessWidget {
  final List<ProductItem> products;

  const ProductsItem({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
        crossAxisCount: 3,
        mainAxisSpacing: 12.0, // アイテムとアイテムの縦の隙間の幅
        crossAxisSpacing: 1.0, // アイテムとアイテムの横の隙間の幅
        childAspectRatio: 0.8,
        children: products);
  }
}

class SliverBorder extends StatelessWidget {
  const SliverBorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        height: 2,
        width: 50,
        color: Color.fromARGB(255, 200, 200, 200),
      ),
    );
  }
}

class SliverText extends StatelessWidget {
  final String text;

  const SliverText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 17),
        child: Container(
            alignment: Alignment.centerLeft,
            height: SizeConfig.blockSizeVertical * 5,
            child: Text(text,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'ozworld',
                ))),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String name;
  final String price;

  const ProductItem({
    Key? key,
    required this.onTap,
    required this.image,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Aligns children to the left
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal:
                      15.0), // Add padding to align with the rounded corners
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0), // Same padding as the image
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontFamily: 'gothic',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0), // Same padding as the image
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                price,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontFamily: 'gothic',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


