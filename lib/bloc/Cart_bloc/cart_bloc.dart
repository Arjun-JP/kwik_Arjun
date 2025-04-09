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
    try {
      final message = await cartRepository.addToCart(
        userId: event.userId,
        productRef: event.productRef,
        variant: event.variantId,
        pincode: event.pincode,
      );

      if (state is CartUpdated) {
        final currentState = state as CartUpdated;
        List<CartProduct> updatedCartItems = List.from(currentState.cartItems);

        int existingIndex = updatedCartItems.indexWhere((item) =>
            item.productRef.id == event.productRef &&
            item.variant.id == event.variantId);

        if (existingIndex == -1) {
          // Add new product only if it doesn't exist
          updatedCartItems.add(event.cartProduct);
        }

        // Save to local storage
        await cartBox.put(
            'cart', updatedCartItems.map((e) => e.toJson()).toList());

        // Emit updated state
        emit(CartUpdated(
            message: message,
            cartItems: updatedCartItems,
            charges: currentState.charges));
      } else {
        final currentState = state as CartUpdated;
        // If cart is empty, initialize it
        List<CartProduct> newCart = [event.cartProduct];
        await cartBox.put('cart', newCart.map((e) => e.toJson()).toList());

        emit(CartUpdated(
            message: message,
            cartItems: newCart,
            charges: currentState.charges));
      }
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
            charges: currentState.charges));
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
            charges: currentState.charges));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onSyncCartWithServer(
      SyncCartWithServer event, Emitter<CartState> emit) async {
    try {
      Map<String, dynamic> serverCartData =
          await cartRepository.getUserCart(userId: event.userId);

      // Convert server cart items
      List<CartProduct> serverCartItems = [];
      if (serverCartData["cartproducts"] is List) {
        serverCartItems = (serverCartData["cartproducts"] as List).map((e) {
          try {
            return CartProduct.fromJson(e as Map<String, dynamic>);
          } catch (e) {
            throw Exception("Failed to parse cart product: $e");
          }
        }).toList();
      }

      // Fetch local cart data
      List<CartProduct> localCartItems = [];
      final localCartData = cartBox.get('cart', defaultValue: []);
      if (localCartData is List) {
        localCartItems = localCartData.map((e) {
          try {
            return CartProduct.fromJson(Map<String, dynamic>.from(e));
          } catch (e) {
            throw Exception("Failed to parse local cart product: $e");
          }
        }).toList();
      }

      // If server cart is empty, clear local cart and return empty list
      if (serverCartItems.isEmpty) {
        await cartBox.put('cart', []);
        emit(CartUpdated(message: "Cart is empty", cartItems: [], charges: {}));
        return;
      }

      // Check if local and server carts are different
      bool isDifferent = serverCartItems.length != localCartItems.length ||
          !serverCartItems.every((serverItem) => localCartItems.any(
              (localItem) =>
                  localItem.productRef.id == serverItem.productRef.id &&
                  localItem.variant.id == serverItem.variant.id &&
                  localItem.quantity == serverItem.quantity));

      // If different, update local storage
      if (isDifferent) {
        await cartBox.put(
            'cart', serverCartItems.map((e) => e.toJson()).toList());
      }

      // Always emit CartUpdated, even if local and server carts are the same
      emit(CartUpdated(
        message: "Cart synced successfully",
        cartItems: serverCartItems,
        charges: serverCartData[
            "charges"], // Make sure to include charges in your state
      ));
    } catch (e) {
      emit(CartError(message: "Error syncing cart: ${e.toString()}"));
    }
  }
}
