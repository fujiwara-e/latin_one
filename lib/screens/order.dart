import 'package:flutter/material.dart';
import 'package:latin_one/screen.dart';
import '../config/size_config.dart';
import '../screens/item.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.onChangeIndex});

  final Function(int) onChangeIndex;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int selected_store = 0;
  List<Map<int, dynamic>> selectedProducts = [];
  String selectedProduct = 'No product selected';
  int selectedQuantity = 0;

  void _onItemTapped(int id) {
    setState(() {
      selected_store = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didpop) {
        setState(() {
          widget.onChangeIndex(0);
        });
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: SizeConfig.blockSizeVertical * 8,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Order",
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
              delegate: SliverChildListDelegate(
                [
                  StoreItem(text: 'お店を選択してください', image: Image.asset('assets/images/store.png', width: 20, height: 20,), widget: Container(), selectstore: _onItemTapped,),
                  OrderItem(text: '商品を選択してください', image: Image.asset('assets/images/coffee.png', width: 20, height: 20,), widget: Container(), selectedstore: selected_store),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Select Store Page
class StoreSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Store'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Javanican'),
            onTap: () {
              // Return 'Store 1' to the previous screen
              Navigator.pop(context, 'Javanican');
            },
          ),
          ListTile(
            title: Text('Store 2'),
            onTap: () {
              // Return 'Store 2' to the previous screen
              Navigator.pop(context, 'Store 2');
            },
          ),
          // Add more stores as needed
        ],
      ),
    );
  }
}

// Select Product Page
class Product {
  final String name;
  final String imageUrl;

  Product({required this.name, required this.imageUrl});
}

class ProductSelectionPage extends StatelessWidget {
  final List<Product> products = [
    Product(name: 'Product 1', imageUrl: 'assets/images/coffee.png'),
    Product(name: 'Product 2', imageUrl: 'assets/images/home.png'),
    Product(name: 'Product 3', imageUrl: 'assets/images/store.png'),
    // Product(name: 'Product 4', imageUrl: 'assets/product4.png'),
    // Product(name: 'Product 5', imageUrl: 'assets/product5.png'),
    // Product(name: 'Product 6', imageUrl: 'assets/product6.png'),
    // Product(name: 'Product 7', imageUrl: 'assets/product7.png'),
    // Product(name: 'Product 8', imageUrl: 'assets/product8.png'),
    // Product(name: 'Product 9', imageUrl: 'assets/product9.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1, // Square items
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () async {
                // Navigate to QuantitySelectionPage
                final quantity = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuantitySelectionPage(productName: product.name),
                  ),
                );

                // Return the product name and quantity to the previous screen
                if (quantity != null) {
                  Navigator.pop(
                      context, {'product': product.name, 'quantity': quantity});
                }
              },
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(product.name),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//select the number of products page
class QuantitySelectionPage extends StatefulWidget {
  final String productName;

  QuantitySelectionPage({required this.productName});

  @override
  _QuantitySelectionPageState createState() => _QuantitySelectionPageState();
}

class _QuantitySelectionPageState extends State<QuantitySelectionPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Quantity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Product: ${widget.productName}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) quantity--;
                    });
                  },
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Return the selected quantity to the previous screen
                Navigator.pop(context, quantity);
              },
              child: Text('Confirm Quantity'),
            ),
          ],
        ),
      ),
    );
  }
}
