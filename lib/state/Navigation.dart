import 'package:flutter/material.dart';

class NavBarState extends ChangeNotifier{

  int _currentIndex = 0;

  void setIndex(int index){
    if(_currentIndex != index){
      _currentIndex = index;
    }
  }

  int get currentIndex => _currentIndex;

}