// States
abstract class NavigationState {
  int get currentTab;
}

class NavigationInitial extends NavigationState {
  @override
  int get currentTab => 0;
}

class NavigationChanged extends NavigationState {
  final int _currentTab;

  NavigationChanged(this._currentTab);

  int get currentTab => _currentTab;
}