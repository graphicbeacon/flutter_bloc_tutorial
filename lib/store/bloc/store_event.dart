abstract class StoreEvent {
  const StoreEvent();
}

class StoreProductsRequested extends StoreEvent {}

class StoreProductsAddedToCart extends StoreEvent {
  const StoreProductsAddedToCart(this.cartId);

  final int cartId;
}

class StoreProductsRemovedFromCart extends StoreEvent {
  const StoreProductsRemovedFromCart(this.cartId);

  final int cartId;
}
