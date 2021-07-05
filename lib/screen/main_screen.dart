import 'package:eigital_exam/constant/custom_colors.dart';
import 'package:eigital_exam/cubit/calculator_cubit.dart';
import 'package:eigital_exam/cubit/main_screen_cubit.dart';
import 'package:eigital_exam/cubit/main_screen_state.dart';
import 'package:eigital_exam/cubit/map_cubit.dart';
import 'package:eigital_exam/cubit/news_cubit.dart';
import 'package:eigital_exam/repository/news_repository.dart';
import 'package:eigital_exam/screen/calculator_screen.dart';
import 'package:eigital_exam/screen/map_screen.dart';
import 'package:eigital_exam/screen/news_screen.dart';
import 'package:eigital_exam/util/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen(this.user);

  final User? user;

  @override
  Widget build(BuildContext context) {

    final List<Widget> _navigationScreens = <Widget>[
      BlocProvider<MapCubit>(
        create: (_) => MapCubit(),
        child: MapScreen(user),
      ),
      BlocProvider<NewsCubit>(
        create: (_) => NewsCubit(NewsRepository()),
        child: NewsScreen(),
      ),
      BlocProvider<CalculatorCubit>(
        create: (_) => CalculatorCubit(),
        child: CalculatorScreen(),
      ),
    ];

    return BlocConsumer<MainScreenCubit, MainScreenState>(
      listener: (_, __) {},
      builder: (BuildContext context, MainScreenState state) {
        final MainScreenCubit cubit = BlocProvider.of(context);
        return Scaffold(
          body: _navigationScreens[cubit.selectedIndex],
          bottomNavigationBar: _buildBottomNavigation(
            context,
            cubit,
          ),
        );
      },
    );
  }

  /// Build bottom navigation widget.
  ///
  ///
  Widget _buildBottomNavigation(
          BuildContext context, MainScreenCubit controller) =>
      BottomNavigationBar(
        backgroundColor: CustomColors.gray11,
        elevation: 10,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: CustomColors.violet,
        unselectedItemColor: Colors.grey,
        currentIndex: controller.selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.selectedIndex = index;
        },
        items: _bottomNavigationItems(),
      );

  /// Bottom navigation items.
  ///
  ///
  List<BottomNavigationBarItem> _bottomNavigationItems() =>
      <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Icon(
              Icons.map,
              size: 19,
            ),
          ),
          label: 'Map',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Icon(
              Icons.list_alt,
              size: 19,
            ),
          ),
          label: 'News Feed',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Icon(
              Icons.calculate,
              size: 19,
            ),
          ),
          label: 'Calculator',
        ),
      ];
}
