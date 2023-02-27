import '../model/model.dart';

class AllOperations {
  List<ProductModel> items = [];

  // addProduct(ProductModel productModel) {
  //   items.add(
  //     ProductModel(
  //       id: productModel.id,
  //       name: productModel.name,
  //       price: productModel.price,
  //     ),
  //   );
  // }

  // ProductModel? getId(int id) {
  //   for (int i = 0; i <= items.length; i++) {
  //     if (id == items[i].id) {
  //       return items[i];
  //     }
  //   }
  //   return null;
  // }

  // Future<List<ProductModel>?> fetchData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? jsonData = prefs.getString("cart");
  //   if (jsonData != null) {
  //     List jsonArr = json.decode(jsonData);
  //     _items = jsonArr.map((e) => ProductModel.fromMap(e)).toList();
  //     return _items;
  //   }
  //   return null;
  // }
  incrementQuantity(int id) {
    ProductModel productModel = items.firstWhere((element) => element.id == id);
    return ++productModel.quantity;
  }

  decrementQuantity(int id) {
    ProductModel productModel = items.firstWhere((element) => element.id == id);

    --productModel.quantity;
  }

  List<ProductModel> getList() {
    return items;
  }
// saveData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('cart', json.encode(productDB.fetchData()));
// }
}

AllOperations allOperations = AllOperations();
