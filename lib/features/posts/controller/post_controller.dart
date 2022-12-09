import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/posts/repository/post_repository.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../models/comment.dart';
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

///
final getPostByIdProvider = StreamProvider.family((ref,String postId){
  final postController=ref.watch(postsContollerProvider.notifier);
  return postController.getPostById(postId);
});
//////
///
final getCommentPostsProvider = StreamProvider.family((ref,String postId){
  final postController= ref.watch(postsContollerProvider.notifier);
  return postController.fetchPostComment(postId);
});

///
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
          communityName:selectedCommunity.name ,
          communityProfile:selectedCommunity.avatar ,
          upvotes:[],
          downvotes:[] ,
          commentCount:0 ,
          username:user.name,
          uid:user.uid ,
          type: 'text',
          createdAt: DateTime.now(),
          awards:[] ,
          description: description,
          );
    final res= await _postsRepositry.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.textPost);
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
          communityName:selectedCommunity.name ,
          communityProfile:selectedCommunity.avatar ,
          upvotes:[],
          downvotes:[] ,
          commentCount:0 ,
          username:user.name,
          uid:user.uid ,
          type: 'link',
          createdAt: DateTime.now(),
          awards:[] ,
          link: links,
          );
    final res= await _postsRepositry.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.linkPost);

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
             communityName:selectedCommunity.name ,
             communityProfile:selectedCommunity.avatar ,
             upvotes:[],
             downvotes:[] ,
             commentCount:0 ,
             username:user.name,
             uid:user.uid ,
             type: 'image',
             createdAt: DateTime.now(),
             awards:[] ,
             link: success,
          );
            final res= await _postsRepositry.addPost(post);
            _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.imagePost);
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


  void deletePost(Post post,BuildContext context)async{
    final res=await _postsRepositry.deletePost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.deletePost);
    res.fold((l) => showSnackBar(context, l.message), (r) =>showSnackBar(context, 'Post has been deleted Successfully!!') );
  }

// up_vote method
  
void upvote(Post post)async{
  final uid=_ref.read(userProvder)!.uid;
  _postsRepositry.upvote(post, uid);
}
// down_vote method
void downvote(Post post)async{
  final uid=_ref.read(userProvder)!.uid;
  _postsRepositry.downvote(post, uid);
}
/// [getpostById] this method is return all the posts By Their Id
/// 
/// 
Stream<Post> getPostById(String postId){
  return _postsRepositry.getPostById(postId);
}
void addComment({required BuildContext context,required String text,required Post post})async{

    final user=_ref.watch(userProvder)!;

    String commentId=const Uuid().v1();

    Comment comment=Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      profilePic: user.profilePic,
      );
    final res=await _postsRepositry.addComment(comment);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.comment);
    res.fold((l) =>showSnackBar(context,l.message), (r) => null);
}

Stream<List<Comment>> fetchPostComment(String postId){
  return _postsRepositry.getCommentsOfPost(postId);
}



void awardPost({
  required Post post,
  required String award,
  required BuildContext context,
})async{
  final user=_ref.read(userProvder)!;


  final res=await _postsRepositry.awarsPost(post, award, user.uid);

  res.fold((l) => showSnackBar(context,l.message), (r) {
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.awardPost);
    _ref.read(userProvder.notifier).update((state){
          state?.awards.remove(award);
          return state;
    });
    Routemaster.of(context).pop();
  });
}
}