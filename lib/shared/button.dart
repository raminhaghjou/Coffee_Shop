import 'package:coffee_shop_app/util/const.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const Button({Key key, @required this.title,@required this.onTap}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: kColorGreen,
        onPressed: onTap,
        child: Text(title,style:
        TextStyle(
            color: Colors.white
        ),
        ),
      ),
    );
  }
}
