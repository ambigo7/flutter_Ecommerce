
import 'package:flutter/material.dart';
import 'package:lets_shop/models/lens.dart';
import 'package:lets_shop/service/lens.dart';

class LensProvider with ChangeNotifier{
  LensService _lensService = LensService();

  List<LensModel> lens = [];

  LensProvider.initialize(){
    loadLens();
  }

  loadLens() async{
    lens = await _lensService.getLens();
    print('lens length ${lens.length}');
    notifyListeners();
  }

  Future reloadLens() async{
    lens = await _lensService.getLens();
    notifyListeners();
  }

}