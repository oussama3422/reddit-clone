
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constant/firebase_constants.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/provider/failure.dart';
import 'package:reddit_clone/models/post.dart';

import '../../../core/provider/firebase_provider.dart';
import '../../../core/provider/type_defs.dart';
import '../../../models/user_model.dart';

final userRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firebasefireStoreprovider)) ;
});

class UserProfileRepository{


  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore}):_firestore=firestore;



 CollectionReference get _users => _firestore.collection(FirebaseConstant.usersCollection);
 CollectionReference get _posts => _firestore.collection(FirebaseConstant.postsCollection);


 FutureVoid editProfile(UserModel user)async{
  try{
  return right(_users.doc(user.uid).update(user.toMap()));
  }on FirebaseException catch(error){
     throw error.message!;   
  } catch(error){
      return left(Failure(message: error.toString()));
  }
 }

 Stream<List<Post>> getUserPosts(String uid){
  return _posts.where('uid',isEqualTo: uid).orderBy('createdAt',descending: true).snapshots().map(
    (event)=>event.docs.map((e)=>Post.fromMap(e.data() as Map<String,dynamic>)
  ).toList()
  );
 }
 FutureVoid updateUserkarma(UserModel userModel)async{
  try{
    return right(
      _users.doc(userModel.uid).update({
        'karma':userModel.karma,
      })
    );
  }on FirebaseException catch(error){
    throw error.message!;
  }
  catch(error){
      return left(Failure(message: error.toString()));
  }


 }
}