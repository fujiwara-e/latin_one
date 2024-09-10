import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/config/size_config.dart';
import 'package:latin_one/screens/item.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

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
                  "Products",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'ozworld',
                  ),
                )),
            titlePadding:
                EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
            collapseMode: CollapseMode.parallax,
          ),
        ),
        SliverFixedExtentList(
          itemExtent: SizeConfig.blockSizeVertical * 10,
          delegate: SliverChildListDelegate([
            MenuItem(image: "assets/images/store.png", text: "季節のおすすめ"),
            MenuItem(image: "assets/images/store.png", text: "コーヒー"),
          ]),
        ),
      ],
    ));
  }
}
