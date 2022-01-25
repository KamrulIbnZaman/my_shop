import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String count;

  Badge(this.child, this.count);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange,
            ),
            constraints: BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
            child: Text(
              count,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
