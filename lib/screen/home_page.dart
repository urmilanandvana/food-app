import 'package:flutter/material.dart';

import '../helper/cart_bloc.dart';
import '../helper/firebase_helper/firebase_auth_helper.dart';
import '../helper/product_bloc.dart';
import '../model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? itemsLength;
  @override
  void dispose() {
    // TODO: implement
    productDB.clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            FireBaseAuthHelper.fireBaseAuthHelper.signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('login_page', (route) => false);
          },
          icon: const Icon(Icons.power_settings_new),
        ),
        title: const Text("Yax Product"),
        centerTitle: true,
        actions: [
          StreamBuilder<List<ProductModel>>(
              stream: bloc.stream,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    (bloc.itemsLength() != 0)
                        ? Container(
                            height: 30,
                            width: 30,
                            child: Text(bloc.itemsLength().toString()),
                          )
                        : const SizedBox(
                            height: 30,
                            width: 30,
                          ),
                    IconButton(
                      onPressed: () {
                        // await bloc.clean();
                        Navigator.of(context).pushNamed('cart_page');
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                    ),
                  ],
                );
              }),
        ],
      ),

      //TODO:streamBuilder
      body: StreamBuilder<List<ProductModel>>(
        stream: productDB.productStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR : ${snapshot.error}");
          } else if (snapshot.hasData) {
            List<ProductModel>? data = snapshot.data!.toSet().toList();
            data = data.toSet().toList();
            print("------------------");
            print("data Length ${data.toSet().toList().length}");
            print("------------------");
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    leading: Text("${data![i].id}"),
                    title: Text(data[i].name),
                    subtitle: Text("1KG \$${data[i].price}"),
                    trailing: StreamBuilder<List<ProductModel>>(
                      stream: bloc.stream,
                      builder: (BuildContext context, snapshot) {
                        return (bloc.getQty(data![i].id) != 0)
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await bloc.incrementQuantity(
                                          data![i], bloc.getQty(data[i].id));
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Color(0xff942D17),
                                      size: 30,
                                    ),
                                  ),
                                  Text('${bloc.getQty(data[i].id)}'),
                                  IconButton(
                                    onPressed: () async {
                                      await bloc.decrementQuantity(
                                          data![i], bloc.getQty(data[i].id));
                                      if (bloc.getQty(data[i].id) == 0) {
                                        await bloc.deleteItems(data[i].id);
                                        await bloc.clean();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outlined,
                                      color: Color(0xff942D17),
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  productDB.addProductData(
                                    data![i].id,
                                    data[i].name,
                                    data[i].price,
                                    data[i].quantity + 1,
                                  );
                                  await bloc.getData();
                                  // bloc.getQty(data![i].id);
                                  // await bloc.reload();
                                  // Navigator.of(context).pushNamed('cart_page');
                                },
                                child: const Text("Add"),
                              );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            print("Product else data ......");
            productDB.getProductData();
            // bloc.reload();
            // productDB.reload();
            bloc.getData();
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
