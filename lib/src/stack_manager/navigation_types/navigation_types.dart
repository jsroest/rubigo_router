import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager.dart';

/// Base class to distinguish the different navigation types internally
/// It is only used by the [RubigoStackManager._navigate] function.
sealed class NavigationType<SCREEN_ID> {
  NavigationType();
}

/// Defines a Push event
class Push<SCREEN_ID extends Enum> extends NavigationType<SCREEN_ID> {
  /// Creates a Push object.
  Push(this.screenId);

  /// The screenId to push.
  final SCREEN_ID screenId;
}

/// Defines a Pop event
class Pop<SCREEN_ID extends Enum> extends NavigationType<SCREEN_ID> {
  /// Creates a Pop object.
  Pop();
}

/// Defines a PopTo event
class PopTo<SCREEN_ID extends Enum> extends NavigationType<SCREEN_ID> {
  /// Creates a PopTo object.
  PopTo(this.screenId);

  /// The screenId to pop to.
  final SCREEN_ID screenId;
}

/// Defines a ReplaceStack event
class ReplaceStack<SCREEN_ID extends Enum> extends NavigationType<SCREEN_ID> {
  /// Creates a ReplaceStack object
  ReplaceStack(this.screenStack);

  /// The screenStack to replace the current stack with.
  final List<SCREEN_ID> screenStack;
}
