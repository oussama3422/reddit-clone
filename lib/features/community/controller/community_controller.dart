

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

final userCommunityProvider=StreamProvider((ref){
final communityController=ref.watch(communtyControllerProvider.notifier);
return communityController.getUserCommunities();

});

final communtyControllerProvider = StateNotifierProvider<CommunityController,bool>((ref) {
  final communityRepository=ref.watch(communtiyRepositoryProvider);
  return CommunityController(communityRepository: communityRepository, ref: ref);
});


final getCommunityByNameProvider=StreamProvider.family((ref,String name) {
  return ref.watch(communtyControllerProvider.notifier).getCommunityyName(name);
});
class CommunityController extends StateNotifier<bool>{

  final CommunityRepository _communtiyRepository;
  final Ref _ref;

  CommunityController(
    {
      required CommunityRepository communityRepository,
      required Ref ref,
    }
  ):
  _communtiyRepository=communityRepository,
  _ref=ref,
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
}