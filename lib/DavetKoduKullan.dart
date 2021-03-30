import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:biriktir/Models/UserModel.dart';
import 'package:biriktir/Widgets/BilgilendirmePopUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'Models/CevrePuani.dart';
import 'Models/Constants.dart';
import 'Models/Functions.dart';
import 'Widgets/MyButtons.dart';

class DavetKoduKullanSayfasi extends StatefulWidget {
  @override
  _DavetKoduKullanSayfasiState createState() => _DavetKoduKullanSayfasiState();
}

class _DavetKoduKullanSayfasiState extends State<DavetKoduKullanSayfasi> {

  TextEditingController _davetKoduController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        "Davet Kodu Kullan",
                        style: GoogleFonts.poppins(
                            color: Color.fromRGBO(9,127,217,1,),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade200,
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: SvgPicture.asset("assets/pages/davetet.svg",height: 200,),
            ),
            SizedBox(height: 50,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(6, 119, 226, 1),width: 2),
                  borderRadius: BorderRadius.circular(15)
              ),
              width: MediaQuery.of(context).size.width/1.2,
              child: TextFormField(
                controller: _davetKoduController,
                textInputAction: TextInputAction.next,
                style: GoogleFonts.inter(),
                onFieldSubmitted: (v){
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Davet Kodu",
                  hintStyle: GoogleFonts.inter(),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Material(
                  child: InkWell(
                    child: MyButtons.biriktirBlueButton(MediaQuery.of(context).size.width/1.2,"Onayla"),
                    onTap: () {
                      _davetKoduKullan();
                    },
                  ),
                )
            ),
            SizedBox(height: 40,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text("Davet kodunu kullanarak 10 çevre puanı kazanabilirsin.",
                style: GoogleFonts.inter(fontSize: 15,color: Color.fromRGBO(65, 64, 64, 1)),textAlign: TextAlign.center,),
            )
          ],
        )), context);
  }

  _davetKoduKullan() async {
    if(KullaniciBilgileri.davetEtti){
      Toast.show(
          "Birden fazla davet kodu kullanamazsınız.",
          context,
          duration: 1,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      return;
    }
    if(_davetKoduController.text == KullaniciBilgileri.davetKodu){
      Toast.show(
          "Kendi davet kodunuzu kullanamazsınız.",
          context,
          duration: 1,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      return;
    }
    var response = await http.get("APIURL");
    var message = jsonDecode(response.body);
    if(message["hataMesaj"].toString().contains("Davet Kodu Geçersiz")){
      Toast.show(
          "Davet kodu geçersiz",
          context,
          duration: 1,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      return;
    }
    if(response.statusCode == 200){
      Toast.show(
          "Tebrikler siz ve arkadaşınız 10 Çevre Puanı kazandınız.",
          context,
          duration: 2,
          gravity: 1,
          backgroundColor: Colors.green.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      context.read<CevrePuani>().incDesc(10);
      KullaniciBilgileri.davetEtti = true;
      return;
    }else{
      showDialog(context: context,builder: (context) => BilgilendirmeDialog("Sistemsel bir hata oluştu. Biraz sonra tekrar deneyiniz"
          "Aynı hatayı almaya devam ederseniz bize ulaşabilirsiniz"));
    }

  }
}
