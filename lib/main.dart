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

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (Platform.isAndroid) {
      await FlutterLocalNotificationsPlugin().show(
        0,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_notification_channel',
            'プッシュ通知のチャンネル名',
            importance: Importance.max,
            icon: android?.smallIcon,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  });

  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (details) {
      if (details.payload != null) {
        final payloadMap =
            json.decode(details.payload!) as Map<String, dynamic>;
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
