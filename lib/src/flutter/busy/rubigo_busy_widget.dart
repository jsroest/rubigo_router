import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy_event.dart';

/// This widget protect its children by any screen user interaction
/// by placing an [IgnorePointer] above them in a stack.
/// ```dart
/// MaterialApp.router(
///   backButtonDispatcher: RootBackButtonDispatcher(),
///   routerDelegate: widget.routerDelegate,
///   builder: (context, child) {
///     return RubigoBusyWidget(
///       progressIndicator: widget.progressIndicator,
///       listener: widget.routerDelegate.rubigoRouter.rubigoBusy.notifier,
///       child: child!,
///     );
///   },
/// );
/// ```
class RubigoBusyWidget extends StatelessWidget {
  /// Create RubigoBusyWidget.
  const RubigoBusyWidget({
    required this.child,
    required this.listener,
    Widget? progressIndicator,
    super.key,
  }) : _progressIndicator = progressIndicator ??
            const Center(
              child: CircularProgressIndicator(),
            );

  ///The rest of the app is represented by this child
  final Widget child;

  final Widget _progressIndicator;

  /// Connect a [RubigoBusyService.notifier] to this listener.
  final ValueListenable<RubigoBusyEvent> listener;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listener,
      builder: (context, value, _) {
        return Stack(
          children: [
            IgnorePointer(
              ignoring: value.enabled && value.isBusy,
              child: child,
            ),
            if (value.enabled && value.isBusy && value.showProgressIndicator)
              _progressIndicator,
          ],
        );
      },
    );
  }
}
