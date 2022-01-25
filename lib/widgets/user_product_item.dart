import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/edit_product_screen.dart';
import '../providers/product_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imagrUrl;
  UserProductItem(this.id, this.title, this.imagrUrl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imagrUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteItem(id);
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
