import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/features/home/delegete/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/comunity_list_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';
import 'package:reddit_clone/theme/pallets.dart';

import '../../auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends ConsumerState<HomeScreen>{

  int _page=0;
  
  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }
  void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }


void onPageChange(int page){
  setState((){
     _page=page;
  });
}
 

  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvder);

    final currentTheme=ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home',style:TextStyle(fontFamily: 'ZenDots')),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(onPressed:()=>displayDrawer(context), icon:const Icon(Icons.menu));
          }
        ),
        actions: [
          IconButton(
            onPressed: (){
              showSearch(
                context: context,
                delegate: SearchCommunityDelgate(ref),
                );
            },
            icon:const Icon(Icons.search)
            ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: ()=>displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user!.profilePic),
                ),
              );
            }
          )

        ],
      ),
      body: Constants.tabWidget[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        activeColor:currentTheme.iconTheme.color,
        backgroundColor: currentTheme.backgroundColor,
        items:const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: 'Add')
        ], 
        onTap: onPageChange,
      ),
    );
  }
  
  
}