import 'package:flutter/material.dart';
import 'package:template_provider/data/model/response/base/api_response.dart';
import 'package:template_provider/data/model/response/onboarding_model.dart';
import 'package:template_provider/data/repository/onboarding_repo.dart';

class OnBoardingProvider with ChangeNotifier {
  final OnBoardingRepo onboardingRepo;

  OnBoardingProvider({@required this.onboardingRepo});

  List<OnBoardingModel> _onBoardingList = [];

  List<OnBoardingModel> get onBoardingList => _onBoardingList;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  changeSelectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void initBoardingList(BuildContext context) async {
    ApiResponse apiResponse = await onboardingRepo.getOnBoardingList(context);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _onBoardingList.clear();
      _onBoardingList.addAll(apiResponse.response.data);
      notifyListeners();
    } else {
      print(apiResponse.error.toString());
    }
  }
}
