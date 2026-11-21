import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions conforming to:
/// "shared-axis / fade-through / Hero transitions (never default push)"
class AppTransitions {
  AppTransitions._();

  /// Fade-Through transition for top-level navigation (tabs, splash, auth)
  static CustomTransitionPage<void> fadeThrough({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
        );
        final curvedOut = CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0.0, 0.4, curve: Curves.easeInCubic),
        );

        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedIn),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(curvedOut),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1.0).animate(curvedIn),
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Shared-Axis X transition (horizontal sliding with gentle fade)
  static CustomTransitionPage<void> sharedAxisX({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 380),
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final inCurve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
        );
        final outCurve = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInQuart,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.15, 0.0),
            end: Offset.zero,
          ).animate(inCurve),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.15, 0.0),
            ).animate(outCurve),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(inCurve),
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Shared-Axis Y transition (vertical elevation for modals and filters)
  static CustomTransitionPage<void> sharedAxisY({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 360),
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.12),
            end: Offset.zero,
          ).animate(curve),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curve),
            child: child,
          ),
        );
      },
    );
  }
}
