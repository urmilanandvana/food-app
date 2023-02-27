import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_bloc/helper/product_bloc.dart';

import '../model/model.dart';
import 'firebase_helper/firebase_auth_helper.dart';

class Bloc {
  final StreamController<List<ProductModel>> streamController =
      StreamController<List<ProductModel>>.broadcast();

  Stream<List<ProductModel>> get stream => streamController.stream;
  List<ProductModel> items = [];

  getData() async {
    // if (items.isNotEmpty) {
    QuerySnapshot<Map<String, dynamic>> snapshot = await ProductDB.firestore
        .collection("MyCart")
        .doc(FireBaseAuthHelper.firebaseAuth.currentUser!.uid)
        .collection("add product")
        .get();
    items.clear();
    items.addAll(snapshot.docs
        .map((docSnapshot) => ProductModel.fromMap(docSnapshot.data()))
        .toSet()
        .toList());
    items = items.toSet().toList();
    streamController.sink.add(items.toSet().toList());
    // } else {
    //   QuerySnapshot<Map<String, dynamic>> snapshot = await ProductDB.firestore
    //       .collection("MyCart")
    //       .doc(FireBaseAuthHelper.firebaseAuth.currentUser!.uid)
    //       .collection("add product")
    //       .get();
    //
    //   items.addAll(snapshot.docs
    //       .map((docSnapshot) => ProductModel.fromMap(docSnapshot.data()))
    //       .toSet()
    //       .toList());
    //   streamController.sink.add(items.toSet().toList());
    // }
  }

  //  TODO: Increment Quantity
  incrementQuantity(ProductModel productModel, int quantity) async {
    print("increment qty $quantity");
    await ProductDB.firestore
        .collection("MyCart")
        .doc(FireBaseAuthHelper.firebaseAuth.currentUser!.uid)
        .collection("add product")
        .doc(productModel.id.toString())
        .update({
      'quantity': quantity + 1,
      'documentId': productModel.id,
    });
    items.clear();
    await getData();
  }

  // TODO: Decrement Quantity
  decrementQuantity(ProductModel productModel, int quantity) async {
    await ProductDB.firestore
        .collection("MyCart")
        .doc(FireBaseAuthHelper.firebaseAuth.currentUser!.uid)
        .collection("add product")
        .doc(productModel.id.toString())
        .update({
      'quantity': quantity - 1,
    });

    items.clear();
    await getData();
  }

  int getQty(int id) {
    int qty = 0;

    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].id == id) {
          qty = items[i].quantity;
        }
      }
    }
    return qty;
  }

  deleteItems(int id) async {
    await ProductDB.firestore
        .collection("MyCart")
        .doc(FireBaseAuthHelper.firebaseAuth.currentUser!.uid)
        .collection("add product")
        .doc(id.toString())
        .delete();

    items.clear();
    await getData();
  }

  clean() {
    items.clear();
  }

  itemsLength() {
    int length = 0;
    items.toSet().toList();

    if (items.isNotEmpty) {
      length = 0;
      print("Items Length :=> ${items.length}");
      length = items.length;
    }
    return items.length;
  }

  reload() {
    streamController.sink.add(items.toSet().toList());
  }
}

Bloc bloc = Bloc();
