import 'dart:convert';
import 'package:provider/provider.dart';
import 'Models/CevrePuani.dart';
import 'package:biriktir/HomePage.dart';
import 'package:biriktir/Models/Functions.dart';
import 'package:biriktir/SigninPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'Models/Constants.dart';
import 'Models/UserModel.dart';
import 'Widgets/SehirSecPopUp.dart';
import 'OnBoardging.dart';


class LoginCheck extends StatefulWidget {
  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  bool isLog = false;
  int pageIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [_blankPage(),HomePage(),SignInPage(),Onboarding()];
    return pages[pageIndex];
  }



  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

   try{
     String mail = prefs.getString('mail');
     String pass = prefs.getString('pass');
     bool ozelMi = prefs.getBool('ozelMi');
     String isFirstOpen = prefs.getString('isFirstOpen');
     print(isFirstOpen);
     if(ozelMi == null) ozelMi = false;
     print(mail);
     if(ozelMi){
       await _ozelSignIn(mail);
       return;
     }
     if(mail == null ||mail == "" || pass == null ||pass == ""){
       if(isFirstOpen == "false"){
         setState(() {
           pageIndex = 2;
         });
       }else{
         setState(() {
           pageIndex = 3;
         });
       }
       return;
     }
     setState(() {
       _signIn(mail,pass);
     });
   }catch(e){
     setState(() {
       pageIndex = 2;
     });
   }
  }

  void _signIn(String mail,String sifre) async {
    if(!await Functions.internetDurumu(context)) return;
    String md5Sifre = generateMd5(sifre.trimRight());
    var response = await http.get(
      "APIURL",
    );

    if (response.statusCode == 200) {
      var kullanici = jsonDecode(response.body);
      KullaniciBilgileri.adSoyad = kullanici["kullanici_adSoyad"];
      KullaniciBilgileri.cinsiyet = kullanici["kullanici_cinsiyet"];
      KullaniciBilgileri.dogumTarihi = kullanici["kullanici_dogumTarihi"];
      KullaniciBilgileri.ilce = kullanici["kullanici_ilce"];
      KullaniciBilgileri.il = kullanici["kullanici_il"];
      KullaniciBilgileri.ilceId = kullanici["kullanici_ilceId"];
      KullaniciBilgileri.id = kullanici["kullanici_id"];
      KullaniciBilgileri.davetEtti = kullanici["kullanici_davetEtti"] == 1 ? true : false;
      KullaniciBilgileri.davetKodu = kullanici["kullanici_davetKodu"];
      KullaniciBilgileri.ppUrl = kullanici["kullanici_ppName"] != null ? Constants.generaPpUrl+kullanici["kullanici_ppName"] : Constants.noPpUrl;
      KullaniciBilgileri.mail = kullanici["kullanici_mail"];
      context.read<CevrePuani>().equals(int.parse(kullanici["kullanici_toplamKazandigi"].toString()) - int.parse(kullanici["kullanici_toplamHarcadigi"].toString()));
      KullaniciBilgileri.co2Puani = double.parse(kullanici["kullanici_co2Puani"].toString());
      KullaniciBilgileri.gunlukPuan = int.parse(kullanici["gunluk_puan"].toString());
      KullaniciBilgileri.tel = kullanici["kullanici_tel"].toString();
      KullaniciBilgileri.sifre = sifre;
      Functions.fbTokenGuncelle();
      KullaniciBilgileri.sifreDegisti = false;
      if(KullaniciBilgileri.ilce == null || KullaniciBilgileri.il == null || KullaniciBilgileri.ilceId == null){
        Navigator.pop(context);
        showDialog(context: context,builder: (context) => SehirSecDialog(KullaniciBilgileri.id),barrierDismissible: false);
        return;
      }
     setState(() {
       pageIndex = 1;
     });
      print(kullanici);
    }
    else {
      KullaniciBilgileri.sifreDegisti = true;
      setState(() {
        pageIndex = 2;
      });
    }



  }

  _ozelSignIn(String kullaniciMail) async {

    if(!await Functions.internetDurumu(context)) return;
    var response = await http.get(
      "APIURL",
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var kullanici = jsonDecode(response.body);
      KullaniciBilgileri.adSoyad = kullanici["kullanici_adSoyad"];
      KullaniciBilgileri.cinsiyet = kullanici["kullanici_cinsiyet"];
      KullaniciBilgileri.dogumTarihi = kullanici["kullanici_dogumTarihi"];
      KullaniciBilgileri.ilce = kullanici["kullanici_ilce"];
      KullaniciBilgileri.il = kullanici["kullanici_il"];
      KullaniciBilgileri.ilceId = kullanici["kullanici_ilceId"];
      KullaniciBilgileri.ppUrl = kullanici["kullanici_ppName"] != null ? Constants.generaPpUrl+kullanici["kullanici_ppName"] : Constants.noPpUrl;
      KullaniciBilgileri.id = kullanici["kullanici_id"];
      KullaniciBilgileri.mail = kullanici["kullanici_mail"];
      KullaniciBilgileri.davetEtti = kullanici["kullanici_davetEtti"] == 1 ? true : false;
      KullaniciBilgileri.davetKodu = kullanici["kullanici_davetKodu"];
      context.read<CevrePuani>().equals(int.parse(kullanici["kullanici_toplamKazandigi"].toString()) - int.parse(kullanici["kullanici_toplamHarcadigi"].toString()));
      KullaniciBilgileri.co2Puani = double.parse(kullanici["kullanici_co2Puani"].toString());
      KullaniciBilgileri.gunlukPuan = int.parse(kullanici["gunluk_puan"].toString());
      KullaniciBilgileri.tel = kullanici["kullanici_tel"].toString();
      print(KullaniciBilgileri.il);
      prefs.setString("mail", kullaniciMail);
      prefs.setBool("ozelMi", true);
      Functions.fbTokenGuncelle();
      KullaniciBilgileri.sifreDegisti = false;
      if(KullaniciBilgileri.ilce == null || KullaniciBilgileri.il == null || KullaniciBilgileri.ilceId == null){
        Navigator.pop(context);
        showDialog(context: context,builder: (context) => SehirSecDialog(KullaniciBilgileri.id),barrierDismissible: false);
        return;
      }
      setState(() {
        pageIndex = 1;
      });
    }
    else {
      KullaniciBilgileri.sifreDegisti = true;
    setState(() {
      pageIndex = 2;
    });
    }



  }


  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  _blankPage() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
