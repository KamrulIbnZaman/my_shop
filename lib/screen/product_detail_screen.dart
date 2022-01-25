import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productList = Provider.of<Products>(context, listen: false);
    final product = productList.findbyID(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            title: Text(product.title),
           pinned: true,
           flexibleSpace: FlexibleSpaceBar(
             background:  Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
           ), 
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Text(product.description),
            ),
            SizedBox(height: 800,),],
            ),
          ),
        ],
        
      ),
    );
  }
}
