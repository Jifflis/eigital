import 'package:eigital_exam/model/news.dart';

abstract class NewsState{}

class NewsLoaded extends NewsState{
  NewsLoaded(this.news);
  final List<News> news;
}

class NewsLoading extends NewsState{
  NewsLoading();
}

class NewsError extends NewsState{
  NewsError(this.error);
  final String error;
}