// import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
class ProfileController extends GetxController {
  var selectedOption = (-1).obs;
  var selectedUnit = ''.obs;
  var selectedWeightUnit = 'kg'.obs;
  var selectedEthnicity = ''.obs;
  var selectedDietaryPreference = ''.obs;
  var smokingStatus = ''.obs;
  var alcoholConsumption = ''.obs;
  var menopauseStatus = ''.obs;
  RxString selectedCountry = "".obs;

  final List<String> options = [
    'Required Data Processing',
    'Marketing Communications',
    'Third-Party Data Sharing',
    'Health Research Participation',
  ];
  final List<String> dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Omnivore',
    'Keto',
    'Halal',
    'Kosher',
    'Gluten-Free',
    'Other',
  ];
  final List<String> ethnicityOptions = [
    'Asian',
    'Black or African',
    'White',
    'Hispanic or Latino',
    'Native American',
    'Middle Eastern',
    'Pacific Islander',
    'Other',
  ];

  // Inside your ProfileController

  final selectedCountryIso = ''.obs; // holds the ISO2 code
  final selectedCity = ''.obs;
  final cityList = <String>[].obs;

  final selectedState = ''.obs;


  final selectedStateCode = ''.obs;


  void selectOption(int index) {
    selectedOption.value = index;
  }






}
