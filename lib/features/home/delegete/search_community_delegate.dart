

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/error_text.dart';
import '../../../models/community.dart';

class SearchCommunityDelgate extends SearchDelegate{

  final WidgetRef ref;
  SearchCommunityDelgate(this.ref);
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query='';
        },
        icon: const Icon(Icons.close)
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
  return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
      data: (communties)=>ListView.builder(
        itemBuilder: (BuildContext context,int index){
          final community=communties[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(community.avatar),
            ),
            title: Text('r/${community.name}'),
            onTap:()=>navigateToCommunity(context, community.name),
          );
        },
        itemCount: communties.length,
        ),
      error:(error,stackTrace)=>ErrorText(error: error.toString()),
      loading:()=>const Loader(),
      );
  }

  void navigateToCommunity(BuildContext context,String  communtiyName){
    Routemaster.of(context).push('/r/$communtiyName');
  }

}