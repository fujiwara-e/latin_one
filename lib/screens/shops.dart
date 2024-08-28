import 'package:flutter/material.dart';
import 'package:latin_one/screen.dart';
import 'package:latin_one/screens/item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/size_config.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
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
                    "JAVANICAN",
                    style: TextStyle(
                      fontSize: 20,
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
            delegate: SliverChildListDelegate([
              AddressItem(text: "高知県 高知市 布師田3061 ラテンコーヒー"),
              ShopItem(column_name: '営業時間', text: "9:00-18:00"),
              ShopItem(column_name: '定休日', text: "不定休"),
              ShopItem(column_name: 'モバイル決済', text: "現金のみ！！"),
            ]),
          ),
        ],
      ),
    );
  }
}

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical * 10),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Shops',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'gothic',
                    )),
              ),
            )),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(33.57454362494296, 133.578431168963),
            zoom: 15.0,
            minZoom: 10,
            maxZoom: 18,
            interactiveFlags:
                InteractiveFlag.all & ~InteractiveFlag.rotate, // 回転を無効にする
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
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                        builder: (context) => ShopPage(),
                        fullscreenDialog: true,
                      )),
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
                    onTap: () => launchUrl(
                        Uri.parse("https://www.maptiler.com/copyright/"))),
                TextSourceAttribution('OpenStreetMap contributors',
                    onTap: () => launchUrl(
                        Uri.parse("https://www.openstreetmap.org/copyright"))),
                TextSourceAttribution('MIERUNE',
                    onTap: () => launchUrl(Uri.parse("https://maptiler.jp/"))),
              ],
            )
          ],
        ));
  }
}
