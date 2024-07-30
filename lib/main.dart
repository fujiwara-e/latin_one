import 'package:flutter/material.dart';
import 'package:latin_one/screens/shops.dart';
import './config/size_config.dart';
import 'screens/home.dart';
import 'screens/order.dart';
import 'screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
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
      home: Screen(title: 'Latin One'),
      routes: {
        "/home": (BuildContext context) => MyHomePage(title: 'hoge'),
        "/shops": (BuildContext context) => ShopsPage(title: 'hoge'),
        "/order": (BuildContext context) => OrderPage(title: 'hoge'),
        "/shops/shop": (BuildContext context) => ShopPage(title: 'hoge'),
      },
    );
  }
}