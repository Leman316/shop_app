import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // ProductDetailScreen(this.title);

  static const routeName = '\product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedproduct = Provider.of<Products>(context).findbyId(productId);
    return Scaffold(
      //  appBar: AppBar(
      //    title: Text(loadedproduct.title),  ),
      drawer: AppDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedproduct.title),
              background: Hero(
                  tag: loadedproduct.id,
                  child:
                      Image.network(loadedproduct.imageUrl, fit: BoxFit.cover)),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '${loadedproduct.price}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              SizedBox(height: 10),
              Container(
                child: Text(
                  '${loadedproduct.description}',
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                width: double.infinity,
              ),
              SizedBox(height: 750),
            ]),
          ),
        ],
      ),
    );
  }
}
