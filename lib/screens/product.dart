import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/config/size_config.dart';
import 'package:latin_one/entities/cart.dart';
import 'package:latin_one/screens/item.dart';
import 'package:latin_one/entities/catalog.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  List<ProductItem> _itally_roasts = [];
  List<ProductItem> _french_roasts = [];
  List<ProductItem> _special_coffee = [];
  List<ProductItem> _special_coffee_medium = [];
  List<ProductItem> _blend_coffee = [];

  void initState() {
    super.initState();
    var catalog = context.read<CatalogModel>();
    var item_list = [];
    for (int i = 0;
        i < catalog.catalog['ITALLY_ROAST']!['itemNames']!.length;
        i++) {
      Item item = catalog.getById_ITALLY(i);
      print(catalog.catalog['ITALLY_ROAST']!['itemNames']![i]);
      item_list.add(item);
    }
    for (int i = 0; i < item_list.length; i++) {
      _itally_roasts.add(ProductItem(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChoicePage(item: item_list[i]),
                fullscreenDialog: true),
          );
        },
        image: item_list[i].imagePath,
        name: item_list[i].name,
        price: item_list[i].price.toString(),
      ));
    }

    item_list = [];
    for (int i = 0;
        i < catalog.catalog['BLEND_COFFEE']!['itemNames']!.length;
        i++) {
      Item item = catalog.getById_BLEND(i);
      item_list.add(item);
    }
    for (int i = 0; i < item_list.length; i++) {
      _blend_coffee.add(ProductItem(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChoicePage(item: item_list[i]),
                fullscreenDialog: true),
          );
        },
        image: item_list[i].imagePath,
        name: item_list[i].name,
        price: item_list[i].price.toString(),
      ));
    }

    item_list = [];
    for (int i = 0;
        i < catalog.catalog['FRENCH_ROAST']!['itemNames']!.length;
        i++) {
      Item item = catalog.getById_FRENCH(i);
      item_list.add(item);
    }
    for (int i = 0; i < item_list.length; i++) {
      _french_roasts.add(ProductItem(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChoicePage(item: item_list[i]),
                fullscreenDialog: true),
          );
        },
        image: item_list[i].imagePath,
        name: item_list[i].name,
        price: item_list[i].price.toString(),
      ));
    }

    // item_list = [];
    // for (int i = 0;
    //     i < catalog.catalog['SPEACIALTY_COFFEE']!['itemNames']!.length;
    //     i++) {
    //   Item item = catalog.getById_SPEACIAL(i);
    //   item_list.add(item);
    // }
    // for (int i = 0; i < item_list.length; i++) {
    //   _special_coffee.add(ProductItem(
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ChoicePage(item: item_list[i]),
    //             fullscreenDialog: true),
    //       );
    //     },
    //     image: item_list[i].imagePath,
    //     name: item_list[i].name,
    //     price: item_list[i].price.toString(),
    //   ));
    // }

    // item_list = [];
    // for (int i = 0;
    //     i <
    //         catalog.catalog['SPEACIALTY_COFFEE_MEDIUM_ROAST']!['itemNames']!
    //             .length;
    //     i++) {
    //   Item item = catalog.getById_SPEACIALTY_COFFEE_MEDIUM_ROAST(i);
    //   item_list.add(item);
    // }
    // for (int i = 0; i < item_list.length; i++) {
    //   _special_coffee_medium.add(ProductItem(
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ChoicePage(item: item_list[i]),
    //             fullscreenDialog: true),
    //       );
    //     },
    //     image: item_list[i].imagePath,
    //     name: item_list[i].name,
    //     price: item_list[i].price.toString(),
    //   ));
    // }
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
          SliverText(text: "BLEND COFFEE"),
          ProductsItem(products: _blend_coffee),
          SliverBorder(),
          SliverText(text: "ITALLEY ROAST"),
          ProductsItem(products: _itally_roasts),
          SliverBorder(),
          SliverText(text: "FRENCH ROAST"),
          ProductsItem(products: _french_roasts),
          SliverBorder(),
          SliverText(text: "SPEACIALTY COFFEE"),
          ProductsItem(products: _special_coffee),
          SliverBorder(),
          SliverText(text: "SPEACIALTY COFFEE MEDIUM ROAST"),
          ProductsItem(products: _special_coffee),
        ])));
  }
}

class AddButton extends StatelessWidget {
  final Item item;

  const AddButton({required this.item});

  @override
  Widget build(BuildContext context) {
    var isInCart = context.select<CartModel, bool>(
      (cart) => cart.items.contains(item),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Text("数量"),
              Text(
                '${context.select<CartModel, int>((cart) => cart.count(item))}',
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: isInCart
                  ? () {
                      var cart = context.read<CartModel>();
                      if (cart.count(item) > 0) {
                        cart.remove(item);
                      }
                    }
                  : null,
              tooltip: 'Decrease quantity',
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                var cart = context.read<CartModel>();
                cart.add(item);
                //Provider.of<CartModel>(context, listen: false).add(item);
              },
              tooltip: 'Increase quantity',
            ),
          ],
        ),
      ],
    );
  }
}

class ChoicePage extends StatelessWidget {
  final Item item;
  const ChoicePage({
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
            // itemExtent: SizeConfig.blockSizeVertical * 10 + 8,
            delegate: SliverChildListDelegate(
              [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      height: SizeConfig.blockSizeVertical * 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(item.imagePath),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name),
                          Text(item.price.toString()),
                          Text("価格は税込み価格です"),
                        ],
                      ),
                    ),
                  ],
                ),
                // Column(
                //   children: [
                Container(
                  height: 2,
                  width: SizeConfig.screenWidth,
                  color: Colors.black12,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 8,
                    alignment: Alignment.centerLeft,
                    child: Text(item.description),
                  ),
                ),
                Container(
                  height: 2,
                  width: SizeConfig.screenWidth,
                  color: Colors.black12,
                ),
                AddButton(item: item),
                Container(
                  height: 2,
                  width: SizeConfig.screenWidth,
                  color: Colors.black12,
                )
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(left: 0, top: 0, right: 10, bottom: 0),
          child: TextButton(
            onPressed: () => {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              )
            },
            child: Text('決定する'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.yellow[800],
            ),
          ),
        ),
      ),
    ]));
  }
}
