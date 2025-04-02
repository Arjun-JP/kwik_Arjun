import 'dart:convert';

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
    try {
      final message = await cartRepository.increaseQuantity(
        userId: event.userId,
        productRef: event.productRef,
        variantId: event.variantId,
        pincode: event.pincode,
      );

      // Get the current state without resetting it to CartLoading()
      if (state is CartUpdated) {
        final currentState = state as CartUpdated;
        List<CartProduct> updatedCartItems = List.from(currentState.cartItems);

        int existingIndex = updatedCartItems.indexWhere((item) =>
            item.productRef.id == event.productRef &&
            item.variant.id == event.variantId);

        if (existingIndex != -1) {
          updatedCartItems[existingIndex] = updatedCartItems[existingIndex]
              .copyWith(quantity: updatedCartItems[existingIndex].quantity + 1);
          cartBox.put("cart", updatedCartItems.map((e) => e.toJson()).toList());
        }

        // Emit only CartUpdated without CartLoading
        emit(CartUpdated(
          message: message,
          cartItems: updatedCartItems,
        ));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onDecreaseQuantity(
      DecreaseCartQuantity event, Emitter<CartState> emit) async {
    try {
      final message = await cartRepository.decreaseQuantity(
        userId: event.userId,
        productRef: event.productRef,
        variantId: event.variantId,
        pincode: event.pincode,
      );

      if (state is CartUpdated) {
        final currentState = state as CartUpdated;
        List<CartProduct> updatedCartItems = List.from(currentState.cartItems);

        int existingIndex = updatedCartItems.indexWhere((item) =>
            item.productRef.id == event.productRef &&
            item.variant.id == event.variantId);

        if (existingIndex != -1) {
          if (updatedCartItems[existingIndex].quantity > 1) {
            updatedCartItems[existingIndex] = updatedCartItems[existingIndex]
                .copyWith(
                    quantity: updatedCartItems[existingIndex].quantity - 1);
          } else {
            updatedCartItems.removeAt(existingIndex);
          }

          cartBox.put("cart", updatedCartItems.map((e) => e.toJson()).toList());
        }

        emit(CartUpdated(
          message: message,
          cartItems: updatedCartItems,
        ));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onSyncCartWithServer(
      SyncCartWithServer event, Emitter<CartState> emit) async {
    emit(CartLoading());

    try {
      List<Map<String, dynamic>> serverCartData =
          await cartRepository.getUserCart(userId: event.userId);

      List<CartProduct> serverCartItems = [];
      print(serverCartData);
      try {
        serverCartItems =
            serverCartData.map((e) => CartProduct.fromJson(e)).toList();
      } catch (e) {
        print(e);
      }

      // Fetch local cart data
      List<CartProduct> localCartItems =
          (cartBox.get('cart', defaultValue: []) as List)
              .map((e) => CartProduct.fromJson(Map<String, dynamic>.from(e)))
              .toList();

      // If server cart is empty, clear local cart and return empty list
      if (serverCartItems.isEmpty) {
        await cartBox.put('cart', []);
        emit(CartUpdated(message: "Cart is empty", cartItems: []));
        return;
      }

      // Check if local and server carts are different
      bool isDifferent = serverCartItems.length != localCartItems.length ||
          !serverCartItems.every((serverItem) => localCartItems.any(
              (localItem) =>
                  localItem.productRef.id == serverItem.productRef.id &&
                  localItem.variant.id == serverItem.variant.id &&
                  localItem.quantity == serverItem.quantity));
      print("object");
      // If different, update local storage
      if (isDifferent) {
        print("object  in ");
        await cartBox.put(
            'cart', serverCartItems.map((e) => e.toJson()).toList());
      }
      print("object  in ${serverCartItems.length}");
      // Always emit CartUpdated, even if local and server carts are the same
      emit(CartUpdated(
        message: "Cart synced successfully",
        cartItems: serverCartItems,
      ));
    } catch (e) {
      emit(CartError(message: "Error syncing cart: $e"));
    }
  }
}
