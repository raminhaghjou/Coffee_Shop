import 'dart:async';

import 'package:coffee_shop_app/shared/logo.dart';
import 'package:coffee_shop_app/util/const.dart';
import 'package:coffee_shop_app/util/router_path.dart';
import 'package:coffee_shop_app/util/sizeconfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1),
        () => Navigator.pushReplacementNamed(context, OptionAuthPagee));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/onboard/splash.png'),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kColorSplash.withOpacity(0.8),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getScreenWith(30), vertical: getScreenHeight(50)),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Logo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
