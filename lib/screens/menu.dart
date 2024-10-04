import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/entities/cart.dart';
import 'package:latin_one/entities/catalog.dart';
import 'package:latin_one/config/size_config.dart';
import 'package:latin_one/screens/item.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didpop) {
          if (didpop) {
            return;
          }
          Navigator.pop(context);
        },
        child: Scaffold(
            body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: SizeConfig.blockSizeVertical * 8,
              flexibleSpace: FlexibleSpaceBar(
                title: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Products",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'ozworld',
                      ),
                    )),
                titlePadding:
                    EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            SliverFixedExtentList(
              itemExtent: SizeConfig.blockSizeVertical * 10,
              delegate: SliverChildListDelegate([
                MenuItem(
                    image: "assets/images/store.png",
                    text: "BLEND COFFEE",
                    index: 0),
                MenuItem(
                    image: "assets/images/store.png",
                    text: "FRENCH ROAST",
                    index: 1),
                MenuItem(
                    image: "assets/images/store.png",
                    text: "ITALY ROAST",
                    index: 2),
                MenuItem(
                    image: "assets/images/store.png",
                    text: "SPECIALTY COFFEE",
                    index: 3),
                MenuItem(
                    image: "assets/images/store.png",
                    text: "SPECIALTY COFFEE MEDIUM",
                    index: 4),
              ]),
            ),
          ],
        )));
  }
}

class MenusPage extends StatefulWidget {
  final int index;
  final String text;
  const MenusPage({
    Key? key,
    required this.index,
    required this.text,
  }) : super(key: key);

  @override
  State<MenusPage> createState() => _MenusPageState();
}

class _MenusPageState extends State<MenusPage> {
  List<ProductItem> _itally_roasts = [];
  List<ProductItem> _french_roasts = [];
  List<ProductItem> _special_coffee = [];
  List<ProductItem> _special_coffee_medium = [];
  List<ProductItem> _blend_coffee = [];
  List<List<ProductItem>> _categories = [];

  @override
  void initState() {
    super.initState();
    var catalog = context.read<CatalogModel>();

    _categories = [
      _blend_coffee,
      _french_roasts,
      _itally_roasts,
      _special_coffee,
      _special_coffee_medium,
    ];

    void product_from_category(
        String category, List<ProductItem> targetlist, int categorynum) {
      List<Item> itemlist = [];
      for (int i = 0;
          i < catalog.catalog[category]!['itemNames']!.length;
          i++) {
        Item item = catalog.getById(i, category, categorynum);
        itemlist.add(item);
      }

      for (var item in itemlist) {
        targetlist.add(ProductItem(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuPage(item: item),
                  fullscreenDialog: true),
            );
          },
          image: item.imagePath,
          name: item.name,
          price: item.price.toString(),
        ));
      }
    }

    void productitem_from_category() {
      List<String> categoryNames = catalog.categoryNames;
      categoryNames.sort;
      int categoryIndex = 0;
      categoryNames.forEach((category) {
        product_from_category(
            category, _categories[categoryIndex], categoryIndex);
        categoryIndex++;
      });
    }

    productitem_from_category();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didpop) {
          if (didpop) {
            return;
          }
          Navigator.pop(context);
        },
        child: Scaffold(
            body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: SizeConfig.blockSizeVertical * 8,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Products",
                    style: TextStyle(
                      fontSize: SizeConfig.TitleSize,
                      color: Colors.black,
                      fontFamily: 'ozworld',
                    ),
                  )),
              titlePadding:
                  EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Container(
                  height: SizeConfig.blockSizeVertical * 5,
                  alignment: Alignment.centerLeft,
                  child: Text('表示価格はすべて税込み価格です',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontFamily: 'gothic',
                      ))),
            ),
          ),
          SliverText(text: widget.text),
          ProductsItem(products: _categories[widget.index]),
        ])));
  }
}

class MenuPage extends StatelessWidget {
  final Item item;
  const MenuPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: SizeConfig.blockSizeVertical * 8,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "商品選択",
                    style: TextStyle(
                      fontSize: SizeConfig.TitleSize,
                      color: Colors.black,
                      fontFamily: 'gothic',
                    ),
                  )),
              titlePadding:
                  EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Image.asset(item.imagePath),
                SizedBox(
                  height: 30,
                ),
                Container(
                  color: Colors.yellow[800],
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'gothic',
                          ),
                        ),
                        Text(item.price.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'ozworld',
                            )),
                        Text("価格は税込み価格です",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'gothic',
                            )),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 2,
                  width: SizeConfig.screenWidth,
                  color: Colors.black12,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Container(
                        height: SizeConfig.blockSizeVertical * 2,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "商品説明",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                            fontFamily: 'gothic',
                          ),
                        ),
                      ),
                      Container(
                        height: SizeConfig.blockSizeVertical * 6,
                        alignment: Alignment.centerLeft,
                        child: Text(item.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontFamily: 'gothic',
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]));
  }
}
