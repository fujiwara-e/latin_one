import 'package:flutter/material.dart';
import '../config/size_config.dart';
import 'item.dart';
import 'hello.dart';
import '../main.dart';
import '../screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latin_one/navigator/tab_navigator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

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
            //0.96
            // forceElevated: true,
            // elevation:20,
            pinned: true,
            // expandedHeight: 100.0,
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
                  setState(() {});

                  // NavigatorState? currentState = _navigatorKeys[TabItem.home]!.currentState;
                  // print("navigatorkey is $currentState");
                });

                setState(() {
                  //widget.onChangeHomeIndex(1);
                });
                print("クリックされたぞ");
              },
            ),
          ),
          SliverFixedExtentList(
            itemExtent: SizeConfig.blockSizeVertical * 29,
            delegate: SliverChildListDelegate([
              ProductItem(
                onTap: () {
                  setState(() {
                    // widget.onChangeIndex(2);
                  });
                  Builder(
                    builder: (BuildContext context) =>
                        Screen(title: 'Latin One'),
                  );
                  print(selectedIndex);
                },
                image: 'assets/images/CoffeeBean.jpg',
                text: 'Order',
              ),
              ProductItem(
                onTap: () {
                  print("クリックされたぞ!!!!!");
                },
                image: 'assets/images/Latte.jpg',
                text: 'Products',
              ),
              ProductItem(
                onTap: () {
                  setState(() {
                    // widget.onChangeIndex(1);
                  });
                },
                image: 'assets/images/Machine.jpg',
                text: 'Shops',
              ),
              ProductItem(
                onTap: () {
                  print("クリックされたぞ!!!!!");
                },
                image: 'assets/images/Latte.jpg',
                text: '',
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
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'gothic',
                          ),
                        )),
                    titlePadding:
                        EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
                    collapseMode: CollapseMode.parallax,
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(text: 'Tab 1'),
                      Tab(text: 'Tab 2'),
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
