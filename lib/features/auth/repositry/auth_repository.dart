import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';

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


void singInWithGoogle()async{
  try{
   final GoogleSignInAccount? googleUser=await _googleSignIn.signIn();
   final googelAuth=await googleUser?.authentication;
   final credential=GoogleAuthProvider.credential(
    accessToken:googelAuth?.accessToken,
    idToken:googelAuth?.idToken,
    );
    UserCredential userCredential=await _firebaseAuth.signInWithCredential(credential);
    print(userCredential.user?.email);
    }catch(error){
       rethrow;
    }


}


}