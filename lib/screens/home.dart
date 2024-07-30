import 'package:flutter/material.dart';
import '../config/size_config.dart';
import 'item.dart';
import 'hello.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
            SliverAppBar(
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
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    print("クリックされたぞ");
                    print(SizeConfig.blockSizeVertical);
                    print(SizeConfig.blockSizeHorizontal);
                  },
                ),
              ),
              SliverFixedExtentList(
                itemExtent: SizeConfig.blockSizeVertical * 29,
                delegate: SliverChildListDelegate([
                  ProductItem(
                    onTap: () {
                      print("クリックされたぞ!!!!!");
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
                      print("クリックされたぞ!!!!!");
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
        ));
  }
}
