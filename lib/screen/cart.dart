import 'package:flutter/material.dart';

import '../helper/cart_bloc.dart';
import '../model/model.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: bloc.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            List<ProductModel> data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                print("list QTY= ${data[i].quantity}");
                return Card(
                  child: ListTile(
                    leading: Text("${data[i].id}"),
                    title: Text(data[i].name),
                    subtitle: Text(
                        "${data[i].quantity}KG Price: ${data[i].totalPrice}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await bloc.incrementQuantity(
                                data[i], bloc.getQty(data[i].id));
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Color(0xff942D17),
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await bloc.decrementQuantity(
                                data[i], data[i].quantity);
                            print("quantity of i=${data[i].quantity}");
                            if (data[i].quantity == 1) {
                              await bloc.deleteItems(data[i].id);
                              data.removeAt(i);
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle_outlined,
                            color: Color(0xff942D17),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            print("cart page else...");
            bloc.getData();
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
