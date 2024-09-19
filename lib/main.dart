import 'package:flutter/material.dart';
import 'package:latin_one/entities/cart.dart';
import 'package:latin_one/entities/catalog.dart';
import 'package:latin_one/entities/customer.dart';
import 'package:latin_one/screens/shops.dart';
import './config/size_config.dart';
import 'screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'entities/shop.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MultiProvider(
        providers: [
          Provider(create: (context) => CatalogModel()),
          ChangeNotifierProxyProvider<CatalogModel, CartModel>(
              create: (context) {
            final cart = CartModel();
            cart.init();
            return cart;
          }, update: (context, catalog, cart) {
            if (cart == null) {
              throw ArgumentError.notNull('cart');
            }
            cart.catalog = catalog;
            return cart;
          }),
          Provider(create: (context) => ShopModel()),
          ChangeNotifierProxyProvider<ShopModel, SelectedShopModel>(
              create: (context) {
            final shop = SelectedShopModel();
            shop.init();
            return shop;
          }, update: (context, shopList, selectedShop) {
            if (selectedShop == null) {
              throw ArgumentError.notNull('selectedShop');
            }
            selectedShop.shopList = shopList;
            return selectedShop;
          }),
          ChangeNotifierProvider<CustomerModel>(
            create: (context) => CustomerModel('', '', '', '', ''),
          ),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              useMaterial3: true,
              pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                  }),
            ),
            home: Screen(title: 'Latin One')));
  }
}
