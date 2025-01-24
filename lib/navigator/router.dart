import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home.dart';
import '../screens/shops.dart';
import '../screens/order.dart';

// GoRouter configuration
final goRouter = GoRouter(
  // screen when app start
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/Order',
      builder: (context, state) => OrderPage(),
    ),
    GoRoute(
      path: '/Shops',
      builder: (context, state) => ShopsPage(),
    ),
  ],
);
