import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:latin_one/entities/cart.dart';
import 'package:latin_one/entities/catalog.dart';
import 'package:latin_one/entities/customer.dart';
import 'package:latin_one/screens/shops.dart';
import './config/size_config.dart';
import 'screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'entities/shop.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  final messagingInstance = FirebaseMessaging.instance;
  messagingInstance.requestPermission();
  final fcmToken = await messagingInstance.getToken();
  debugPrint('FCM Token: $fcmToken');

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  if (Platform.isAndroid) {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'default_notification_channel',
        'プッシュ通知のチャンネル名',
        importance: Importance.max,
      ),
    );
    await androidImplementation?.requestNotificationsPermission();
  }

  _initNotification();

  final message = await FirebaseMessaging.instance.getInitialMessage();
  // 取得したmessageを利用した処理などを記載する

  final messageForAllProduct =
      await FirebaseMessaging.instance.subscribeToTopic("Product");
  final messageForAllShop =
      await FirebaseMessaging.instance.subscribeToTopic("Shop");
  final messageForAllAnnounce =
      await FirebaseMessaging.instance.subscribeToTopic("Announce");

  runApp(
    const MyApp(),
  );
}

Future<void> _initNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // バックグラウンド起動中に通知をタップした場合の処理
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    // フォアグラウンド起動中に通知が来た場合の処理

    // フォアグラウンド起動中に通知が来た場合、
    // Androidは通知が表示されないため、ローカル通知として表示する
    // https://firebase.flutter.dev/docs/messaging/notifications#application-in-foreground
    if (Platform.isAndroid) {
      // プッシュ通知をローカルから表示する
      await FlutterLocalNotificationsPlugin().show(
        0,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_notification_channel',
            'プッシュ通知のチャンネル名',
            importance: Importance.max, // 通知の重要度の設定
            icon: android?.smallIcon,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  });

  // ローカルから表示したプッシュ通知をタップした場合の処理を設定
  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings(
          '@mipmap/ic_launcher'), //通知アイコンの設定は適宜行ってください
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (details) {
      if (details.payload != null) {
        final payloadMap =
            json.decode(details.payload!) as Map<String, dynamic>;
        debugPrint(payloadMap.toString());
      }
    },
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
