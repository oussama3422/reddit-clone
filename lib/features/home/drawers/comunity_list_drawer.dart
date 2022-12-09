import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/sing_in_button.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/loader.dart';


class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});
  
  void navigateToCreateCommunity(BuildContext context){

    Routemaster.of(context).push('/create-community');
  }
  void navigateToCommunity(BuildContext context,Community communtiy){
    Routemaster.of(context).push('/r/${communtiy.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.watch(userProvder)!;
    final isAuth=user.isAuthenticated;
    return Drawer(
      child:SafeArea(
        child: Column(
          children: [
            isAuth?
            ListTile(
              title:const Text('Create a Community'),
              leading:const Icon(Icons.add),
              onTap: ()=>navigateToCreateCommunity(context),
            ):const SingInButton(isFromLogin: false,),


            if(isAuth)
            ref.watch(userCommunityProvider).when(
              data: (communities)=>Expanded(
                child: ListView.builder(
                  itemCount:communities.length ,
                  itemBuilder:(context, index){
                    final community=communities[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar),
                      ),
                      onTap:()=> navigateToCommunity(context,community),
                      title:Text('r/${community.name}'),
              
                    );
                  }  ,
                  ),
              ),
              error:(error, stackTrace) =>ErrorText(error: error.toString()),
              loading:()=> const Loader(),
            ),
          ],
        ),
        )
    );
  }
}