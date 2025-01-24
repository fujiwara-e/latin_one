import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/entities/cart.dart';
import '../config/size_config.dart';
import '../screens/item.dart';
import 'package:latin_one/entities/shop.dart';
import 'package:latin_one/entities/customer.dart';
import 'package:latin_one/screens/shops.dart';
import 'package:provider/provider.dart';
import 'package:latin_one/screens/product.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

          Consumer3<CartModel, SelectedShopModel, CustomerModel>(
            builder: (context, cart, shop, customer, child) {
              final isShopSelected = context.read<SelectedShopModel>();
              String text = customer.isSeted
                  ? '${customer.firstName} ${customer.lastName} 様'
                  : '配達先を指定してください';
              return SliverToBoxAdapter(
                child: InfoItem(
                    text: text,
                    widget: FormPage(),
                    selectedstore: isShopSelected.isSelected),
              );
            },
          ),

          Consumer<CartModel>(builder: (context, cart, child) {
            final total = cart.totalPrice;
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

          Consumer3<CartModel, SelectedShopModel, CustomerModel>(
            builder: (context, cart, shop, customer, child) {
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
                    onPressed: cart.items.isNotEmpty && customer.isSeted
                        ? () {
                            showDialog<void>(
                                context: context,
                                builder: (_) {
                                  return Alert();
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

class Alert extends StatelessWidget {
  const Alert({Key? key}) : super(key: key);

  Future<bool> AddOrderData(cart, customer) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var i;
    var name;
    var quantity;
    var now;
    var items = [];

    for (i = 0; i < cart.items.length; i++) {
      name = cart.items[i].name;
      quantity = cart.items[i].quantity;
      items.add({'name': name, 'quantity': quantity});
    }

    now = DateTime.now();

    final messagingInstance = FirebaseMessaging.instance;
    messagingInstance.requestPermission();
    final fcmToken = await messagingInstance.getToken();

    final orderData = {
      'address': customer.address,
      'date': now,
      'items': items,
      'mail_address': customer.mail,
      'status': '未確認',
      'token': fcmToken,
      'name': customer.firstName + customer.lastName,
      'zipcode': customer.zipcode,
    };

    try {
      final docRef = await db.collection('Orders').add(orderData);
      return true;
    } catch (e) {
      return false;
    }
  }

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
          onPressed: () async {
            var cart = context.read<CartModel>();
            var shop = context.read<SelectedShopModel>();
            var customer = context.read<CustomerModel>();
            bool isOrdered = await AddOrderData(cart, customer);

            cart.reset();
            shop.reset();
            customer.reset();
            Navigator.pop(context);
            if (isOrdered) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const OrderCompletionPage(),
                    fullscreenDialog: true),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('エラー'),
                    content: Text('注文の登録に失敗しました。再度お試しください。'),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  void launch_mail(String mailTitle, String mailBody, String mailAddress) {
    final Uri mailUri = Uri(
      scheme: 'mailto',
      path: mailAddress,
      queryParameters: {
        'subject': mailTitle,
        'body': mailBody,
      },
    );
    final encodedUri = mailUri.toString().replaceAll('+', '%20');
    _launchUrl(Uri.parse(encodedUri));
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw ArgumentError('Could not launch $url');
    }
  }
}

class OrderCompletionPage extends StatelessWidget {
  const OrderCompletionPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical * 10),
            child: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Order Complete',
                    style: TextStyle(
                      fontSize: SizeConfig.TitleSize,
                      color: Colors.black,
                      fontFamily: 'ozworld',
                    )),
              ),
            )),
        body: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Align(
            child: Text(
              'ご注文ありがとうございました。\n\n商品到着までしばらくお待ちください。',
              style: TextStyle(fontSize: 20, fontFamily: 'gothic'),
            ),
          ),
        ));
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  final TextEditingController _firstName_controller = TextEditingController();
  final TextEditingController _lastName_controller = TextEditingController();
  final TextEditingController _zipcode_controller = TextEditingController();
  final TextEditingController _address_controller = TextEditingController();
  final TextEditingController _mail_controller = TextEditingController();

  List<String> _previousInputs = [];

  Widget build(BuildContext context) {
    _loadPreviousInputs();
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical * 10),
            child: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Information',
                    style: TextStyle(
                      fontSize: SizeConfig.TitleSize,
                      color: Colors.black,
                      fontFamily: 'ozworld',
                    )),
              ),
            )),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: SizeConfig.FormSize,
                          child: Row(children: [
                            Expanded(
                                child: FormItem(
                              text: "姓",
                              controller: _firstName_controller,
                            )),
                            SizedBox(width: 10),
                            Expanded(
                                child: FormItem(
                              text: "名",
                              controller: _lastName_controller,
                            )),
                          ]),
                        ),
                        SizedBox(
                          height: SizeConfig.FormSize,
                          child: FormItem(
                            text: "メールアドレス",
                            controller: _mail_controller,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.FormSize,
                          child: Row(
                            children: [
                              Expanded(
                                  child: FormItem(
                                text: "郵便番号",
                                controller: _zipcode_controller,
                              )),
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () async {
                                  final zipcode = _zipcode_controller.text;
                                  final address =
                                      await zipCodeToAddress(zipcode);
                                  if (address == null) {
                                    return;
                                  }
                                  _address_controller.text = address;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.FormSize,
                          child: FormItem(
                            text: "住所",
                            controller: _address_controller,
                          ),
                        ),
                      ])),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(left: 0, top: 0, right: 10, bottom: 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    var customer = context.read<CustomerModel>();
                    if (_previousInputs != []) {
                      setState(() {
                        _firstName_controller.text = _previousInputs[0];
                        _lastName_controller.text = _previousInputs[1];
                        _mail_controller.text = _previousInputs[2];
                        _zipcode_controller.text = _previousInputs[3];
                        _address_controller.text = _previousInputs[4];
                      });
                    }
                  },
                  child: Text('前回の内容を入力する'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(left: 0, top: 0, right: 10, bottom: 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var customer = context.read<CustomerModel>();
                      List<String> inputs = [];
                      inputs = [
                        _firstName_controller.text,
                        _lastName_controller.text,
                        _mail_controller.text,
                        _zipcode_controller.text,
                        _address_controller.text
                      ];
                      customer.set(inputs[0], inputs[1], inputs[2], inputs[3],
                          inputs[4]);
                      _savePreviousInputs(inputs);
                      Navigator.pop(context);
                    } else {
                      print("validate error");
                    }
                  },
                  child: Text('決定'),
                ),
              ),
            ),
          ],
        )));
  }

  Future<void> _loadPreviousInputs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _previousInputs = prefs.getStringList('previousInputs') ?? [];
    });
  }

  Future<void> _savePreviousInputs(List<String> inputs) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('previousInputs', inputs);
  }
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  late Future<Position> _futurePosition;
  late TabController _tabController;
  late List<int> intfavoriteList;
  List<int> nearbyshopList = [];

  @override
  void initState() {
    super.initState();
    _futurePosition = _determinePosition();
    _loadFavoriteShops();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadFavoriteShops();
        setState(() {
          intfavoriteList = favoriteshops.map((str) => int.parse(str)).toList();
        });
      }
    });
  }

  List<String> favoriteshops = [];

  Future<void> _loadFavoriteShops() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteshops = prefs.getStringList('favoriteshops') ?? [];
    });
  }

  Future<void> _savePreviousInputs(List<String> favoriteshops) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteshops', favoriteshops);
  }

  Widget build(BuildContext context) {
    // var shopmodel = context.read<SelectedShopModel>();

    // List<Shop> shopList = [];
    // for (int i = 0; i < shopmodel.shopList.shopNames.length; i++) {
    // shopList.add(shopmodel.shopList.getById(i));
    // }

    Position? position;

    intfavoriteList = favoriteshops.map((str) => int.parse(str)).toList();

    void nearbyListgen(shopList) {
      nearbyshopList = [];
      for (int i = 0; i < shopList.length; i++) {
        if (caluculateDistance(position!.latitude, position!.longitude,
                shopList[i].latitude, shopList[i].longitude) <
            10.0) {
          nearbyshopList.add(i);
        }
      }
    }

    List<StoreTabItem> genNearbyShopList(shopList) {
      nearbyListgen(shopList);
      return nearbyshopList.map((id) {
        var shopList = context.read<SelectedShopModel>();
        var shop = shopList.shopList.getById(id);
        return StoreTabItem(
            shop: shop, favoritelist: intfavoriteList, position: position);
      }).toList();
    }

    List<Marker> createMarkers(
        BuildContext context, List<Shop> shopList, List<int> intfavoriteList) {
      return shopList.map((shop) {
        return Marker(
          width: 40,
          height: 40,
          point: LatLng(shop.latitude, shop.longitude),
          builder: (ctx) => Container(
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomSheetItem(
                      onTap: () {},
                      favoritelist: intfavoriteList,
                      shop: shop,
                    );
                  },
                );
              },
              icon: Icon(
                Icons.circle,
                color: Colors.yellow[800],
                size: 20.0,
              ),
            ),
          ),
        );
      }).toList();
    }

    var shopmodel = context.read<SelectedShopModel>();
    var shopList;
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([_futurePosition, shopmodel.init()]),
      builder: (BuildContext content, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          position = snapshot.data![0];
          shopList = snapshot.data![1];
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
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
                        titlePadding: EdgeInsets.only(
                            top: 0, right: 0, bottom: 0, left: 20),
                        collapseMode: CollapseMode.parallax,
                      ),
                      bottom: TabBar(
                        controller: _tabController,
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
                  controller: _tabController,
                  children: [
                    Center(
                        child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(34.6656739, 133.9130976),
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
                            markers: createMarkers(
                                context, shopList, intfavoriteList)),
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution('MapTiler',
                                onTap: () => launchUrl(Uri.parse(
                                    "https://www.maptiler.com/copyright/"))),
                            TextSourceAttribution('OpenStreetMap contributors',
                                onTap: () => launchUrl(Uri.parse(
                                    "https://www.openstreetmap.org/copyright"))),
                            TextSourceAttribution('MIERUNE',
                                onTap: () => launchUrl(
                                    Uri.parse("https://maptiler.jp/"))),
                          ],
                        )
                      ],
                    )),
                    Center(
                        child: ListView(
                            padding: EdgeInsets.zero,
                            children: genNearbyShopList(shopList))),
                    Center(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: intfavoriteList.map((id) {
                          var shopList = context.read<SelectedShopModel>();
                          var shop = shopList.shopList.getById(id);
                          return StoreTabItem(
                              shop: shop,
                              favoritelist: intfavoriteList,
                              position: position);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}

Future<String?> zipCodeToAddress(String zipCode) async {
  if (zipCode.length != 7) {
    return null;
  }
  final response = await get(
    Uri.parse(
      'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipCode',
    ),
  );
  if (response.statusCode != 200) {
    return null;
  }
  final result = jsonDecode(response.body);
  if (result['results'] == null) {
    return null;
  }
  final addressMap = (result['results'] as List).first;
  final address =
      '${addressMap['address1']} ${addressMap['address2']} ${addressMap['address3']}'; // 住所を連結する。
  return address;
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

double caluculateDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  double distance = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  return (double.parse((distance / 1000).toStringAsFixed(1))); //km
}
