import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_app/cubit/states.dart';

import '../../../modules/business/business_screen.dart';
import '../../../modules/science/science_screen.dart';
import '../../../modules/settings/settings_screen.dart';
import '../../../modules/sports/sports_screen.dart';
import '../../../network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomList = [
    const BottomNavigationBarItem(
      icon: Icon(
          Icons.business
      ),
      label: 'Business',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
          Icons.sports
      ),
      label: 'Sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
          Icons.science
      ),
      label: 'Science',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(int idx){
    currentIndex = idx;
    if(idx == 1)
      getSports();
    else if(idx == 2)
      getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness(){
    emit(NewsGetBusinessLoadingState());
    if(business.length == 0){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'business',
            'apiKey':'b1f5bb779f034abd97a50522c44af32b',
          }
      ).then((value) {
        business = value.data['articles'];
        print(business[4]);
        emit(NewsGetBusinessSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetBusinessErrorState(error.toString()));
      });
    }else{
      emit(NewsGetBusinessSuccessState());
    }
  }

  List<dynamic> sports = [];

  void getSports(){
    emit(NewsGetSportsLoadingState());
    if(sports.length == 0){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'sports',
            'apiKey':'b1f5bb779f034abd97a50522c44af32b',
          }
      ).then((value) {
        sports = value.data['articles'];
        print(sports[3]);
        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessState());
    }

  }

  List<dynamic> science = [];

  void getScience(){
    emit(NewsGetScienceLoadingState());
    if(science.length == 0){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'science',
            'apiKey':'b1f5bb779f034abd97a50522c44af32b',
          }
      ).then((value) {
        science = value.data['articles'];
        print(science[0]);
        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    }else{
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic> search = [];

  void getSearch(String value){
    emit(NewsGetSearchLoadingState());
    DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q':value,
          'apiKey':'b1f5bb779f034abd97a50522c44af32b',
        }
    ).then((value) {
      search = value.data['articles'];
      print(search[2]['urlToImage']);
      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
}
