import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';

typedef void SurveyClosedListener();
typedef void SurveyClosedFromPageListener();
typedef void DidReceiveInbrainRewardListener(int? reward);
typedef void DidReceiveInbrainIosRewardListener(double? reward);
typedef void IsSurveyWallAvailableListener(bool? available);
typedef void IsSurveyWallIosAvailableListener(bool? available);
typedef void SurveyShowSuccessListener();
typedef void SurveyShowFailureListener(List<String>? list);

class FlutterInBrain {
  static FlutterInBrain get instance => _instance;

  final MethodChannel _channel;

  static final FlutterInBrain _instance = FlutterInBrain.private(
    const MethodChannel('flutter_inbrain'),
  );

  FlutterInBrain.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static late SurveyClosedListener _surveyClosedListener;
  static late SurveyClosedFromPageListener _surveyClosedFromPageListener;
  static late DidReceiveInbrainRewardListener _didReceiveInbrainRewardListener;
  static late IsSurveyWallAvailableListener _isSurveyWallAvailableListener;
  static late IsSurveyWallIosAvailableListener _isSurveyWallIosAvailableListener;
  static late DidReceiveInbrainIosRewardListener _didReceiveInbrainIosRewardListener;
  static late SurveyShowSuccessListener _surveyShowSuccessListener;
  static late SurveyShowFailureListener _surveyShowFailureListener;

  Future<void> init(
      {String? apiClientId, String? apiSecret, bool? isS2S, String? userId}) async {
    assert(apiClientId != null && apiClientId.isNotEmpty);
    return _channel.invokeMethod('init', <String, dynamic>{
      'apiClientId': apiClientId,
      'apiSecret': apiSecret,
      'isS2S': isS2S,
      'userId': userId,
    });
  }

  Future<void> destroyCallback() async {
    if(Platform.isAndroid) {
    return _channel.invokeMethod('destroyCallback');
    }
  }

  Future<void> show() async {
    return _channel.invokeMethod('showSurveys');
  }

  Future<void> customiseUI(
      {String? title,
      bool? elevation,
      String? bgColor,
      String? buttonColor,
      String? titleColor,
}) async {
    return _channel.invokeMethod('customiseUI', <String, dynamic>{
      'title': title,
      'elevation': elevation,
      'bg_color': bgColor,
      'button_color': buttonColor,
      'title_color': titleColor,
    });
  }

  Future _platformCallHandler(MethodCall call) async {
    print(
        "FlutterInBrain _platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case "surveyClosed":
        _surveyClosedListener();
        break;
      case "surveyClosedFromPage":
        _surveyClosedFromPageListener();
        break;
      case "didRecieveInBrainRewards":
      if(Platform.isAndroid) {
        _didReceiveInbrainRewardListener(call.arguments);
      } else if(Platform.isIOS) {
        _didReceiveInbrainIosRewardListener(call.arguments);
      }
        break;
      case "onShowSuccess":
      if(Platform.isAndroid) {
        _surveyShowSuccessListener();
      }

        break;
      case "onShowFailure":
      if(Platform.isAndroid) {
        _surveyShowFailureListener(call.arguments);
      }
        break;
      case "onSurveysAvailable":
      if(Platform.isAndroid) {
        print("For Android:$call.arguments");
        _isSurveyWallAvailableListener(call.arguments);
      } else if(Platform.isIOS) {
        print("For IOS:$call.arguments");
        _isSurveyWallIosAvailableListener(call.arguments);
      }
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }

  void setSurveyClosedListener(SurveyClosedListener surveyClosedListener) =>
      _surveyClosedListener = surveyClosedListener;

  void setSurveyWallClosedFromPageListener(
          SurveyClosedFromPageListener surveyClosedFromPageListener) =>
      _surveyClosedFromPageListener = surveyClosedFromPageListener;

  void setDidReceiveRewardListener(
          DidReceiveInbrainRewardListener didReceiveInbrainRewardListener) =>
      _didReceiveInbrainRewardListener = didReceiveInbrainRewardListener;

  void setIsSurveyWallAvailableListener(
          IsSurveyWallAvailableListener isSurveyWallAvailableListener) =>
      _isSurveyWallAvailableListener = isSurveyWallAvailableListener;

  void setIsSurveyWallFailureListener(
          SurveyShowFailureListener surveyShowFailureListener) =>
      _surveyShowFailureListener = surveyShowFailureListener;

  void setIsSurveyWallSuccessListener(
          SurveyShowSuccessListener surveyShowSuccessListener) =>
      _surveyShowSuccessListener = surveyShowSuccessListener;

   void setIsSurveyWalliOSSuccessListener(
          IsSurveyWallIosAvailableListener surveyShowSuccessListener) =>
      _isSurveyWallIosAvailableListener = surveyShowSuccessListener;

     void setDidRecieveiOSSurveywallListener(
          DidReceiveInbrainIosRewardListener didReceiveInbrainIosRewardListener) =>
      _didReceiveInbrainIosRewardListener = didReceiveInbrainIosRewardListener;

}
