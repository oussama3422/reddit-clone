import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/enums/enums.dart';
import '../../../core/provider/firebase_provider.dart';
import '../../../core/utils.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController,bool >((ref, ) {
  final userProfileRepository=ref.watch(userRepositoryProvider);
  final userStorageProvder=ref.watch(firebaseStorageProvder);

  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRpository: userStorageProvder,
    ref: ref,
    );
});

final getUserPostsProvider=StreamProvider.family((ref,String uid){
  return  ref.read(userProfileControllerProvider.notifier).getUserPost(uid);
});

class UserProfileController extends StateNotifier<bool>{
  final UserProfileRepository _userProfileRepository ;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRpository
    }):
    _userProfileRepository=userProfileRepository,
    _ref=ref,
    _storageRepository=storageRpository,
    super(false);




   void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name,
    })async{
      UserModel user=_ref.read(userProvder)!;

      if(profileFile!=null){
        final res=await _storageRepository.storeFile(
          path: 'users/profile',
          id: user.uid,
          file: profileFile
          );
          res.fold((l) => showSnackBar(context,l.message), (r) => user=user.copyWith(profilePic: r));
      }
      if(bannerFile!=null){
        final res=await _storageRepository.storeFile(
          path: 'users/banner',
          id: user.uid,
          file: bannerFile,
          );
          res.fold((l) => showSnackBar(context,l.message), (r) => user=user.copyWith(banner: r));
      }
      user=user.copyWith(name:name);
      final res=await _userProfileRepository.editProfile(user);
      state=false;

      res.fold(
        (error) => showSnackBar(context,error.message),
        (success) {
          _ref.read(userProvder.notifier).update((state) => user);
          Routemaster.of(context).pop();
         });
      
    
   }

//get posts
Stream<List<Post>> getUserPost(String uid){
  return _userProfileRepository.getUserPosts(uid);
}

//update User Karma
void updateUserKarma(UserKarma karma)async{
  
  UserModel user=_ref.read(userProvder)!;

  user=user.copyWith(karma:karma.karma+karma.karma);

  final res=await _userProfileRepository.updateUserkarma(user);

  res.fold((l) => null, (r) => _ref.read(userProvder.notifier).update((state) => user));

}
   
}