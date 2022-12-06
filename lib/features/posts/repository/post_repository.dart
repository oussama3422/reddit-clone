import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constant/firebase_constants.dart';
import 'package:reddit_clone/core/provider/failure.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';
import 'package:reddit_clone/core/provider/type_defs.dart';
import '../../../models/community.dart';
import '../../../models/post.dart';


final postRepositoryProvider = Provider((ref){
  return  PostsRepositry(
  firestore: ref.watch(firebasefireStoreprovider),
 );
});


class PostsRepositry{

  final FirebaseFirestore _firestore;

  PostsRepositry({required FirebaseFirestore firestore}):_firestore=firestore;

 CollectionReference get _posts => _firestore.collection(FirebaseConstant.postsCollection);


FutureVoid addPost(Post post)async{
  try{
   
   return right(_posts.doc(post.id).set(post.toMap()));


  }on FirebaseException catch(error){
    throw error.message!;
  }
  catch(error){
    return left(Failure(message: error.toString()));
  }
}
  Stream<List<Post>> fetchUserPosts(List<Community> communites){
    return _posts.where(
        'communityName',
         whereIn: communites.map((e) => e.name).toList(),
      ).orderBy('createdAt',descending: true)
       .snapshots()
       .map(
        (event) => event.docs
              .map((e) => Post.fromMap(
                e.data() as Map<String,dynamic>
                )
        ).toList(),
        );
  }

// delete Post
  FutureVoid deletePost(Post post)async{
    try{
      return right(_posts.doc(post.id).delete());
    }on FirebaseException catch(e){
      throw e.message!;
    }
    catch(error){
      return left(Failure(message: error.toString()));
    }
  }
// create upVotes

void upvote(Post post,String userId)async{
  if(post.downvotes.contains(userId)){
    _posts.doc(post.id).update({
      'downvotes':FieldValue.arrayRemove([userId]),
    });
  }
  if(post.upvotes.contains(userId)){
     _posts.doc(post.id).update({
      'upvotes':FieldValue.arrayRemove([userId]),
    });
  }else{
      _posts.doc(post.id).update({
      'upvotes':FieldValue.arrayUnion([userId]),
    });
  }
}
// create downVotes

void downvote(Post post,String userId)async{
  if(post.upvotes.contains(userId)){
    _posts.doc(post.id).update({
      'upvotes':FieldValue.arrayRemove([userId]),
    });
  }
  if(post.downvotes.contains(userId)){
     _posts.doc(post.id).update({
      'downvotes':FieldValue.arrayRemove([userId]),
    });
  }else{
      _posts.doc(post.id).update({
      'downvotes':FieldValue.arrayUnion([userId]),
    });
  }
}

}