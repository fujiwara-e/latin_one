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
  List<ProductItem> _products = [];

  @override
  void initState() {
    super.initState();
    CatalogModel catalog = CatalogModel();
    final ItemList = [];
    for (int i = 0; i < CatalogModel.itemNames.length; i++) {
      Item item = catalog.getById(i);
      ItemList.add(item);
    }

    for (int i = 0; i < ItemList.length; i++) {
      _products.add(ProductItem(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChoicePage(item: ItemList[i]),
                fullscreenDialog: true),
          );
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
          SliverText(text: "SPEACIALTY COFFEE"),
          ProductsItem(products: _products),
          SliverBorder(),
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
      Positioned(
        bottom: 10,
        right: 10,
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
      )
    ]));
  }
}
