import 'package:flbloc_demo/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreAppCubit extends StatelessWidget {
  const StoreAppCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BlocProvider(
        create: (context) => StoreCubit(),
        child: const _StoreAppView(title: 'My Store'),
      ),
    );
  }
}

class _StoreAppView extends StatefulWidget {
  const _StoreAppView({required this.title});

  final String title;

  @override
  State<_StoreAppView> createState() => __StoreAppViewState();
}

class __StoreAppViewState extends State<_StoreAppView> {
  void _addToCart(int cartId) {
    context.read<StoreCubit>().addToCart(cartId);
  }

  void _removeFromCart(int cartId) {
    context.read<StoreCubit>().removeFromCart(cartId);
  }

  void _viewCart() {
    Navigator.push(
      context,
      PageRouteBuilder(
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: BlocProvider.value(
                value: context.read<StoreCubit>(),
                child: child,
              ),
            );
          },
          pageBuilder: (_, __, ___) => const CartScreenCubit()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocConsumer<StoreCubit, StoreState>(
          listenWhen: (previous, current) =>
              previous.cartIds.length != current.cartIds.length,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Shopping cart updated'),
              ),
            );
          },
          builder: (context, state) {
            if (state.productsStatus == StoreRequest.requestInProgress) {
              return const CircularProgressIndicator();
            }

            if (state.productsStatus == StoreRequest.requestFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Problem loading products'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      context.read<StoreCubit>().loadProducts();
                    },
                    child: const Text('Try again'),
                  ),
                ],
              );
            }

            if (state.productsStatus == StoreRequest.unknown) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shop_outlined,
                    size: 60,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 10),
                  const Text('No products to view'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      context.read<StoreCubit>().loadProducts();
                    },
                    child: const Text('Load products'),
                  ),
                ],
              );
            }

            // state.productsStatus == StoreRequest.success
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                final inCart = state.cartIds.contains(product.id);

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
                          onPressed: inCart
                              ? () => _removeFromCart(product.id)
                              : () => _addToCart(product.id),
                          style: ButtonStyle(
                            padding: const MaterialStatePropertyAll(
                              EdgeInsets.all(18),
                            ),
                            backgroundColor: inCart
                                ? const MaterialStatePropertyAll<Color>(
                                    Colors.black12)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: inCart
                                ? const [
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
                                  ]
                                : const [
                                    Icon(Icons.add_shopping_cart),
                                    SizedBox(width: 10),
                                    Text('Add to cart')
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: _viewCart,
              tooltip: 'View Cart',
              child: const Icon(Icons.shopping_cart),
            ),
          ),
          BlocBuilder<StoreCubit, StoreState>(
            builder: (context, state) {
              if (state.cartIds.isEmpty) {
                return Container();
              }

              return Positioned(
                right: -4,
                bottom: 40,
                child: CircleAvatar(
                  backgroundColor: Colors.tealAccent,
                  radius: 12,
                  child: Text(
                    state.cartIds.length.toString(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
