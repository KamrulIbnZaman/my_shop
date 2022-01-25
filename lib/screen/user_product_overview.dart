import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../providers/product_provider.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductOverview extends StatelessWidget {
  static const routeName = '/user-overview';

Future<void> _refreshProducts(BuildContext context) async{
  await Provider.of<Products>(context,listen: false).fetchProducts(true).catchError((onError){
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('$onError')));
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context,snapshot) =>snapshot.connectionState==ConnectionState.waiting?
        Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh:()=> _refreshProducts(context),
          child: Consumer<Products>(
            builder: (ctx, prod, _)=> Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: prod.items.length,
                itemBuilder: (ctx, i) => Column(
                  children: [
                    UserProductItem(
                      prod.items[i].id,
                      prod.items[i].title,
                      prod.items[i].imageUrl,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
