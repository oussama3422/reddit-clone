

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/common/post_card.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/features/posts/widgets/comment_card.dart';

import '../../../models/post.dart';
import '../../auth/controller/auth_controller.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key,required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController=TextEditingController();


  @override
  void dispose() { 
    commentController.dispose();
    super.dispose();
  }


void addComment(Post post){
  ref.read(postsContollerProvider.notifier).addComment(
    context: context,
    text: commentController.text.trim(),
    post: post,
   );
   setState(() {
     commentController.text='';
   });
}

  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvder)!;
    final isAuth=user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body:ref.watch(getPostByIdProvider(widget.postId)).when(
        data: (data){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            PostCard(post: data),
            if(isAuth)
            TextField(
              onSubmitted: (val)=>addComment(data),
              controller:commentController,
              decoration:const InputDecoration(
                hintText: 'what are your thoughtd?',
                filled:true,
                border:InputBorder.none,
              )
            ),
            ref.watch(getCommentPostsProvider(widget.postId)).when(
              data: (data){
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder:(context,index){
                      final comment=data[index];
                      return CommnetCard(comment: comment);
                    } ,
                    ),
                );
                },
              error: (error,stackTrace)=> ErrorText(error: error.toString()),
              
              loading: ()=>const Loader(),
              ),
            ],
          );
        },
        error: (error, stackTrace) =>ErrorText(error: error.toString()) ,
        loading: ()=>const Loader())
    );
  }
}