import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/entities/cart.dart';
import 'package:latin_one/entities/catalog.dart';
import 'package:latin_one/config/size_config.dart';
import 'package:latin_one/screens/item.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            MenuItem(image: "assets/images/store.png", text: "ITALLEY ROAST"),
            MenuItem(image: "assets/images/store.png", text: "FRENCH ROAST"),
          ]),
        ),
      ],
    ));
  }
}

class MenusPage extends StatefulWidget {
  const MenusPage({super.key});

  @override
  State<MenusPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<MenusPage> {
  List<ProductItem> _products = [];

  @override
  void initState() {
    super.initState();
    CatalogModel catalog = CatalogModel();
    final ItemList = [];
    for (int i = 0; i < CatalogModel.itemNames.length; i++) {
      Item item = catalog.getById(i, 'ITALLEY_ROAST');
      ItemList.add(item);
    }

    for (int i = 0; i < ItemList.length; i++) {
      _products.add(ProductItem(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => ChoicePage(item: ItemList[i]),
          //       fullscreenDialog: true),
          // );
        },
        image: ItemList[i].imagePath,
        name: ItemList[i].name,
        price: ItemList[i].price.toString(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didpop) {
          if (didpop) {
            return;
          }
          Navigator.popUntil(
            context,
            (route) => route.isFirst,
          );
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
          SliverText(text: "ITALLEY ROAST"),
          ProductsItem(products: _products),
          SliverBorder(),
          SliverText(text: "FRENCH ROAST"),
          ProductsItem(products: _products),
          SliverBorder(),
          SliverText(text: "SPECIALTY COFFEE"),
          ProductsItem(products: _products),
          SliverBorder(),
        ])));
  }
}
