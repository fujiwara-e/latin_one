import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latin_one/config/size_config.dart';
import 'package:latin_one/entities/cart.dart';
import 'package:latin_one/screens/item.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latin_one/entities/catalog.dart';
import 'package:provider/provider.dart';
import 'package:latin_one/entities/cart.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  late List<ProductItem> _products;

  @override
  void initState() {
    super.initState();
    _products = [
      ProductItem(
        onTap: () {
         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChoicePage(index: 0),
              fullscreenDialog: true
            ),
          ); 
        },
        image: 'assets/images/CoffeeBean.jpg',
        name: 'Bean A',
        price: '500',
      ),
      ProductItem(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChoicePage(index: 1),
              fullscreenDialog: true
            ),
          );
        },
        image: 'assets/images/CoffeeBean.jpg',
        name: 'Bean B',
        price: '500',
      ),
      ProductItem(
        onTap: () {
          _handleTap(3);
        },
        image: 'assets/images/CoffeeBean.jpg',
        name: 'Bean C',
        price: '1000',
      ),
      ProductItem(
        onTap: () {
          _handleTap(4);
        },
        image: 'assets/images/CoffeeBean.jpg',
        name: 'Bean D',
        price: '1000',
      ),
    ];
  }

  void _handleTap(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to Cart'),
          content: _MyListItem(index),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          titlePadding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
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
    ]));
  }
}

class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({required this.item});

  @override
  Widget build(BuildContext context) {

    var isInCart = context.select<CartModel, bool>(
      (cart) => cart.items.contains(item),
    );
    
    // TODO: ボタンを右に寄せる
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child:Column(
            children: [
              Text("数量"),
              Text(
                '${context.select<CartModel, int>((cart) => cart.count(item))}',
                style: TextStyle(fontSize: 20),
              ),
            ],
        ),),
        Container(
          child: Row(
            children: [
       IconButton(
        icon: const Icon(Icons.remove),
          onPressed: () {
            var cart = context.read<CartModel>();
              if (isInCart && cart.count(item) > 0) {
              cart.remove(item);
            }
          },
          tooltip: 'Decrease quantity',
        ),

        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            var cart = context.read<CartModel>();
            cart.add(item);
          },
          tooltip: 'Increase quantity',
        ),
            ],),),
      ],
    );
      
  }
}
class _MyListItem extends StatelessWidget {
  final int index;
  const _MyListItem(this.index);

  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogModel, Item>(
      (catalog) => catalog.getByPosition(index),
    );
    return  _AddButton(item: item);
  }
}
class ChoicePage extends StatelessWidget {
  final int index;
  const ChoicePage({
    Key? key,
    required this.index,
  }) : super(key: key);

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
          SliverFixedExtentList(
            itemExtent: SizeConfig.blockSizeVertical * 10 + 2,
            delegate: SliverChildListDelegate(
              [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child:
                        Image(
                          image: AssetImage('assets/images/CoffeeBean.jpg'),
                          width: SizeConfig.blockSizeHorizontal * 20,
                          height: SizeConfig.blockSizeVertical * 20,
                          ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 20),
                          child:
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("サンセットフラペチーノ"),
                            Text("¥500"),
                            Text("価格は税込み価格です"),
                          ],
                        ),),
                      ],
                    ),
                    Column(
                    children:[
                      Container(
                      height: 2,
                      width: SizeConfig.screenWidth,
                      color: Colors.black12,
                    ),
                    Text("商品の説明"),
                    Row(
                      children: [
                        _MyListItem(index),
                        
                      ],
                    ),
                  ],),
              ],
                ),
            ),

        ],
      )
    );
  }
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: SizeConfig.blockSizeVertical * 8,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Store Select",
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
                  bottom: TabBar(
                    tabs: [
                      Tab(text: 'MAP'),
                      Tab(text: '近くの店舗'),
                      Tab(text: 'お気に入り'),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Center(
                    child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(33.57454362494296, 133.578431168963),
                    zoom: 15.0,
                    minZoom: 10,
                    maxZoom: 18,
                    interactiveFlags: InteractiveFlag.all &
                        ~InteractiveFlag.rotate, // 回転を無効にする
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://api.maptiler.com/maps/jp-mierune-streets/{z}/{x}/{y}.png?key=2YhYCGe6F0g5cNXrFsOp',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(33.57454362494296, 133.578431168963),
                          builder: (ctx) => Container(
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return _BottomSheet();
                                    });
                              },
                              icon: Icon(
                                Icons.circle,
                                color: Colors.yellow[800],
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution('MapTiler',
                            onTap: () => launchUrl(Uri.parse(
                                "https://www.maptiler.com/copyright/"))),
                        TextSourceAttribution('OpenStreetMap contributors',
                            onTap: () => launchUrl(Uri.parse(
                                "https://www.openstreetmap.org/copyright"))),
                        TextSourceAttribution('MIERUNE',
                            onTap: () =>
                                launchUrl(Uri.parse("https://maptiler.jp/"))),
                      ],
                    )
                  ],
                )),
                Center(child: Text('近くの店舗 Content')),
                Center(child: Text('お気に入り Content')),
              ],
            ),
          ),
        ));
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical * 30,
      color: Colors.white,
      child: BottomSheetItem(
        onTap: () => {},
        text: 'hoge',
      ),
    );
  }
}
