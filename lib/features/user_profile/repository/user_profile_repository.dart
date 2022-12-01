
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constant/firebase_constants.dart';
import 'package:reddit_clone/core/provider/failure.dart';

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


 FutureVoid editProfile(UserModel user)async{
  try{
  return right(_users.doc(user.uid).update(user.toMap()));
  }on FirebaseException catch(error){
     throw error.message!;   
  } catch(error){
      return left(Failure(message: error.toString()));
  }
 }
}