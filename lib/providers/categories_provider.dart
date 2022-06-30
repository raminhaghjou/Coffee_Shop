import 'package:coffee_shop_app/models/categories.dart';
import 'package:coffee_shop_app/models/menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class CategoriesProvider with ChangeNotifier {
  DatabaseReference databaseReference;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  Reference storageReference;
  List<Categories> listCategories = List();
  bool isLoading = false;
  List<Menu> listDetail = List();
  List<String> listDownloadURLDetail = List();

  Future<List<Categories>> getAllCategories() async {
    isLoading = true;
    await firebaseDatabase
        .reference()
        .child('Categories')
        .once()
        .then((DatabaseEvent databaseEvent) {
      Map<String, dynamic>.from(databaseEvent.snapshot.value)
          .forEach((key, value) {
        Categories categories = Categories(
          image: value['image'],
          name: value['name'],
          des: value['des'],
        );
        listCategories.add(categories);
      });
    });
    isLoading = false;
    notifyListeners();
    return listCategories;
  }

  Future<List<Menu>> getMenuByCategories(String categories) async {
    isLoading = true;
    listDetail.clear();
    listDownloadURLDetail.clear();
    var dataDetail = await firebaseDatabase
        .reference()
        .child('Menu')
        .child(categories)
        .once();
    Map<String, dynamic>.from(dataDetail.snapshot.value).forEach((key, value) {
      Menu menu = Menu(
        image: value['image'],
        name: value['name'],
        des: value['des'],
        menuId: value['menuId'],
        price: value['price'],
      );
      listDetail.add(menu);
    });
    isLoading = false;
    notifyListeners();
    return listDetail;
  }
}
