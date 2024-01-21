import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gen_ai/plan/plan.dart';
import 'package:gen_ai/explore/explore.dart';

const initialLocation = '/home';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            label: 'Plan',
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
          ),
          NavigationDestination(
            label: 'Explore',
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
          ),
          NavigationDestination(
            label: 'Profile',
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
          ),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({
    required this.label,
    required this.detailsPath,
    super.key,
  });

  final String label;
  final String detailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the root screen for $label'),
            ElevatedButton(
              onPressed: () => context.go(detailsPath),
              child: const Text('Go to details'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for $label'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the details screen for $label'),
          ],
        ),
      ),
    );
  }
}

final router = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PlanPage(),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'details',
                  builder: (context, state) =>
                  const DetailsScreen(label: 'Home'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            GoRoute(
              path: '/explore',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ExplorePage(),
              ),
              routes: [
                GoRoute(
                  path: 'details',
                  builder: (context, state) =>
                  const DetailsScreen(label: 'Feed'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCKey,
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RootScreen(
                  label: 'Profile', detailsPath: '/profile/details',),
              ),
              routes: [
                GoRoute(
                  path: 'details',
                  builder: (context, state) =>
                  const DetailsScreen(label: 'Profile'),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  debugLogDiagnostics: kDebugMode,
  initialLocation: initialLocation,
  navigatorKey: _rootNavigatorKey,
);