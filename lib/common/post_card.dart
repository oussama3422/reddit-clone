import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/theme/pallets.dart';



class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key,required this.post});

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
                                    onPressed: (){},
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
                            child:Image.network(post.link!)
                            )
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