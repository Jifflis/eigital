abstract class MainScreenState{}

class MainScreenInitial extends MainScreenState{}


class MainScreenLoaded extends MainScreenState{
  MainScreenLoaded(this.index);

  final int index;
}