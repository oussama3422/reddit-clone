import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/posts/repository/post_repository.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../models/community.dart';
import '../../../models/post.dart';
import '../../auth/controller/auth_controller.dart';

final postsContollerProvider = StateNotifierProvider<PostController,bool>((ref) {
  final postRepository=ref.watch(postRepositoryProvider);
  final storageRepositoy=ref.watch(firebaseStorageProvder);

  return PostController(
    postsRepositry: postRepository,
    ref: ref,
    storageRepository: storageRepositoy
    );
});

final userPostsProvider = StreamProvider.family((ref,List<Community> communtiy){
  final postsController=ref.watch(postsContollerProvider.notifier);
  return postsController.fetchUserPosts(communtiy);
});

class PostController extends StateNotifier<bool>{
  final PostsRepositry _postsRepositry;
  final Ref _ref;
  final StorageRepository _storageRepository;
 PostController({
  required PostsRepositry postsRepositry,
  required Ref ref,
  required StorageRepository storageRepository
  }):
  _postsRepositry=postsRepositry,
  _ref=ref,
  _storageRepository=storageRepository,
  super(false);

  void shareTextPost(
    {
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
    })async{
      state=true;
      String postId=const Uuid().v1();
      final user=_ref.read(userProvder)!;
      final Post post= Post(
          id:postId ,
          title: title,
          communtiyName:selectedCommunity.name ,
          communityProfile:selectedCommunity.avatar ,
          upvotes:[],
          downvotes:[] ,
          commmentCount:0 ,
          username:user.name,
          uid:user.uid ,
          type: 'text',
          createAt: DateTime.now(),
          awards:[] ,
          description: description,
          );
    final res= await _postsRepositry.addPost(post);
    state=false;
    res.fold(
      (failled)=>showSnackBar(context, failled.message),
      (success){
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      },
      );
  }
  void shareLinkPost(
    {
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String links,
    })async{
      state=true;
      String postId=const Uuid().v1();
      final user=_ref.read(userProvder)!;
      final Post post= Post(
          id:postId ,
          title: title,
          communtiyName:selectedCommunity.name ,
          communityProfile:selectedCommunity.avatar ,
          upvotes:[],
          downvotes:[] ,
          commmentCount:0 ,
          username:user.name,
          uid:user.uid ,
          type: 'link',
          createAt: DateTime.now(),
          awards:[] ,
          link: links,
          );
    final res= await _postsRepositry.addPost(post);
    state=false;
    res.fold(
      (failled)=>showSnackBar(context, failled.message),
      (success){
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      },
      );
  }
  void shareImagePost(
    {
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? image,
    })async{
      state=true;
      String postId=const Uuid().v1();
      final user=_ref.read(userProvder)!;
      final imgRes=await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}',
        id: postId,
        file: image,
        );

        imgRes.fold(
          (error) =>showSnackBar(context, error.message) ,
          (success)async{
             final Post post= Post(
             id:postId ,
             title: title,
             communtiyName:selectedCommunity.name ,
             communityProfile:selectedCommunity.avatar ,
             upvotes:[],
             downvotes:[] ,
             commmentCount:0 ,
             username:user.name,
             uid:user.uid ,
             type: 'image',
             createAt: DateTime.now(),
             awards:[] ,
             link: success,
          );
            final res= await _postsRepositry.addPost(post);
          state=false;
            res.fold(
            (failled)=>showSnackBar(context, failled.message),
            (success){
            showSnackBar(context, 'Posted successfully!');
            Routemaster.of(context).pop();
      },
      );
          }
          );
    
  
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communites){
    if(communites.isNotEmpty){
       return _postsRepositry.fetchUserPosts(communites);
    }
    return Stream.value([]);

  }
}