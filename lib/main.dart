import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_svg/flutter_svg.dart';
import './config/size_config.dart';
import 'item.dart';
=======
import './config/size_config.dart';
>>>>>>> a1b213e (size)

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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body:CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: SizeConfig.blockSizeVertical * 12,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Text('こんにちは',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'gothic',
                  ),
                ),
              ),
              titlePadding: EdgeInsets.only(top: 0,right:0,bottom:0,left: 20),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: SizeConfig.blockSizeVertical * 0.96,
            //0.96
            // forceElevated: true,
            // elevation:20,
            pinned:true,
            // expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(

            ),
            leadingWidth: 120,
            leading: TextButton.icon(
              icon: const Icon(Icons.mail_outlined),
              label: const Text('inbox'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: (){
                print("クリックされたぞ");
                print(SizeConfig.blockSizeVertical);
                print(SizeConfig.blockSizeHorizontal);
              },
            ),
          ),
          SliverFixedExtentList(
            itemExtent: SizeConfig.blockSizeVertical * 29,
            delegate: SliverChildListDelegate(
                [
                  ProductItem(onTap: (){
                    print("クリックされたぞ!!!!!");
                  },
                    image: 'assets/images/CoffeeBean.jpg',
                    text: 'Order',
                  ),
                  ProductItem(onTap: (){
                    print("クリックされたぞ!!!!!");
                  },
                    image: 'assets/images/Latte.jpg',
                    text: 'Products',
                  ),
                  ProductItem(onTap: (){
                    print("クリックされたぞ!!!!!");
                  },
                    image: 'assets/images/Machine.jpg',
                    text: 'Shops',
                  ),
                  ProductItem(onTap: (){
                    print("クリックされたぞ!!!!!");
                  },
                    image: 'assets/images/Latte.jpg',
                    text: '',
                  ),
                ]
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items:  <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/home.svg',semanticsLabel: 'Home', width: 25, height: 25),label: 'Home'),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/store.svg',semanticsLabel: 'Shops', width: 25, height: 25), label: 'Shops'),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/coffee.svg',semanticsLabel: 'Order', width: 25, height: 25), label: 'Order'),
      ],
      type: BottomNavigationBarType.fixed,
    )
    );
  }
}

