abstract class MapState {}

class MapLoaded extends MapState {
  MapLoaded({this.showNavigateButton =false});

  bool showNavigateButton;
}
