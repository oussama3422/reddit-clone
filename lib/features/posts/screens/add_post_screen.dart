import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});
 
  @override
  Widget build(BuildContext context,WidgetRef ref) {
      double cardHeightWidget=120;
      double iconSize=60;
    return Wrap(
      children: [
        SizedBox(
          height:cardHeightWidget,
          width:cardHeightWidget,
          child: Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          elevation: 16,
          child:Center(
            child: Icon(
              Icons.image_outlined,
              size:iconSize
              )
              )
          ),
        )
      ],
    );
  }
}