import 'package:flutter/material.dart';
import 'package:latin_one/config/size_config.dart';
import 'item.dart';
import 'hello.dart';
import 'package:latin_one/main.dart';
import 'package:latin_one/screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latin_one/screens/menu.dart';
import 'package:latin_one/network/connectivity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: SizeConfig.blockSizeVertical * 8,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Hello(),
              ),
              titlePadding:
                  EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: SizeConfig.blockSizeVertical * 0.96,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(),
            leadingWidth: 120,
            leading: TextButton.icon(
              icon: const Icon(Icons.mail_outlined),
              label: const Text('inbox'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                String? currentRoute = ModalRoute.of(context)?.settings.name;
                print("current route is $currentRoute");
                final docRef = db.collection("shops").doc("javanican");
                docRef.get().then((DocumentSnapshot doc) {
                  if (doc.exists) {
                    print('Value of key1: ${doc['address']}');
                  } else {
                    print('Document does not exist');
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "HogeScreen"),
                        builder: (context) => const InboxPage()),
                  );
                });

                setState(() {
                  canPopValue = false;
                });
              },
            ),
          ),
          SliverFixedExtentList(
            itemExtent: SizeConfig.blockSizeVertical * 29,
            delegate: SliverChildListDelegate([
              HomeItem(
                onTap: () {
                  final screenstate =
                      context.findAncestorStateOfType<ScreenState>();
                  if (screenstate != null) {
                    screenstate.onSelect(TabItem.order);
                  }
                },
                image: 'assets/images/CoffeeBean.jpg',
                text: 'Order',
              ),
              HomeItem(
                onTap: () {
                  final screenstate =
                      context.findAncestorStateOfType<ScreenState>();
                  if (screenstate != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoryPage(),
                        fullscreenDialog: true));
                  }
                },
                image: 'assets/images/Latte.jpg',
                text: 'Products',
              ),
              HomeItem(
                onTap: () {
                  final screenstate =
                      context.findAncestorStateOfType<ScreenState>();
                  if (screenstate != null) {
                    screenstate.onSelect(TabItem.shops);
                  }
                },
                image: 'assets/images/Machine.jpg',
                text: 'Shops',
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  expandedHeight: SizeConfig.blockSizeVertical * 8,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Inbox",
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
                      Tab(text: "What's New"),
                      Tab(text: "Message"),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Center(child: Text('Tab 1 Content')),
                Center(child: Text('Tab 2 Content')),
              ],
            ),
          ),
        ));
  }
}
