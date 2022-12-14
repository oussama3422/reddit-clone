

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/core/provider/failure.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/provider/storage_repository_provider.dart';
import '../../../models/post.dart';
import '../../auth/controller/auth_controller.dart';

final userCommunityProvider=StreamProvider((ref){
final communityController=ref.watch(communtyControllerProvider.notifier);
return communityController.getUserCommunities();

});
final searchCommunityProvider=StreamProvider.family((ref,String query){
return ref.watch(communtyControllerProvider.notifier).searchCommunity(query);

});

final communtyControllerProvider = StateNotifierProvider<CommunityController,bool>((ref) {
  final communityRepository=ref.watch(communtiyRepositoryProvider);
  final storageRepository=ref.watch(firebaseStorageProvder);
  return CommunityController(communityRepository: communityRepository, ref: ref,storageRepository:storageRepository);
});


final getCommunityByNameProvider=StreamProvider.family((ref,String name) {
  return ref.watch(communtyControllerProvider.notifier).getCommunityyName(name);
});

/// get communtiy posts Provider
final getCommunityPostsProvider = StreamProvider.family((ref,String name){
  return ref.read(communtyControllerProvider.notifier).getCommunityPosts(name);
});
/// 

class CommunityController extends StateNotifier<bool>{

  final CommunityRepository _communtiyRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController(
    {
      required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository,
    }
  ):
  _communtiyRepository=communityRepository,
  _ref=ref,
  _storageRepository=storageRepository,
  super(false);



  void createCommuntiy(String name,BuildContext context)async{
    state=true;
    final uid=_ref.read(userProvder)?.uid ?? '';
    Community community=Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid]
     );
     final res = await _communtiyRepository.createCommunity(community);
     state=false;
     res.fold((l) => showSnackBar(context, l.message), (r){
      showSnackBar(context, 'Community Created Successfully');
      Routemaster.of(context).pop();
     });
  }

  Stream<List<Community>> getUserCommunities(){
  final uid=_ref.read(userProvder)!.uid;
  return _communtiyRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityyName(String name){
  return _communtiyRepository.getCommunityyName(name);
  
  }

  void editCommunity(
    {required File? profileFile,
    required File? bannerFile,
    required Community community,
    required BuildContext context
    })async{
      state=true;
      if(profileFile!=null){
        // communties/profile/memes
       final res=await _storageRepository.storeFile(
          path: 'communties/profile',
          id: community.name,
          file: profileFile
          );
        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => community=community.copyWith(avatar: r)
          );
      }
      if(bannerFile!=null){
        // communties/banner/memes
       final res=await _storageRepository.storeFile(
          path: 'communties/banner',
          id: community.name,
          file: bannerFile,
          );
        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => community=community.copyWith(banner: r)
          );
      }
      final res=await _communtiyRepository.editCommunity(community);
      state=false;
      res.fold((l) => showSnackBar(context, l.message), (r) =>Routemaster.of(context).pop());
      
   }

   // this function help us to join to community and leave from it
  void joinCommuntiy(Community community,BuildContext context)async{
    final user=_ref.read(userProvder)!;
    Either<Failure,void> res;
    if(community.members.contains(user.uid)){
      res=await _communtiyRepository.leaveCommunity(community.name,user.uid);
    }else{
      res=await _communtiyRepository.joinCommunity(community.name,user.uid);
    }
    res.fold((l)=>showSnackBar(context, l.message), (r){
      if (community.members.contains(user.uid)){
        showSnackBar(context, 'Community left successfully!');
      }else{
        showSnackBar(context, 'Community joined successfully!');
      }
     } );
  }

   Stream<List<Community>> searchCommunity(String query){
    return _communtiyRepository.searchCommunity(query);
   }

  void addMods(String communityName,List<String> uids,BuildContext context)async{
  
  final res=await _communtiyRepository.addMods(communityName, uids);

  res.fold(
    (l) =>showSnackBar(context, l.message) ,
    (r) => Routemaster.of(context).pop(),
    );
  }

  /// get [communtiy Posts] with commuties's name
  Stream<List<Post>> getCommunityPosts(String name){
    return _communtiyRepository.getCommunityPosts(name);
  }
}