import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallets.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});


  void logOut(WidgetRef ref){
    ref.read(authControllerProvider.notifier).logOut();
  }
   void navigateToModProfile(BuildContext context,String uid){
    Routemaster.of(context).push('/u/$uid');
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user=ref.watch(userProvder)!;
    return Drawer(

      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            const SizedBox(height: 8),
            Text('u/${user.name}',style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
            const SizedBox(height: 15),
            const Divider(thickness: 2,height:3),
            const SizedBox(height: 15),
            InkWell(
              child: Row(
                children:const [
                  SizedBox(width:15),
                  Icon(Icons.person),
                  SizedBox(width:15),
                  Text('My Profile'),
                ],
              ),
              onTap: ()=>navigateToModProfile(context, user.uid),
            ),
            const SizedBox(height: 15),
            InkWell(
              child: Row(
                children:[
                  const SizedBox(width:15),
                  Icon(Icons.logout,color:Pallete.redColor),
                  const SizedBox(width:15),
                  const Text('Log Out'),
                ],
              ),
              onTap: ()=>logOut(ref),
            ),
            const SizedBox(height: 15),
            Switch.adaptive(
              value: true,
              onChanged: (newVal){
                
              }
              )
          ],
        ),
        ),
    );
  }
}