import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/core/constant/firebase_constants.dart';
import 'package:reddit_clone/core/provider/failure.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';
import 'package:reddit_clone/models/user_model.dart';
import '../../../core/provider/type_defs.dart';


final authRepositoryProvider = Provider((ref)=>AuthRepository(
  firebaseAuth:ref.read(authprovider) ,
  firestore:ref.read(firebasefireStoreprovider) ,
  googleSignIn:ref.read(googleSingInProvider)
  )
  );

class AuthRepository{

   FirebaseAuth _firebaseAuth;
   FirebaseFirestore _firestore;
   GoogleSignIn _googleSignIn;

   AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
   })
   :
   _firebaseAuth=firebaseAuth,
   _firestore=firestore,
   _googleSignIn=googleSignIn;

CollectionReference get _users=>_firestore.collection(FirebaseConstant.usersCollection);


Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();



FutureEither<UserModel?> singInWithGoogle()async{
  try{
    final GoogleSignInAccount? googleUser=await _googleSignIn.signIn();
    final googelAuth=await googleUser?.authentication;
    final credential=GoogleAuthProvider.credential(
    accessToken:googelAuth?.accessToken,
    idToken:googelAuth?.idToken,
    );
    UserCredential userCredential=await _firebaseAuth.signInWithCredential(credential);
    UserModel userModel;
     if(userCredential.additionalUserInfo!.isNewUser)
     {
       
      userModel=UserModel(
           name: userCredential.user!.displayName ?? 'No Name',
           profilePic: userCredential.user!.photoURL??Constants.avatarDefault,
           banner:Constants.bannerDefault,
           uid: userCredential.user!.uid,
           isAuthenticated: true,
           karma: 0,
            awards: [],
      );
      await _users.doc(userModel.uid).set( userModel.toMap(),);
    }else{
          userModel=await getUserData(userCredential.user!.uid).first;
    }
       return right(userModel);
    }on FirebaseException catch(e){
      throw e.message!;
    }
    catch(error){
       return left(Failure(message: error.toString()));
    }


}

Stream<UserModel> getUserData(String uid){
  return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String,dynamic> ));
}

}