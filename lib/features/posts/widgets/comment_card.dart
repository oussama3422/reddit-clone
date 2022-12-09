import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment.dart';

class CommnetCard extends ConsumerWidget {
  final Comment comment;
  const CommnetCard({super.key,required this.comment});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding:const EdgeInsets.symmetric(vertical:10 ,horizontal:4 ),
      child:Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.profilePic),
                radius:18,
              ),
              Expanded(
                child:Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.username,
                        style:const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        Text(
                          comment.text,
                          style:const TextStyle(fontFamily:'ZenDots'),
                          )
                    ],
                  ),
                ) ,
                )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.reply),
                ),
                const Text('Reply',style:TextStyle(fontFamily: 'ZenDots',fontSize: 14,))
            ],
          )
        ],
      )
    );
  }
}