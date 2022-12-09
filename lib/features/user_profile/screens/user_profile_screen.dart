import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/common/post_card.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/error_text.dart';
import '../../../common/loader.dart';
import '../../auth/controller/auth_controller.dart';

class UserProfuleScreen extends ConsumerWidget {

  final String uid;
  const UserProfuleScreen({super.key,required this.uid});
  void navigateToEditUser(BuildContext context){
    Routemaster.of(context).push('/edit-profile/$uid');
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
        data:(user)=>NestedScrollView(
          headerSliverBuilder: (context,nextBoxScroll){
                    return [
                      SliverAppBar(
                        expandedHeight: 250,
                        floating: true,
                        snap:true,
                        flexibleSpace: Stack
                        (
                          children:[
                             Positioned.fill(
                                  child: Image.network(user.banner,fit:BoxFit.fill)
                                  ),
                             Container(
                              alignment: Alignment.bottomLeft,
                              padding:const EdgeInsets.all(20).copyWith(bottom:70),
                              child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius:35 ,
                              ),
                               ),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  padding:const EdgeInsets.all(20),
                                  child: OutlinedButton(
                                     onPressed:()=>navigateToEditUser(context),
                                     style:ElevatedButton.styleFrom(
                                      shape:RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding:const EdgeInsets.symmetric(horizontal: 26),
                                     ),
                                     child:const Text("Edit Profile"),
                                  ),
                                )
                        ],
                      ),
                      ),
                   SliverPadding(
                    padding:const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                  'r/${user.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                               
                            ],
                            ),
                            Padding(
                              padding:const EdgeInsets.only(top:10),
                              child:Text('${user.karma} karma')
                              ),
                              const SizedBox(height:10),
                              const Divider(thickness: 2,color:Colors.purple),
                        ]
                    ),
                    ),
                    
                    ),
                  
                ];
          },
          body:ref.watch(getUserPostsProvider(uid)).when(
            data:(data){
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index){
                  final post=data[index];
                  return PostCard(post: post);
                }
                
                );
            },
            error:(error, stackTrace) {
                print(error);
               return ErrorText(error: error.toString());
               },
            loading:()=>const Loader(),
          )
          ),
        error:(error,stackTrace)=>ErrorText(error: error.toString()),
        loading:()=>const Loader(),
        )
        );
  }
}