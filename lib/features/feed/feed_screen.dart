import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/common/post_card.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunityProvider).when(
      data: (communties)=>ref.watch(userPostsProvider(communties)).when(
           data: (data){
            return ListView.builder(
              itemCount: data.length,
              itemBuilder:(context, index){
                final post=data[index];
                return PostCard(post: post);
              } ,
              );
           },
           error:(error, stackTrace) {
            print(error);
            return ErrorText(error: error.toString());
            },
           loading: ()=>const Loader(),
           ),
      error: (error, stackTrace) =>ErrorText(error: error.toString()) ,
      loading: ()=>const Loader(),
      );
  }
}