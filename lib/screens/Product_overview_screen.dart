import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import './cart_screen.dart';

enum filterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavs = false;
  var _isinit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    try {
      Provider.of<Products>(context, listen: false).fetchandSetProduct();
    } catch (error) {
      print(error);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final productsContainer = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: filterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: filterOption.All,
              ),
            ],
            onSelected: (filterOption selectedValue) {
              print(selectedValue);
              setState(() {
                selectedValue == filterOption.Favorites
                    ? _showOnlyFavs = true
                    : _showOnlyFavs = false;
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, _child) => Badge(
              child: _child,
              value: cart.itemcount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routename);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavs),
    );
  }
}
