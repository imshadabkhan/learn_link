import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/constants/api_endpoints.dart';

class ApiService {
  static Dio dioService = Dio();
//For getting data from backend
  static Future<dynamic> getData({String? endPoint}) async {
    final userController = Get.find<UserController>();

    try {
      final response = await dioService.get(
        '${Endpoints.baseUrl}$endPoint',
        options: Options(
          headers: {
            "Authorization": "Bearer ${userController.token??''}",
            "Accept": "application/json"
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        if (kDebugMode) {
          print("Response Status Code: ${response.statusCode}");
          print("API URL: ${Endpoints.baseUrl}$endPoint");
        }
        return null;
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DioException: ${e.message}");
        if (e.response != null) {
          print("Error Data: ${e.response?.data}");
          print("Error Status: ${e.response?.statusCode}");
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Unexpected Error: $e");
      return null;
    }
  }

  //for sending data to backend
  static Future<dynamic> postData({String? endpoint, dynamic data}) async {
    final userController = Get.find<UserController>();

    try {
      final response = await dioService.post(
        "${Endpoints.baseUrl}$endpoint",
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer ${userController.token.value}",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        if (kDebugMode) {
          print("Status Code: ${response.statusCode}");
          print("URL: ${Endpoints.baseUrl}$endpoint");
        }
        return response.data;
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DioException: ${e.message}");
        if (e.response != null) {
          print("Error Data: ${e.response?.data}");
          print("Error Status: ${e.response?.statusCode}");
        }
      }

      return e.response?.data;
    } catch (e) {
      if (kDebugMode) print("Unexpected Error: $e");
      return null;
    }
  }



}
