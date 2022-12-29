import 'package:flbloc_demo/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreenCubit extends StatelessWidget {
  const CartScreenCubit({super.key});

  @override
  Widget build(BuildContext context) {
    final hasEmptyCart =
        context.select<StoreCubit, bool>((b) => b.state.cartIds.isEmpty);
    final cartProducts = context.select<StoreCubit, List<Product>>(
      (b) => b.state.products
          .where((product) => b.state.cartIds.contains(product.id))
          .toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: hasEmptyCart
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Add product'),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];

                return Card(
                  key: ValueKey(product.id),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Flexible(
                          child: Image.network(product.image),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Text(
                            product.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () => context
                              .read<StoreCubit>()
                              .removeFromCart(product.id),
                          style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.all(18),
                            ),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.black12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.remove_shopping_cart,
                                color: Colors.black45,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Remove from cart',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
