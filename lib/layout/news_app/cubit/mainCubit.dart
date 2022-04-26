import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/network/local/cache_helper.dart';

import 'mainStates.dart';

class MainCubit extends Cubit<MainCubitStates>{
  MainCubit() : super(InitialMainCubitStates());

  static MainCubit get(context) => BlocProvider.of(context);
  bool isDark = false;
  void changeAppMode({bool? fromShared}){
    if(fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    }else{
      isDark = !isDark;
      CacheHelper.putData(key: 'isDark', value: isDark).then((value){
        emit(AppChangeModeState());
      });
    }
  }
}