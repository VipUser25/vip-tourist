import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/models/review.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/presentation/widgets/commentay_item.dart';

class CommentaryBuildeTwo extends StatefulWidget {
  const CommentaryBuildeTwo({Key? key}) : super(key: key);

  @override
  _CommentaryBuildeTwoState createState() => _CommentaryBuildeTwoState();
}

class _CommentaryBuildeTwoState extends State<CommentaryBuildeTwo> {
  @override
  Widget build(BuildContext context) {
    final obj = Provider.of<DetailTourProvider>(context);
    List<Review> data = obj.tranlations;
    print("ПОКАЗЫВАЕТ ПЕРЕВОД");
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, i) => CommentaryItem(
        date: data[i].commentDate,
        messageBody: data[i].messageBody,
        rating: data[i].userRating,
        userName: data[i].username,
        userPhoto: data[i].userPhoto,
      ),
      itemCount: data.length,
      shrinkWrap: true,
    );
  }
}
