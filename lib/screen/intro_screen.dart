import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      body: Center(
        child:  Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: Icon(
              Icons.shopping_bag,
              color: Theme.of(context).primaryColor,
            ),
          ),
      ),
    );
  }
}
