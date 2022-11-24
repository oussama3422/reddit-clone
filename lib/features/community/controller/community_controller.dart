

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repositry/auth_repository.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

final communtyControllerProvider = StateNotifierProvider<CommunityController,bool>((ref) {
  final communityRepository=ref.watch(communtiyRositoryProvider);
  return CommunityController(communityRepository: communityRepository, ref: ref);
});

class CommunityController extends StateNotifier<bool>{

  final CommunityRepository _communtiyRepository;
  final Ref _ref;

  CommunityController(
    {
      required CommunityRepository communityRepository,
      required Ref ref,
    }
  ):_communtiyRepository=communityRepository,_ref=ref,super(false);



  void createCommuntiy(String name,BuildContext context)async{
    state=true;
    final uid=_ref.read(userProvder)?.uid ?? '';
    Community community=Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      membres: [],
      mods: []
     );
     final res = await _communtiyRepository.createCommunity(community);
     state=false;
     res.fold((l) => showSnackBar(context, l.message), (r){
      showSnackBar(context, 'Community Created Successfully');
      Routemaster.of(context).pop();
     });
  }
}