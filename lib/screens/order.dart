import 'package:flutter/material.dart';
import 'package:latin_one/entities/cart.dart';
import '../config/size_config.dart';
import '../screens/item.dart';
import 'package:latin_one/entities/shop.dart';
import 'package:provider/provider.dart';
import 'package:latin_one/screens/product.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/services.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int selected_store = 0;

  void _onItemTapped(int id) {
    setState(() {
      selected_store = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: SizeConfig.blockSizeVertical * 8,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Order",
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

          Consumer<SelectedShopModel>(builder: (context, selectedshop, child) {
            String text = selectedshop.isSelected
                ? selectedshop.selectedShop!.name
                : 'お店を選択してください';
            return SliverToBoxAdapter(
              child: StoreItem(
                text: text,
                image: Image.asset(
                  'assets/images/store.png',
                  width: 20,
                  height: 20,
                ),
                widget: StorePage(),
                selectstore: _onItemTapped,
              ),
            );
          }),
          // TODO: cart に追加された商品を表示する
          Consumer2<CartModel, SelectedShopModel>(
            builder: (context, cart, shop, child) {
              final isShopSelected = context.read<SelectedShopModel>();
              String text = cart.items.isEmpty ? '商品を選択してください' : '商品を追加';
              return SliverToBoxAdapter(
                child: OrderItem(
                    text: text,
                    image: Image.asset(
                      'assets/images/coffee.png',
                      width: 20,
                      height: 20,
                    ),
                    widget: ProductPage(),
                    selectedstore: isShopSelected.isSelected),
              );
            },
          ),
          Consumer<CartModel>(builder: (context, cart, child) {
            return SliverList(
                delegate: SliverChildBuilderDelegate(
                    childCount: cart.items.length, (context, index) {
              if (index >= cart.items.length) {
                return null;
              }
              final item = cart.items[index];
              // TODO: item.dart に 定義しておく?
              return Column(
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.blockSizeVertical * 10,
                    child: Row(children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            left: 10, top: 0, right: 0, bottom: 0),
                        child: IconButton(
                          onPressed: () {
                            cart.remove(item);
                          },
                          icon: Icon(Icons.remove_circle_outline),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            left: 10, top: 0, right: 0, bottom: 0),
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.screenWidth * 0.65,
                        child:
                            Text("${item.name}  ${item.quantity.toString()}点",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontFamily: 'gothic',
                                )),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text("￥${item.price * item.quantity}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'gothic',
                            )),
                      )
                    ]),
                  ),
                  Container(
                    height: 2,
                    width: SizeConfig.screenWidth,
                    color: Colors.black12,
                  ),
                ],
              );
            }));
          }),
          Consumer<CartModel>(builder: (context, cart, child) {
            final total = cart.totalPrice;
            print(total);
            return SliverToBoxAdapter(
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(left: 10),
                      child: Text("総合計",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'gothic',
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 10),
                      child: Text('￥${total}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'gothic',
                          )),
                    ),
                  ],
                ),
              ),
            );
          }),

          Consumer2<CartModel, SelectedShopModel>(
            builder: (context, cart, shop, child) {
              return SliverToBoxAdapter(
                child: Opacity(
                  opacity: cart.items.isNotEmpty ? 1.0 : 0.5,
                  child: ElevatedButton(
                    child: const Text('注文する'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                          SizeConfig.blockSizeHorizontal * 1, double.infinity),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.yellow[800],
                      shape: const StadiumBorder(),
                    ),
                    onPressed: cart.items.isNotEmpty
                        ? () {
                            String name;
                            int quantity;
                            int i;
                            String data_tmp = '';
                            for (i = 0; i < cart.items.length; i++) {
                              name = cart.items[i].name;
                              quantity = cart.items[i].quantity;
                              data_tmp = data_tmp + '${name}:${quantity}\n';
                            }
                            final data = ClipboardData(text: data_tmp);
                            Clipboard.setData(data);
                            showDialog<void>(
                                context: context,
                                builder: (_) {
                                  return AlertDialogSample();
                                });
                          }
                        : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AlertDialogSample extends StatelessWidget {
  const AlertDialogSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('注文を確定します'),
      content: Text('注文確定後のキャンセル，内容変更はできません'),
      actions: <Widget>[
        OutlinedButton(
          child: Text('キャンセル',
              style:
                  TextStyle(color: Colors.yellow[800], fontFamily: 'gothic')),
          onPressed: () {
            Navigator.pop(context);
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: Colors.yellow[800]!,
            ),
          ),
        ),
        ElevatedButton(
          child: const Text('OK'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.yellow[800],
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class OrderCompletionPage extends StatelessWidget {
  const OrderCompletionPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Text('注文内容がクリップボードにコピーされました．'),
    ));
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
    ShopModel shopList = ShopModel();
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
                                      return BottomSheetItem(
                                          onTap: () {},
                                          shop: shopList.getById(0));
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
