import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/repositories/cart_repo.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  final Box cartBox = Hive.box('cart');

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<IncreaseCartQuantity>(_onIncreaseQuantity);
    on<DecreaseCartQuantity>(_onDecreaseQuantity);
    on<SyncCartWithServer>(_onSyncCartWithServer);
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final message = await cartRepository.addToCart(
        userId: event.userId,
        productRef: event.productRef,
        variant: event.variantId,
        pincode: event.pincode,
      );

      List<CartProduct> cartItems =
          (cartBox.get('cart', defaultValue: []) as List)
              .map((e) => CartProduct.fromJson(Map<String, dynamic>.from(e)))
              .toList();

      cartItems.add(event.cartProduct);

      await cartBox.put('cart', cartItems.map((e) => e.toJson()).toList());

      emit(CartUpdated(
        message: message,
        cartItems: cartItems,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onIncreaseQuantity(
      IncreaseCartQuantity event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final message = await cartRepository.increaseQuantity(
        userId: event.userId,
        productRef: event.productRef,
        variantId: event.variantId,
        pincode: event.pincode,
      );
      List<CartProduct> cartItems =
          (cartBox.get('cart', defaultValue: []) as List)
              .map((e) => CartProduct.fromJson(Map<String, dynamic>.from(e)))
              .toList();

      int existingIndex = cartItems.indexWhere((item) =>
          item.productRef == event.productRef &&
          item.variant.id == event.variantId);

      if (existingIndex != -1) {
        cartItems[existingIndex] = cartItems[existingIndex]
            .copyWith(quantity: cartItems[existingIndex].quantity + 1);
        cartBox.put("cart", cartItems.map((e) => e.toJson()).toList());
      }

      emit(CartUpdated(
        message: message,
        cartItems: cartItems,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onDecreaseQuantity(
      DecreaseCartQuantity event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final message = await cartRepository.decreaseQuantity(
        userId: event.userId,
        productRef: event.productRef,
        variantId: event.variantId,
        pincode: event.pincode,
      );
      List<CartProduct> cartItems =
          (cartBox.get('cart', defaultValue: []) as List)
              .map((e) => CartProduct.fromJson(Map<String, dynamic>.from(e)))
              .toList();

      int existingIndex = cartItems.indexWhere((item) =>
          item.productRef == event.productRef &&
          item.variant.id == event.variantId);

      if (existingIndex != -1) {
        if (cartItems[existingIndex].quantity > 1) {
          cartItems[existingIndex] = cartItems[existingIndex]
              .copyWith(quantity: cartItems[existingIndex].quantity - 1);
        } else {
          cartItems.removeAt(existingIndex);
        }

        cartBox.put('cart', cartItems.map((e) => e.toJson()).toList());
      }

      emit(CartUpdated(
        message: message,
        cartItems: cartItems,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onSyncCartWithServer(
      SyncCartWithServer event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      // Implement sync logic here
    } catch (e) {
      emit(CartError(message: "Error syncing cart: $e"));
    }
  }
}
