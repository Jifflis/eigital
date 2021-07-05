import 'dart:ui';

import 'package:eigital_exam/cubit/news_cubit.dart';
import 'package:eigital_exam/cubit/news_state.dart';
import 'package:eigital_exam/model/news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: BlocConsumer<NewsCubit, NewsState>(
        listener: (BuildContext context, NewsState state) {
          if (state is NewsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error loading!'),
              ),
            );
          }
        },
        builder: (BuildContext context, NewsState state) {
          if (state is NewsLoaded) {
            return _buildNewsFeed(state.news);
          }
          if (state is NewsError) {
            return _buildErrorWidget();
          }
          return _buildLoadingWidget();
        },
      ),
    );
  }

  /// Build Error Widget
  ///
  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          child: const Text('Error'),
        ),
      ),
    );
  }

  /// Build loading widget
  ///
  Widget _buildLoadingWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Build News feed
  ///
  ListView _buildNewsFeed(List<News> news) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (BuildContext context, int i) {
        return NewsCard(news[i]);
      },
    );
  }
}

/// News Tile Widget
///
class NewsCard extends StatelessWidget {
  const NewsCard(this.news);

  final News news;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(news.url)) {
          await launch(news.url, forceSafariVC: false, forceWebView: false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error loading!'),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            _buildImage(),
            const SizedBox(width: 14),
            _buildDetails()
          ],
        ),
      ),
    );
  }

  /// Build Details
  ///
  Expanded _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            news.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '${news.description.substring(0, 100)}...',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            news.datePublished,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  /// Build Image
  ///
  Container _buildImage() {
    return Container(
      width: 120,
      height: 120,
      child: Image.network(
        news.image,
        fit: BoxFit.fill,
      ),
    );
  }
}
