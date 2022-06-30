import 'package:coffee_shop_app/config/colors.dart';
import 'package:coffee_shop_app/providers/check_out_provider.dart';
import 'package:coffee_shop_app/providers/product_provider.dart';
import 'package:coffee_shop_app/providers/review_cart_provider.dart';
import 'package:coffee_shop_app/providers/user_provider.dart';
import 'package:coffee_shop_app/providers/wishlist_provider.dart';
import 'package:coffee_shop_app/util/router.dart';
import 'package:coffee_shop_app/util/router_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ReviewCartProvider>(
          create: (context) => ReviewCartProvider(),
        ),
        ChangeNotifierProvider<WishListProvider>(
          create: (context) => WishListProvider(),
        ),
        ChangeNotifierProvider<CheckoutProvider>(
          create: (context) => CheckoutProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: primaryColor,
            scaffoldBackgroundColor: scaffoldBackgroundColor),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routerr.onGenerateRouter,
        initialRoute: SplashPage,
        // home: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapShot) {
        //     if (snapShot.hasData) {
        //       return HomeScreen();
        //     }
        //     // return SignIn();
        //     return SplashScreenPage();
        //   },
        // ),
      ),
    );
  }
}
