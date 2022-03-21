import 'package:flutter/material.dart';
import 'package:template_provider/data/model/response/language_model.dart';
import 'package:template_provider/util/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
