import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constant/firebase_constants.dart';
import 'package:reddit_clone/core/provider/failure.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';
import 'package:reddit_clone/models/community.dart';
import '../../../core/provider/type_defs.dart';

final communtiyRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firebasefireStoreprovider)) ;
});

class CommunityRepository{

  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore}):_firestore=firestore;

  FutureVoid createCommunity(Community community) async{

    try{
          var communityDoc=await _communities.doc(community.name).get();
          if (communityDoc.exists){
            throw 'Community with the same name already exists';
          }
          return right(_communities.doc(community.name).set(community.toMap()));
    }on FirebaseException catch(error){
       throw error.message!;
    }catch(error){
          return left(Failure(message: error.toString()));
    }
    
  }

  Stream<List<Community>> getUserCommunities(String uid){

    return _communities.where('members',arrayContains: uid).snapshots().map((event){
      List<Community> communties=[];
      for (var doc in event.docs){
        communties.add(Community.fromMap(doc.data() as Map<String,dynamic>));
      }
      return communties;
    });

  }


  Stream<Community> getCommunityyName(String name){
    return _communities.doc(name).snapshots().map((event) => Community.fromMap(event.data() as Map<String,dynamic>));
  }

  CollectionReference get _communities => _firestore.collection(FirebaseConstant.communitiesCollection);
}