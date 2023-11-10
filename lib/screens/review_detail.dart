import 'package:flutter/material.dart';

import '../models/review.dart';

class ReviewDetailScreen extends StatelessWidget {
  final Review review;

  const ReviewDetailScreen({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(review.reviewResult!),
      ),
    );
  }
}
