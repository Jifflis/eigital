import 'package:bloc/bloc.dart';
import 'package:eigital_exam/cubit/news_state.dart';
import 'package:eigital_exam/repository/news_repository.dart';

class NewsCubit extends Cubit<NewsState>{
  NewsCubit(this._repository):super(NewsLoading()){
    getNews();
  }

  final NewsRepository _repository;

  Future<void> getNews() async {
    emit(NewsLoading());

    try{
      emit(NewsLoaded(await _repository.getNews()));
    }catch(e){
      print(e.toString());
      emit(NewsError('Error'));
    }
  }
}