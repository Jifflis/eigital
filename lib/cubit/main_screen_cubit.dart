
import 'package:bloc/bloc.dart';
import 'package:eigital_exam/cubit/main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState>{
  MainScreenCubit():super(MainScreenInitial());

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index){
    _selectedIndex = index;
   emit(MainScreenLoaded(_selectedIndex));
  }
}