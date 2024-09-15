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

    void populateItems(String category, List<ProductItem> targetlist) {
      List<Item> itemlist = [];
      for (int i = 0;
          i < catalog.catalog[category]!['itemNames']!.length;
          i++) {
        Item item = catalog.getById(i, category);
        itemlist.add(item);
      }

      for (var item in itemlist) {
        targetlist.add(ProductItem(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChoicePage(item: item),
                  fullscreenDialog: true),
            );
          },
          image: item.imagePath,
          name: item.name,
          price: item.price.toString(),
        ));
      }
    }

    populateItems('ITALLY_ROAST', _itally_roasts);
    populateItems('FRENCH_ROAST', _french_roasts);
    populateItems('SPECIALTY_COFFEE', _special_coffee);
    populateItems('SPECIALTY_COFFEE_MEDIUM_ROAST', _special_coffee_medium);
    populateItems('BLEND_COFFEE', _blend_coffee);
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
          SliverText(text: "SPECIALTY COFFEE"),
          ProductsItem(products: _special_coffee),
          SliverBorder(),
          SliverText(text: "SPECIALTY COFFEE MEDIUM ROAST"),
          ProductsItem(products: _special_coffee_medium),
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
