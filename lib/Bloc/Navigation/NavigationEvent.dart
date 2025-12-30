// Events
abstract class NavigationEvent {}

class NavigationTabChanged extends NavigationEvent {
  final int tabIndex;
  NavigationTabChanged(this.tabIndex);
}