import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/orde_screen.dart';
import '../screen/user_product_overview.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth=Provider.of<Auth>(context,listen: false);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Happy Shop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Your Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductOverview.routeName);
            },
          )
          ,
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () =>auth.logout(),
          ),
        ],
      ),
    );
  }
}
