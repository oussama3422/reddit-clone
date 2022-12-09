import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import '../../../models/user_model.dart';

final userProvder=StateProvider<UserModel?>((ref) => null );

final authControllerProvider=StateNotifierProvider<AuthController,bool>(
  (ref)=>AuthController(
    authRepository:ref.watch(authRepositoryProvider),
    ref:ref,
    )
    );

final authStateChangeProvider=StreamProvider((ref){
  final authController=ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});
final getUserDataProvider=StreamProvider.family((ref,String uid){
  final authController=ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool>{
    final AuthRepository _authRepository;
    final Ref _ref;
    AuthController({
      required AuthRepository authRepository,required Ref ref })
      : _authRepository=authRepository,
      _ref=ref, super(false)
      ;

Stream<User?> get authStateChange=>_authRepository.authStateChange;


///this method is SingIn any user With goolse
void singInWithGoogle(BuildContext context,bool isFromLogin)async{
      state=true;
      final user =await _authRepository.singInWithGoogle(isFromLogin);
      state=false;
      user.fold((l)=>showSnackBar(context, l.message),(userModel)=>_ref.read(userProvder.notifier).update((state) => userModel));
}

///this method is SingIn any user as Guest which mean anounymos
void singInAsGuest(BuildContext context)async{
      state=true;
      final user =await _authRepository.singInAsGuest();
      state=false;
      user.fold((l)=>showSnackBar(context, l.message),(userModel)=>_ref.read(userProvder.notifier).update((state) => userModel));
    }
Stream<UserModel> getUserData(String uid){
return _authRepository.getUserData(uid);

}
  void logOut(){
       _authRepository.logOut();
  }
}