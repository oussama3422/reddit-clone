
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/post_card.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key,required this.name});


  void navigateToModTools(BuildContext context){
    Routemaster.of(context).push('/mod-tools/$name');
  }
  void joinCommunity(WidgetRef ref,Community communtiy,BuildContext context){
    ref.read(communtyControllerProvider.notifier).joinCommuntiy(communtiy, context);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.watch(userProvder)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data:(community)=>NestedScrollView(
          headerSliverBuilder: (context,nextBoxScroll){
                    return [
                      SliverAppBar(
                        expandedHeight: 150,
                        floating: true,
                        snap:true,
                        flexibleSpace: Stack
                        (
                          children:[
                                Positioned.fill(child: Image.network(community.banner,fit:BoxFit.fill))
                        ],
                      ),
                      ),
                   SliverPadding(
                    padding:const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius:35 ,
                              ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                  'r/${community.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                community.mods.contains(user.uid)?
                                OutlinedButton(
                                   style:ElevatedButton.styleFrom(
                                    shape:RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding:const EdgeInsets.symmetric(horizontal: 26),
                                   ),
                                   onPressed: ()=>navigateToModTools(context),
                                   child:const  Text('Mod Tools '),
                                )
                                :
                                OutlinedButton(
                                   onPressed: ()=>joinCommunity(ref, community, context),
                                   style:ElevatedButton.styleFrom(
                                    shape:RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding:const EdgeInsets.symmetric(horizontal: 26),
                                   ),
                                   child:Text(community.mods.contains(user.uid)?"Join":"Joined"),
                                )
                            ],
                            ),
                            Padding(
                              padding:const EdgeInsets.only(top:10),
                              child:Text('${community.members.length} memebers')
                              )
                        ]
                    ),
                    ),
                    
                    )
                ];
          },
          body:ref.watch(getCommunityPostsProvider(name)).when(
            data:(data){
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index){
                  final post=data[index];
                  return PostCard(post: post);
                }
                
                );
            },
            error:(error, stackTrace) =>ErrorText(error: error.toString()),
              
            loading:()=>const Loader(),
          ) ,
          ),
        error:(error,stackTrace)=>ErrorText(error: error.toString()),
        loading:()=>const Loader(),
        )
        );
  }
}