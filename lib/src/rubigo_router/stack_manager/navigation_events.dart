import 'package:rubigo_router/src/rubigo_router/stack_manager/rubigo_stack_manager.dart';

/// Base class to distinguish the different navigation events internally
/// It is only used by the [RubigoStackManager._navigate] function.
sealed class NavigationEvent<SCREEN_ID> {
  NavigationEvent();
}

/// Defines a Push event
class Push<SCREEN_ID extends Object> extends NavigationEvent<SCREEN_ID> {
  /// Creates a [Push] object.
  Push(this.screenId);

  /// The screenId to push.
  final SCREEN_ID screenId;
}

/// Defines a Pop event
class Pop<SCREEN_ID extends Object> extends NavigationEvent<SCREEN_ID> {
  /// Creates a Pop object.
  Pop();
}

/// Defines a PopTo event
class PopTo<SCREEN_ID extends Object> extends NavigationEvent<SCREEN_ID> {
  /// Creates a [PopTo] object.
  PopTo(this.screenId);

  /// The screenId to pop to.
  final SCREEN_ID screenId;
}

/// Defines a ReplaceStack event
class ReplaceStack<SCREEN_ID extends Object>
    extends NavigationEvent<SCREEN_ID> {
  /// Creates a [ReplaceStack] object/
  ReplaceStack(this.screenStack);

  /// The screenStack to replace the current stack with.
  final List<SCREEN_ID> screenStack;
}

/// Defines a Remove event
class Remove<SCREEN_ID extends Object> extends NavigationEvent<SCREEN_ID> {
  /// Creates a [Remove] object.
  Remove(this.screenId);

  /// The screenId to remove.
  final SCREEN_ID screenId;
}
