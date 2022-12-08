import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';


class AddModsScreen extends ConsumerStatefulWidget {

  final String name;
  const AddModsScreen({super.key,required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {


 Set<String> uids={};
  int cnt=0;
 void addUids(String uid){
    setState(() {
      uids.add(uid);
    });
 }
 void removeUids(String uid){
    setState(() {
      uids.remove(uid);
    });
 }

 void saveMods(){
  ref.read(communtyControllerProvider.notifier).addMods(widget.name, uids.toList(), context);
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed:saveMods,
            icon:const Icon(Icons.done),
            )
        ],
      ),
      body:ref.watch(getCommunityByNameProvider(widget.name)).when(
      data: (community)=>ListView.builder(
        itemCount: community.members.length,
        itemBuilder: (context,index){
          final member=community.members[index];
          return ref.watch(getUserDataProvider(member)).when(
             data: (user){
              if (community.mods.contains(member) && cnt==0){
                uids.add(member);
              }
             cnt++;
            return CheckboxListTile(
                value: uids.contains(user.uid),
                onChanged: (newVal){
                    if (newVal!){
                       addUids(user.uid);
                    }else
                    {
                      removeUids(user.uid);
                    }
                },
                title:Text(user.name),
            );
            },
             error: (error,stackTrace)=>ErrorText(error: error.toString()),
             loading: ()=>const Loader(),
          );
        }
        ),
      error: (error,stackTrace)=>ErrorText(error: error.toString()),
      loading: ()=>const Loader(),
      ) ,
    );
  }
}