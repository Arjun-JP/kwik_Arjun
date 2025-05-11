import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Add_Review_bloc/add_review_bloc.dart';
import 'package:kwik/bloc/Add_Review_bloc/add_review_event.dart';
import 'package:kwik/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Assuming you use Firebase Auth

class ProductRating extends StatefulWidget {
  final List<ProductModel> productlist;
  const ProductRating({super.key, required this.productlist});

  @override
  State<ProductRating> createState() => _ProductRatingState();
}

class _ProductRatingState extends State<ProductRating> {
  late String currentUserUid;

  List<ProductReviewModel> productReviews = [];
  late Map<String, TextEditingController> _commentControllers;
  late Map<String, FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();

    // Get current user UID (replace with your auth method if needed)
    currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Initialize controllers and focus nodes
    _commentControllers = {
      for (var product in widget.productlist)
        product.id: TextEditingController()
    };

    _focusNodes = {
      for (var product in widget.productlist) product.id: FocusNode()
    };
  }

  @override
  void dispose() {
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void addOrUpdateProductReview({
    required String productId,
    required int rating,
    required String comment,
  }) {
    final existingIndex =
        productReviews.indexWhere((review) => review.id == productId);

    if (existingIndex >= 0) {
      productReviews[existingIndex] = ProductReviewModel(
        id: productId,
        rating: rating,
        comment: comment,
      );
    } else {
      productReviews.add(ProductReviewModel(
        id: productId,
        rating: rating,
        comment: comment,
      ));
    }

    setState(() {});
  }

  ProductReviewModel? getReviewForProduct(String productId) {
    return productReviews.firstWhere(
      (review) => review.id == productId,
      orElse: () => ProductReviewModel(id: productId, rating: 0, comment: ''),
    );
  }

  /// NEW: Get user's existing review for a product (from product.reviews)
  UserReviewData? getUserReviewForProduct(ProductModel product) {
    if (product.reviews == null || product.reviews!.isEmpty) return null;

    final userReview = product.reviews!.firstWhere(
      (r) => r.userRef == currentUserUid,
    );

    if (userReview == null) return null;

    return UserReviewData(
      rating: int.parse(userReview.rating.toStringAsFixed(0)),
      comment: userReview.comment,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        appBar: AppBar(
          title: Text(
            "Rating and Review",
            style: theme.textTheme.bodyLarge,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        getUniqueProducts(widget.productlist).length,
                        (index) => ratingtile(
                            theme: theme,
                            product:
                                getUniqueProducts(widget.productlist)[index]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();

                      context.read<ReviewBloc>().add(AddReviewEvent(
                          review: productReviews
                              .map((review) => review.toJson())
                              .toList()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Submit Review',
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ratingtile({required ThemeData theme, required ProductModel product}) {
    final UserReviewData? userReview = getUserReviewForProduct(product);
    final int initialRating = userReview?.rating ?? 5;
    final String initialComment = userReview?.comment ?? "";

    final ProductReviewModel? localReview = getReviewForProduct(product.id);
    final int currentRating = localReview?.rating ?? initialRating;
    final String currentComment = localReview?.comment ?? initialComment;

    final TextEditingController controller = _commentControllers[product.id]!;
    final FocusNode focusNode = _focusNodes[product.id]!;

    // Set comment controller value only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.text != currentComment) {
        controller.text = currentComment;
      }
    });

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              product.productImages.first,
              width: 80,
              height: 80,
            ),
            title: Text(
              product.productName,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        addOrUpdateProductReview(
                          productId: product.id,
                          rating: i,
                          comment: controller.text,
                        );
                      },
                      icon: Icon(
                        i <= currentRating ? Icons.star : Icons.star_border,
                        color: i <= currentRating ? Colors.yellow : Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
            child: TextField(
              maxLines: 4,
              controller: controller,
              focusNode: focusNode,
              onChanged: (value) {
                addOrUpdateProductReview(
                  productId: product.id,
                  rating: currentRating,
                  comment: value,
                );
              },
              style: theme.textTheme.bodyMedium,
              decoration: const InputDecoration(
                labelText: "Enter Comments",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(
                    color: Color(0xffA19DA3),
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(
                    color: Color(0xffA19DA3),
                    width: 0.5,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(
                    color: Color(0xffA19DA3),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

// Local model to store edited reviews before submitting
class ProductReviewModel {
  final String id;
  final int rating;
  final String comment;

  ProductReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
    };
  }
}

// Helper to extract only rating & comment from user's existing review
class UserReviewData {
  final int rating;
  final String comment;

  UserReviewData({required this.rating, required this.comment});
}

List<ProductModel> getUniqueProducts(List<ProductModel> products) {
  final seen = Set<String>();
  final uniqueList = <ProductModel>[];

  for (var product in products) {
    if (seen.add(product.id)) {
      uniqueList.add(product);
    }
  }

  return uniqueList;
}
