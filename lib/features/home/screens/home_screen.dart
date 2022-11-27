import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repositry/auth_repository.dart';
import 'package:reddit_clone/features/home/drawers/comunity_list_drawer.dart';

import '../../auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user=ref.watch(userProvder);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(onPressed:()=>displayDrawer(context), icon:const Icon(Icons.menu));
          }
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon:const Icon(Icons.search)
            ),
          IconButton(
            onPressed: (){},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
            ),
          )

        ],
      ),
      drawer: const CommunityListDrawer(),
    );
  }
}