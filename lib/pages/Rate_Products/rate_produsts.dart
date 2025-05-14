import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Add_Review_bloc/add_review_bloc.dart';
import 'package:kwik/bloc/Add_Review_bloc/add_review_event.dart';
import 'package:kwik/bloc/order_bloc/order_bloc.dart';
import 'package:kwik/bloc/order_bloc/order_event.dart';
import 'package:kwik/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class ProductRating extends StatefulWidget {
  final List<ProductModel> productlist;
  const ProductRating({super.key, required this.productlist});

  @override
  State<ProductRating> createState() => _ProductRatingState();
}

class _ProductRatingState extends State<ProductRating> {
  late String currentFirebaseUid;
  String? mongoUserId;
  late Map<String, ProductReviewModel> productReviews;
  late Map<String, TextEditingController> _commentControllers;
  late Map<String, FocusNode> _focusNodes;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    currentFirebaseUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    productReviews = {};
    _commentControllers = {};
    _focusNodes = {};

    _initializeReviewData();
  }

  Future<void> _initializeReviewData() async {
    mongoUserId = await getUsermogoid(userId: currentFirebaseUid);

    final uniqueProducts = getUniqueProducts(widget.productlist);

    for (var product in uniqueProducts) {
      final existingReview = _getExistingReview(product);

      productReviews[product.id] = ProductReviewModel(
        id: product.id,
        rating: existingReview.rating,
        comment: existingReview.comment,
      );

      _commentControllers[product.id] =
          TextEditingController(text: existingReview.comment);

      _focusNodes[product.id] = FocusNode();
    }

    setState(() {});
  }

  UserReviewData _getExistingReview(ProductModel product) {
    try {
      final review = product.reviews.firstWhere(
        (r) => r.userRef == mongoUserId,
      );
      return UserReviewData(
        rating: review.rating.toInt(),
        comment: review.comment,
      );
    } catch (e) {
      return UserReviewData(rating: 0, comment: '');
    }
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

  void _updateRating({
    required String productId,
    required int rating,
  }) {
    final currentReview = productReviews[productId];
    if (currentReview != null) {
      productReviews[productId] = ProductReviewModel(
        id: productId,
        rating: rating,
        comment: currentReview.comment,
      );
    }
    setState(() {});
  }

  void _updateComment({
    required String productId,
    required String comment,
  }) {
    final currentReview = productReviews[productId];
    if (currentReview != null) {
      productReviews[productId] = ProductReviewModel(
        id: productId,
        rating: currentReview.rating,
        comment: comment,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        appBar: AppBar(
          title: Text("Rating and Review", style: theme.textTheme.bodyLarge),
        ),
        body: SafeArea(
          child: mongoUserId == null
              ? Center(
                  child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: List.generate(
                      3,
                      (index) => _buildProductshimmer(),
                    ),
                  ),
                ))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: getUniqueProducts(widget.productlist)
                              .map((product) {
                            final review = productReviews[product.id]!;
                            return _buildProductReviewTile(
                                theme, product, review);
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              isloading = true;
                            });
                            context.read<ReviewBloc>().add(
                                  AddReviewEvent(
                                    review: productReviews.values
                                        .map((r) => r.toJson())
                                        .toList(),
                                  ),
                                );
                            await Future.delayed(const Duration(seconds: 2));
                            context
                                .read<OrderBloc>()
                                .add(FetchOrders(currentFirebaseUid));
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Thank you for your feedback! Your review has been submitted successfully.")));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: isloading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
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

  Widget _buildProductReviewTile(
    ThemeData theme,
    ProductModel product,
    ProductReviewModel review,
  ) {
    final controller = _commentControllers[product.id]!;
    final focusNode = _focusNodes[product.id]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              product.productImages.first,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text(product.productName, style: theme.textTheme.bodyLarge),
            subtitle: Row(
              children: List.generate(5, (i) {
                final starValue = i + 1;
                return Expanded(
                  child: IconButton(
                    onPressed: () {
                      _updateRating(
                        productId: product.id,
                        rating: starValue,
                      );
                    },
                    icon: Icon(
                      starValue <= review.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: starValue <= review.rating
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              maxLines: 4,
              controller: controller,
              focusNode: focusNode,
              onChanged: (value) {
                _updateComment(
                  productId: product.id,
                  comment: value,
                );
              },
              decoration: const InputDecoration(
                labelText: "Enter Comments",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: .5),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: .5),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: .5),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ProductReviewModel {
  final String id;
  final int rating;
  final String comment;

  ProductReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'rating': rating,
        'comment': comment,
      };
}

class UserReviewData {
  final int rating;
  final String comment;

  UserReviewData({required this.rating, required this.comment});
}

List<ProductModel> getUniqueProducts(List<ProductModel> products) {
  final seen = <String>{};
  final uniqueList = <ProductModel>[];

  for (var product in products) {
    if (seen.add(product.id)) {
      uniqueList.add(product);
    }
  }

  return uniqueList;
}

Future<String?> getUsermogoid({required String userId}) async {
  String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };
  final url = Uri.parse("$baseUrl/users/$userId");

  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> responsebody = jsonDecode(response.body);
      return responsebody['user']['_id'];
    } else {
      return null;
    }
  } catch (e) {
    throw Exception("Error fetching Mongo user ID: $e");
  }
}

Widget _buildProductshimmer() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.only(bottom: 10),
    child: Column(
      children: [
        ListTile(
          leading: const Shimmer(width: 80, height: 80),
          title: const Shimmer(width: 100, height: 16),
          subtitle: Row(
            children: List.generate(5, (i) {
              final starValue = i + 1;
              return Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.star,
                    color: Colors.grey,
                  ),
                ),
              );
            }),
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Shimmer(width: double.infinity, height: 156)),
        const SizedBox(height: 10),
      ],
    ),
  );
}
