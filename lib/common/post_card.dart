import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/theme/pallets.dart';
import 'package:any_link_preview/any_link_preview.dart';


class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key,required this.post});


  void deletePost(WidgetRef ref,BuildContext context)async{
    ref.read(postsContollerProvider.notifier).deletePost(post,context);
  }

  void upVotePost(WidgetRef ref)async{
    ref.read(postsContollerProvider.notifier).upvote(post);
  }

  void downVotePost(WidgetRef ref)async{
    ref.read(postsContollerProvider.notifier).downvote(post);
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage=post.type=='image';
    final isTypeText=post.type=='text';
    final isTypeLinks=post.type=='link';
    final user=ref.watch(userProvder)!;
    final currentTheme=ref.watch(themeNotifierProvider);
    return Column(
      children: [
        Container(
          decoration:BoxDecoration(
            color:currentTheme.drawerTheme.backgroundColor,
          ) ,
          padding:const EdgeInsets.symmetric(vertical: 10),
          child:Row(
            children: [
              Expanded( 
                child: Column(
                  children:[
                    Container(
                      padding:const EdgeInsets.symmetric(vertical: 4,horizontal: 16).copyWith(right:0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      post.communityProfile,
                                    ),
                                    radius: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'r/${post.communtiyName}',
                                          style:const TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)
                                          ),
                                        Text(
                                          'r/${post.username}',
                                          style:const TextStyle(fontSize: 12)
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               if (post.id == user.uid)
                                  IconButton(
                                    onPressed: ()=>deletePost(ref,context),
                                    icon: Icon(
                                      Icons.delete,
                                      color:Pallete.redColor
                                      )
                                    ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize:19,
                                fontWeight:FontWeight.bold
                                ),
                                ),
                          ),
                          if (isTypeImage)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width:double.infinity,
                            child:Image.network(post.link!,fit:BoxFit.cover),
                            ),
                          if (isTypeLinks)
                          Container(
                            padding:const EdgeInsets.symmetric(horizontal: 18),
                            child: AnyLinkPreview(
                              displayDirection:UIDirection.uiDirectionHorizontal,
                              link:post.link!,
                            ),
                          ),
                            if(isTypeText)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal:15.0),
                              child: Text(
                                post.description!,
                                style:const TextStyle(color:Colors.grey)
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: ()=>upVotePost(ref),
                                      icon:  Icon(
                                        const IconData(0xe800,fontFamily: 'ZenDots',fontPackage: null),
                                        color:post.upvotes.contains(user.uid)? Pallete.redColor : null,
                                        )
                                        ),
                                        Text(
                                          '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' :post.upvotes.length - post.downvotes.length}',
                                          style: const TextStyle(fontSize: 17),
                                          ),
                                    IconButton(
                                        onPressed: ()=>downVotePost(ref),
                                      icon:  Icon(
                                        const IconData(0xe800,fontFamily: 'ZenDots',fontPackage: null),
                                        color:post.upvotes.contains(user.uid)? Pallete.redColor : null,
                                        )
                                        )
                                  ],
                                ),
                                Row(
                                  children: [
                                       IconButton(
                                        onPressed: (){},
                                      icon: const Icon(
                                        Icons.comment,
                                        )
                                        ),
                                        Text(
                                          '${post.commmentCount == 0 ? 'Comment' : post.commmentCount }',
                                          style: const TextStyle(fontSize: 17), 
                                          ),
                                      
                                  ],
                                ),
                                 IconButton(
                                        onPressed: (){},
                                      icon: const Icon(
                                        Icons.admin_panel_settings,
                                        )
                                        ),
                              ],
                            ),
                        ]
                        ),
                    )
                  ]
                ),
              ),
            ],
          )

        )
      ],
    );
  }
}