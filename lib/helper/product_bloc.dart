import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/model.dart';
import 'cart_bloc.dart';
import 'firebase_helper/firebase_auth_helper.dart';

class ProductDB {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final CollectionReference<Map<String, dynamic>> _products =
  //     firestore.collection("products");
  final StreamController<List<ProductModel>> streamProductController =
      StreamController<List<ProductModel>>.broadcast();
  Stream<List<ProductModel>> get productStream =>
      streamProductController.stream;
  List<ProductModel> productList = [];

  getProductData() async {
    if (productList.isEmpty) {
      // }
      // else {

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('products').get();
      productList.clear();
      productList.addAll(querySnapshot.docs
          .map((docSnapshot) => ProductModel.fromMap(docSnapshot.data())));
      // final coll = firestore.collection('products');
      //
      // QuerySnapshot<Map<String, dynamic>> querySnapshot = await coll.get();
      // productList.addAll(
      //     querySnapshot.docs.map((e) => ProductModel.fromMap(e.data())));

      // streamProductController.sink.add(productList.toSet().toList());

      print('Product List = ${productList.length}');
    }
    print("product List is : => ${productList.length}");

    streamProductController.sink.add(productList.toSet().toList());
  }

  //TODO:Insert Records
  insertRecord(ProductModel productModel) async {
    print(productModel.name);
    await firestore.collection("products").doc(productModel.id.toString()).set({
      "id": productModel.id,
      "name": productModel.name,
      "price": productModel.price,
      "quantity": productModel.quantity,
    });
  }

//  TODO: fetchData firestore database
//   Stream<List<ProductModel>> fetchData() {
//     return _products.snapshots().map(
//           (event) => event.docs
//               .map((e) => ProductModel.fromMap(
//                     e.data(),
//                   ))
//               .toSet()
//               .toList(),
//         );
//   }

  //TODO: add to firebase database
  addProductData(int id, String name, int price, int quantity) async {
    await firestore
        .collection("MyCart")
        .doc(FireBaseAuthHelper.firebaseAuth.currentUser!.uid)
        .collection("add product")
        .doc(id.toString())
        .set(
      {
        "id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
      },
    );
    // await getProductData();
    // streamProductController.sink.add(productList);
  }

  clean() {
    productList.clear();
  }

  reload() {
    streamProductController.sink.add(productList.toSet().toList());
  }
}

ProductDB productDB = ProductDB();
