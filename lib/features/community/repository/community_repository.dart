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

  FutureVoid editCommunity(Community community)async{
    try{
     return right(_communities.doc(community.name).update(community.toMap()));
    }on FirebaseException catch(e){
      throw e.message!;
    }
    catch(error){
      return left(Failure(message: error.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName,String userId)async{
    try{

        return right( _communities.doc(communityName).update({
          'members':FieldValue.arrayUnion([userId]),
        })
        );
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(error){
      return left(Failure(message: error.toString()));
    }
  }
  FutureVoid leaveCommunity(String communityName,String userId)async{
    try{

        return right( _communities.doc(communityName).update({
          'members':FieldValue.arrayRemove([userId]),
        })
        );
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(error){
      return left(Failure(message: error.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query){
    return _communities.where(
      'name',
      isGreaterThanOrEqualTo:query.isEmpty ? 0:query,
      isLessThan:query.isEmpty
      ?null
      :query.substring( 0,query.length - 1) +
      String.fromCharCode(
        query.codeUnitAt(query.length-1) + 1,
      ),
        )
        .snapshots().map((event) {
          List<Community> communties=[];
          for (var communtiy in event.docs){
            communties.add(Community.fromMap(communtiy.data() as Map<String,dynamic>));
          }
          return communties;
        });
  }

  FutureVoid addMods(String communityName,List<String> uids)async{
    try{
        return right(_communities.doc(communityName).update({
          'mods':uids,
        }));
    }on FirebaseException catch (error){
      throw error.message!;
    }
    
    catch(error){
      return left(Failure(message: error.toString()));
    }
  }

  CollectionReference get _communities => _firestore.collection(FirebaseConstant.communitiesCollection);
}