import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/wishlist_model.dart';
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
    on<AddToCartFromWishlist>(_onAddtoCartfromWishlist);
    on<ApplyCoupon>(_onApplycoupon);
    on<AddToWishlistFromcart>(_onAddtowishlistfromcart);
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      final message = await cartRepository.addToCart(
        userId: event.userId,
        productRef: event.productRef,
        variant: event.variantId,
        pincode: event.pincode,
      );

      if (message) {
        if (state is CartUpdated) {
          final currentState = state as CartUpdated;
          List<CartProduct> updatedCartItems =
              List.from(currentState.cartItems);
          List<WishlistItem> wishlist = currentState.wishlist;
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
              wishlist: wishlist,
              cartItems: updatedCartItems,
              appliedcouponsmount: 0,
              couponcode: "null",
              charges: currentState.charges));
        }
        // else {
        //   final currentState = state as CartUpdated;
        //   // If cart is empty, initialize it
        //   List<CartProduct> newCart = [event.cartProduct];
        //   await cartBox.put('cart', newCart.map((e) => e.toJson()).toList());

        //   emit(CartUpdated(
        //       message: message,
        //       cartItems: newCart,
        //       wishlist: [],
        //       charges: const {
        //         "enable_cod": true,
        //         "delivery_charge": 2,
        //         "handling_charge": 1,
        //         "high_demand_charge": 3
        //       }));}
      } else {
        if (state is CartUpdated) {
          final currentState = state as CartUpdated;
          List<CartProduct> updatedCartItems =
              List.from(currentState.cartItems);
          List<WishlistItem> wishlist = currentState.wishlist;
          int existingIndex = updatedCartItems.indexWhere((item) =>
              item.productRef.id == event.productRef &&
              item.variant.id == event.variantId);

          // if (existingIndex == -1) {
          //   // Add new product only if it doesn't exist
          //   updatedCartItems.add(event.cartProduct);
          // }

          // Save to local storage
          await cartBox.put(
              'cart', updatedCartItems.map((e) => e.toJson()).toList());

          // Emit updated state
          emit(CartUpdated(
              message: message,
              wishlist: wishlist,
              cartItems: updatedCartItems,
              appliedcouponsmount: 0,
              couponcode: "null",
              charges: currentState.charges));
        }
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

      if (message) {
        if (state is CartUpdated) {
          final currentState = state as CartUpdated;
          List<WishlistItem> wishlist = currentState.wishlist;
          List<CartProduct> updatedCartItems =
              List.from(currentState.cartItems);

          int existingIndex = updatedCartItems.indexWhere((item) =>
              item.productRef.id == event.productRef &&
              item.variant.id == event.variantId);

          if (existingIndex != -1) {
            updatedCartItems[existingIndex] = updatedCartItems[existingIndex]
                .copyWith(
                    quantity: updatedCartItems[existingIndex].quantity + 1);
            cartBox.put(
                "cart", updatedCartItems.map((e) => e.toJson()).toList());
          }

          // Emit only CartUpdated without CartLoading
          emit(CartUpdated(
              message: message,
              wishlist: wishlist,
              cartItems: updatedCartItems,
              appliedcouponsmount: 0,
              couponcode: "null",
              charges: currentState.charges));
        } else {
          final currentState = state as CartUpdated;
          List<WishlistItem> wishlist = currentState.wishlist;
          List<CartProduct> updatedCartItems =
              List.from(currentState.cartItems);

          // Emit only CartUpdated without CartLoading
          emit(CartUpdated(
              message: false,
              wishlist: wishlist,
              cartItems: updatedCartItems,
              appliedcouponsmount: 0,
              couponcode: "null",
              charges: currentState.charges));
        }
      }
      // Get the current state without resetting it to CartLoading()
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
        List<WishlistItem> wishlist = currentState.wishlist;
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
            message: true,
            wishlist: wishlist,
            cartItems: updatedCartItems,
            appliedcouponsmount: 0,
            couponcode: "null",
            charges: currentState.charges));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onSyncCartWithServer(
      SyncCartWithServer event, Emitter<CartState> emit) async {
    try {
      double couponamount = 0.0;
      String couponcode = '';
      if (state is CartUpdated) {
        final currentstate = state as CartUpdated;
        couponcode = currentstate.couponcode;
        couponamount = currentstate.appliedcouponsmount;
      }
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
// Convert server cart items
      List<WishlistItem> serverwishlistItems = [];

      if (serverCartData["wishlist"] is List) {
        serverwishlistItems = (serverCartData["wishlist"] as List).map((e) {
          try {
            return WishlistItem.fromJson(e as Map<String, dynamic>);
          } catch (e) {
            throw Exception("Failed to parse wishlist : $e");
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
        emit(CartUpdated(
            message: true,
            cartItems: [],
            appliedcouponsmount: 0,
            couponcode: "null",
            wishlist: serverwishlistItems ?? [],
            charges: serverCartData["charges"]));
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
        message: true,
        cartItems: serverCartItems,
        wishlist: serverwishlistItems,
        appliedcouponsmount: couponamount,
        couponcode: couponcode,
        charges: serverCartData[
            "charges"], // Make sure to include charges in your state
      ));
    } catch (e) {
      emit(CartError(message: "Error syncing cart: ${e.toString()}"));
    }
  }

  Future<void> _onAddtoCartfromWishlist(
      AddToCartFromWishlist event, Emitter<CartState> emit) async {
    try {
      if (state is! CartUpdated) {
        emit(CartError(
            message: "Invalid state for adding to wishlist from cart"));
        return;
      }

      final currentState = state as CartUpdated;

      final success = await cartRepository.addToCartfromwishlist(
          pincode: event.pincode,
          userId: event.userId,
          wishlistitemid: event.wishlistID);

      // if (state is CartUpdated) {
      emit(CartLoading());
      if (success.isNotEmpty) {
        emit(currentState.copyWith(message: false));
        return;
      }
      final updatedCartProducts = success["cartproducts"];

      // 3. Get updated wishlist (or you could add the item locally)
      final updatedWishlist = success["wishlist"];
      // Alternative: Add locally without fetching
      // final wishlistItem = convertCartItemToWishlist(currentState.cartItems.firstWhere(...));
      // final updatedWishlist = [...currentState.wishlist, wishlistItem];

      // 4. Emit new state with ALL previous data preserved
      emit(currentState.copyWith(
        cartItems: updatedCartProducts,
        wishlist: updatedWishlist,
        // Keep all other state properties unchanged
        charges: currentState.charges,
        message: true,
        // Add any other properties your state has
      ));
      // emit((state as CartUpdated).copyWith(message: true));
      // } else {
      //   emit(CartError(
      //       message: "Initial state error during add to cart from wishlist"));
      // }
    } catch (error) {
      if (state is CartUpdated) {
        emit((state as CartUpdated)
            .copyWith(message: false)); // Indicate failure
      } else {
        emit(CartError(
            message: "Error adding product to cart from wishlist: $error"));
      }
    }
  }

  Future<void> _onAddtowishlistfromcart(
      AddToWishlistFromcart event, Emitter<CartState> emit) async {
    if (state is! CartUpdated) {
      emit(
          CartError(message: "Invalid state for adding to wishlist from cart"));
      return;
    }

    final currentState = state as CartUpdated;

    try {
      // 1. First add to wishlist
      final success = await cartRepository.addtowishlist(
        userId: event.userId,
        productRef: event.productref,
        varient: event.variationID,
      );
      emit(CartLoading());
      if (success.isNotEmpty) {
        emit(currentState.copyWith(message: false));
        return;
      }

      // 2. Update the cart by removing the item
      final updatedCartProducts = success["cartproducts"];

      // 3. Get updated wishlist (or you could add the item locally)
      final updatedWishlist = success["wishlist"];
      // Alternative: Add locally without fetching
      // final wishlistItem = convertCartItemToWishlist(currentState.cartItems.firstWhere(...));
      // final updatedWishlist = [...currentState.wishlist, wishlistItem];

      // 4. Emit new state with ALL previous data preserved
      emit(currentState.copyWith(
        cartItems: updatedCartProducts,
        wishlist: updatedWishlist,
        // Keep all other state properties unchanged
        charges: currentState.charges,
        message: true,
        // Add any other properties your state has
      ));
    } catch (error) {
      emit(currentState.copyWith(
        message: false,
      ));
    }
  }
  // Future<void> _onAddtowishlistfromcart(
  //     AddToWishlistFromcart event, Emitter<CartState> emit) async {
  //   try {
  //     await cartRepository.addtowishlist(
  //         userId: event.userId,
  //         productRef: event.productref,
  //         varient: event.variationID);

  //     if (state is CartUpdated) {
  //       final currentState = state as CartUpdated;
  //       List<CartProduct> updatedcartproducts = currentState.cartItems
  //           .where((element) =>
  //               element.productRef.id != event.productref ||
  //               element.variant.id != event.variationID)
  //           .toList();
  //       // List<WishlistItem> updatedwishlistitem=currentState.wishlist.add(WishlistItem(productRef: currentState.cartItems.where((element) => element.productRef.id==event.productref&&element.variant.id==event.variationID).first.productRef, variantId:event.variationID , id: id))
  //       emit(CartUpdated(
  //           wishlist: currentState.wishlist,
  //           message: true,
  //           cartItems: updatedcartproducts,
  //           charges: currentState.charges));
  //     }
  //   } catch (error) {
  //     print("Error adfding prodct to wishlist");
  //   }
  // }

  Future<void> _onApplycoupon(
      ApplyCoupon event, Emitter<CartState> emit) async {
    try {
      if (state is CartUpdated) {
        final currentState = state as CartUpdated;
        List<CartProduct> updatedCartItems = List.from(currentState.cartItems);
        List<WishlistItem> wishlist = currentState.wishlist;

        // Emit updated state
        emit(CartUpdated(
            message: true,
            wishlist: wishlist,
            cartItems: updatedCartItems,
            appliedcouponsmount: event.amount,
            couponcode: event.couponcode,
            charges: currentState.charges));
      }
    } catch (error) {
      print(error);
    }
  }
}
