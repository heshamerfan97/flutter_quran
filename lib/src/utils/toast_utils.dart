part of '../flutter_quran_screen.dart';

class ToastUtils {
  void showToast(String msg, {ToastGravity? gravity, Toast? toastLength}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength ?? Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        //backgroundColor: Colors.grey[300],
        //textColor: const Color(0xFF643FDB),
        fontSize: 16.0);
  }


  ///Singleton factory
  static final ToastUtils _instance = ToastUtils._internal();

  factory ToastUtils() {
    return _instance;
  }

  ToastUtils._internal();

}
