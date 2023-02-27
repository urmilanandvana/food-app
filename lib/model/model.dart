class ProductModel {
  int id;
  String name;
  int price = 0;
  int quantity;
  int? totalPrice;
  ProductModel({
    required this.quantity,
    required this.id,
    required this.name,
    required this.price,
    this.totalPrice,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
      totalPrice: data['totalPrice'] = data['price'] * data['quantity'],
    );
  }
}
