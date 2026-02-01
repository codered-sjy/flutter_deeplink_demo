import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/settings_page.dart';

part 'app_router.g.dart';

// =============================================================================
// TYPED ROUTES
// =============================================================================

/// Home route - the root of the application
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

/// Profile route - displays user profile (absolute path for deep linking)
/// Supports query parameters: userId, name, tab
@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  final String? userId;
  final String? name;
  final String? tab;

  const ProfileRoute({this.userId, this.name, this.tab});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(userId: userId, name: name, tab: tab);
  }
}

/// Settings route - displays app settings (absolute path for deep linking)
@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}

// =============================================================================
// ROUTER CONFIGURATION
// =============================================================================

/// The main router instance for the application
late final GoRouter appRouter;

/// Keep AppLinks instance alive to maintain the stream subscription
late final AppLinks _appLinks;

/// Allowed deep link routes (only profile is supported)
const _allowedDeepLinkRoutes = ['/profile'];

/// Extract the full navigation path (including query params) from a deep link URI
/// Returns null if the route is not allowed for deep linking
String? _getDeepLinkPath(Uri uri) {
  String path;

  // For custom URL schemes, the "path" is in the host
  // e.g., fluttergorouter://profile -> host = "profile", path = ""
  if (uri.scheme != 'http' && uri.scheme != 'https') {
    final host = uri.host;
    if (host.isNotEmpty) {
      path = '/$host';
    } else {
      return null;
    }
  } else {
    // For http/https schemes, use the path directly
    path = uri.path.isEmpty ? '/' : uri.path;
  }

  // Only allow specific routes for deep linking
  if (!_allowedDeepLinkRoutes.contains(path)) {
    return null;
  }

  // Append query parameters if present
  if (uri.queryParameters.isNotEmpty) {
    path = '$path?${uri.query}';
  }

  return path;
}

/// Initialize the router with deep link support
Future<void> initRouter() async {
  _appLinks = AppLinks();

  // Get the initial deep link (cold start) - only for profile
  final initialUri = await _appLinks.getInitialLink();
  final initialLocation = initialUri != null
      ? _getDeepLinkPath(initialUri)
      : null;

  appRouter = GoRouter(
    routes: $appRoutes,
    debugLogDiagnostics: true,
    initialLocation: initialLocation ?? '/',
  );

  // Listen for incoming deep links (warm start) - only for profile
  _appLinks.uriLinkStream.listen((uri) {
    final path = _getDeepLinkPath(uri);

    if (path != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appRouter.go(path);
      });
    }
  });
}
