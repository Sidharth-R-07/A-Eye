import 'package:flutter/material.dart';
import 'package:open_ai/services/api_services.dart';

import '../models/models_model.dart';

class ModelsProvider with ChangeNotifier {
  List<Models> _models = [];

  List<Models> get getModels => _models;

  String _currentModel = "gpt-3.5-turbo";

  String get getCurrentModel => _currentModel;

  Future<List<Models>> getAllModels() async {
    _models = await ApiServices.getModels();
    notifyListeners();
    return _models;
  }

  void setModel(String newModel) {
    _currentModel = newModel;
    notifyListeners();
  }


  
}
