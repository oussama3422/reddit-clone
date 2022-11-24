//loggedOut

  import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/community_screen.dart';

final loggedOutRoute=RouteMap(
  routes: {
  '/':(_)=>const MaterialPage(child: LoginScreen()),
  }
  );
final loggedInRoute=RouteMap(
  routes: {
  '/':(_)=>const MaterialPage(child: HomeScreen()),
  '/create-community':(_)=>const MaterialPage(child: CreateCommunityScreen()),
  }
  );


//loggedIn