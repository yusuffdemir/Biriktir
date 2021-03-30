import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'Constants.dart';
import 'UserModel.dart';

class Functions{
  static constScreeen(Widget widget,BuildContext context){
    return MediaQuery(
      child: widget,
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    );
  }

  static Future<bool> internetDurumu(BuildContext context) async {
    var sonuc = await Connectivity().checkConnectivity();
    if(sonuc == ConnectivityResult.none){
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Text("İnternet Bağlantınızı Kontrol Edin!",style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.bold),),
          actions: <Widget>[
            FlatButton(
              child: Text("Ayarlar",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
              onPressed: () {AppSettings.openDataRoamingSettings();},
            ),
            FlatButton(
              child: Text("Tamam",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
              onPressed: () {Navigator.pop(context);},
            ),
          ],);
      },
          barrierDismissible: false);
      return false;
    }
    return true;
  }


  static fbTokenGuncelle() async{
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String fbToken = await firebaseMessaging.getToken();
    var body = jsonEncode({
      "kullaniciId": KullaniciBilgileri.id,
      "fbToken": fbToken,
    });
    var response = await http.post("API URL",
        headers: {
          'Content-Type': 'application/json'
        },
        body: body);
    print(response.statusCode);

  }
}