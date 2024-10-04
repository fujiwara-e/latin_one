import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:latin_one/config/size_config.dart';

class ConnectivityCheck extends StatefulWidget {
  const ConnectivityCheck({super.key, required this.child});

  final Widget child;

  @override
  State<ConnectivityCheck> createState() => _State();
}

class _State extends State<ConnectivityCheck> {
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) {
      return;
    }

    updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return connectionStatus == ConnectivityResult.none
        ? AlertDialog(
            title: Text("エラーが発生しました",
                style: TextStyle(fontFamily: 'gothic', fontSize: 20)),
            content: SizedBox(
              width: SizeConfig.blockSizeHorizontal * 80,
              height: SizeConfig.blockSizeVertical * 10,
              child: Text("インターネット接続がありません。端末の設定を確認してください。",
                  style: TextStyle(fontFamily: 'gothic', fontSize: 12)),
            ),
          )
        : widget.child;
  }
}
