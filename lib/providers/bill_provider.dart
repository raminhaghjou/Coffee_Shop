import 'package:coffee_shop_app/models/bill.dart';
import 'package:coffee_shop_app/models/cart.dart';
import 'package:coffee_shop_app/models/menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BillProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  List<Bill> listBill = [];
  bool isLoading = false;

  Future<List<Bill>> getAllBill() async {
    isLoading = true;
    listBill.clear();

    await firebaseDatabase
        .reference()
        .child('Order')
        .once()
        .then((DatabaseEvent databaseEvent) {
      Map<String, dynamic>.from(databaseEvent.snapshot.value)
          .forEach((key, value) {
        List listMenu = value['product'];
        List<Cart> listCartt = List();
        for (int i = 0; i < listMenu.length; i++) {
          Menu menu = Menu(
            price: value['product'][i]['price'],
            image: value['product'][i]['image'],
            name: value['product'][i]['menu'],
          );
          listCartt.add(
            Cart(
              quantity: value['product'][i]['quantity'],
              menu: Menu(price: menu.price, image: menu.image, name: menu.name),
            ),
          );
        }
        Bill bill = Bill(
          codeBill: value['codeBill'],
          dateTime: value['dateTime'].toString(),
          totalBill: value['totalBill'].toString(),
          listCart: listCartt,
        );
        listBill.add(bill);
      });
    });
    isLoading = false;
    notifyListeners();
    return listBill;
  }
}
