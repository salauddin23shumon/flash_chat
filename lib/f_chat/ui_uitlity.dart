
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtility {

  static void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0
    );
  }


}
