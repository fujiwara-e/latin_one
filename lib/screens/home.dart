import 'package:flutter/material.dart';
import '../config/size_config.dart';
import 'item.dart';
import 'hello.dart';
import '../main.dart';
import '../screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.onChangeIndex});

  final Function(int) onChangeIndex;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
            SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: SizeConfig.blockSizeVertical * 8,
                flexibleSpace: FlexibleSpaceBar(
                  title: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hello(),
                  ),
                  titlePadding:
                      EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
                  collapseMode: CollapseMode.parallax,
                ),
              ),
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: SizeConfig.blockSizeVertical * 0.96,
                //0.96
                // forceElevated: true,
                // elevation:20,
                pinned: true,
                // expandedHeight: 100.0,
                flexibleSpace: FlexibleSpaceBar(),
                leadingWidth: 120,
                leading: TextButton.icon(
                  icon: const Icon(Icons.mail_outlined),
                  label: const Text('inbox'),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    final docRef = db.collection("shops").doc("javanican");
                    docRef.get().then(
                          (DocumentSnapshot doc) {
                            if (doc.exists) {
                              print('Value of key1: ${doc['address']}');
                            } else {
                              print('Document does not exist');
                            }
                          }
                          );





                    print("クリックされたぞ");
                    print(SizeConfig.blockSizeVertical);
                    print(SizeConfig.blockSizeHorizontal);
                  },
                ),
              ),
              SliverFixedExtentList(
                itemExtent: SizeConfig.blockSizeVertical * 29,
                delegate: SliverChildListDelegate([
                  ProductItem(
                    onTap: () {
                      setState(() {
                        widget.onChangeIndex(2);
                      });
                      Builder(builder: (BuildContext context) => Screen(title: 'Latin One'),);
                      print(selectedIndex);
                    },
                    image: 'assets/images/CoffeeBean.jpg',
                    text: 'Order',
                  ),
                  ProductItem(
                    onTap: () {
                      print("クリックされたぞ!!!!!");
                    },
                    image: 'assets/images/Latte.jpg',
                    text: 'Products',
                  ),
                  ProductItem(
                    onTap: () {
                      setState(() {
                        widget.onChangeIndex(1);
                      });
                    },
                    image: 'assets/images/Machine.jpg',
                    text: 'Shops',
                  ),
                  ProductItem(
                    onTap: () {
                      print("クリックされたぞ!!!!!");
                    },
                    image: 'assets/images/Latte.jpg',
                    text: '',
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}

class InboxPage extends StatefulWidget{
  const InboxPage({super.key, required this.title});

  final String title;

  @override
  State<InboxPage> createState() => _InboxPageState();

}
class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: SizeConfig.blockSizeVertical * 8,
                flexibleSpace: FlexibleSpaceBar(
                  title: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("JAVANICAN",
                        style: TextStyle(fontSize:20,
                          color: Colors.black,
                          fontFamily: 'gothic',),
                      )
                  ),
                  titlePadding:
                  EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
                  collapseMode: CollapseMode.parallax,
                ),
              ),
              SliverFixedExtentList(
                itemExtent: SizeConfig.blockSizeVertical * 10 + 2,
                delegate: SliverChildListDelegate([
                  AddressItem(text: "高知県 高知市 布師田3061 ラテンコーヒー"),
                  ShopItem(column_name: '営業時間',text: "9:00-18:00"),
                  ShopItem(column_name: '定休日',text: "不定休"),
                  ShopItem(column_name: 'モバイル決済',text: "現金のみ！！"),
                ]),
              ),
            ],
          ),
        ));
  }
}