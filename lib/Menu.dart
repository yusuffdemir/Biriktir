import 'package:biriktir/Bildirimler.dart';
import 'package:biriktir/DavetEt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

import 'Models/Functions.dart';

import 'package:biriktir/Models/UserModel.dart';
import 'package:biriktir/ProfilDuzenleme.dart';
import 'package:biriktir/SigninPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuSayfasi extends StatefulWidget {
  @override
  _MenuSayfasiState createState() => _MenuSayfasiState();
}

class _MenuSayfasiState extends State<MenuSayfasi> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Functions.constScreeen(Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    Color.fromRGBO(38, 208, 124, 1.0),
                    Color.fromRGBO(6, 119, 226, 1)
                  ],
                  begin: FractionalOffset.centerLeft,
                  end: FractionalOffset.centerRight,
                )
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 58,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back,color: Color.fromRGBO(9,127,217,1,),), onPressed: () => Navigator.pop(context)),
                      SizedBox(width: 20,),
                      Text(
                        "Menü",
                        style: GoogleFonts.poppins(
                            color: Color.fromRGBO(9,127,217,1,),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                      icon: Icon(Icons.settings,color: Color.fromRGBO(9,127,217,1,),),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilDuzenleme()))),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade200,
            ),
            SizedBox(height: 10,),
            Container(
              width: screenSize.width/2.8+60,
              height: screenSize.width/2.8+60,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        width: screenSize.width/2.8,
                        height: screenSize.width/2.8,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    KullaniciBilgileri.ppUrl)
                            ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              offset: Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 50,
                        child: Column(
                          children: [
                            Text(KullaniciBilgileri.adSoyad,style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
                            Text("${KullaniciBilgileri.ilce},${KullaniciBilgileri.il}",style: GoogleFonts.poppins(fontSize: 15,color: Colors.black),),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25,),
            Material(
              child: InkWell(
                child:  Ink(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bildirimler",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color: Color.fromRGBO(115, 115, 115, 1)),),
                      Container(
                        height: 20,
                        width: 20,
                        
                        child: Icon(Icons.arrow_forward_ios,color: Color.fromRGBO(6, 119, 226, 1),size: 12,),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BildirimlerSayfasi())),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade200,
            ),
            Material(
              child: InkWell(
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bize Ulaş",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color: Color.fromRGBO(115, 115, 115, 1)),),
                      Container(
                        height: 20,
                        width: 20,
                        
                        child: Icon(Icons.arrow_forward_ios,color: Color.fromRGBO(6, 119, 226, 1),size: 12,),
                      ),
                    ],
                  ),
                ),
                onTap: () => _bizeUlas(),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade200,
            ),
            Material(
              child: InkWell(
                child:  Ink(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: 'Davet Et!\n',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color: Color.fromRGBO(6, 119, 226, 1)),),
                            TextSpan(text: 'Her arkadaşın için 10 Çevre Puanı kazan', style: GoogleFonts.poppins(color: Color.fromRGBO(115, 115, 115, 1),fontSize: 8,fontWeight: FontWeight.w600,)),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        child: Icon(Icons.arrow_forward_ios,color: Color.fromRGBO(6, 119, 226, 1),size: 12,),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DavetEtSayfasi())),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade200,
            ),
            Material(
              child: InkWell(
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Çıkış Yap",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color: Color.fromRGBO(115, 115, 115, 1)),),
                      Icon(Icons.login_outlined,color: Color.fromRGBO(237, 16, 16, 1),size: 25,),
                    ],
                  ),
                ),
                onTap: () => _logout(),
              ),
            )
          ],
        )), context);
  }


  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("mail","");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
          (Route<dynamic> route) => false,);
  }

  _bizeUlas() async {

    final MailOptions mailOptions = MailOptions(
      body: "",
      subject: "",
      recipients: ["destek@biriktir.app"],
      isHTML: false,
      // bccRecipients: ['other@example.com'],
      //ccRecipients: <String>['third@example.com'],
    );

    String platformResponse;
    try {
      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved:
          platformResponse = 'mail was saved to draft';
          break;
        case MailerResponse.sent:
          platformResponse = 'mail was sent';
          break;
        case MailerResponse.cancelled:
          platformResponse = 'mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'intent was success';
          break;
        default:
          platformResponse = 'unknown';
          break;
      }
    } on PlatformException catch (error) {
      platformResponse = error.toString();
      print(error);
      if (!mounted) {
        return;
      }
    } catch (error) {
      platformResponse = error.toString();
    }
    print(platformResponse);
  }
}
