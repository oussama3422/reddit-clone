import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/provider/failure.dart';
import 'package:reddit_clone/core/provider/type_defs.dart';
import 'firebase_provider.dart';

final firebaseStorageProvder=Provider((ref)=>StorageRepository(
  firebaseStorage: ref.watch(firebaseStorageprovider),
  )
  );

class StorageRepository{
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage}):_firebaseStorage=firebaseStorage;
  


  FutureEither<String>storeFile({required String path,required String id,required File? file}) async{
    try{
        final ref = _firebaseStorage.ref().child(path).child(id);

        UploadTask uploadTask=ref.putFile(file!);

        final snapShot=await uploadTask;

        return right(await snapShot.ref.getDownloadURL());
    }catch(error){
      return left(Failure(message: error.toString()));
    }
  }
}