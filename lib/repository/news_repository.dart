import 'dart:convert';

import 'package:eigital_exam/environment.dart';
import 'package:eigital_exam/model/news.dart';
import 'package:eigital_exam/repository/api_provider.dart';
import 'package:http/http.dart' as http;

class NewsRepository{
  factory NewsRepository()=>_instance;
  NewsRepository._();
  static final NewsRepository _instance= NewsRepository._();

  ApiProvider api =ApiProvider();

  Map<String,String> headers = <String, String>{
  'x-bingapis-sdk': 'true',
  'x-rapidapi-key': Env.x_rapidapi_key,
  'x-rapidapi-host': Env.x_rapidapi_host,
  'Content-Type':'application/json'
  };


  Future<List<News>> getNews() async{
     final http.Response response = await api.get('${Env.newsEndpoint}news',headers: headers);
     final Map<String,dynamic> data = json.decode(response.body);
     final List<dynamic> mapList = data['value']??<dynamic>[];

     final List<News> newsList = <News>[];

     for(final Map<String,dynamic> map in mapList){
       final News news = News(json: map);
       newsList.add(news);
     }

    return newsList;
  }
}

