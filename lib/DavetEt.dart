import 'package:biriktir/DavetKoduKullan.dart';
import 'package:biriktir/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

import 'Models/Functions.dart';
import 'Widgets/MyButtons.dart';

class DavetEtSayfasi extends StatefulWidget {
  @override
  _DavetEtSayfasiState createState() => _DavetEtSayfasiState();
}

class _DavetEtSayfasiState extends State<DavetEtSayfasi> {
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
                        "Davet Et",
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
            SizedBox(height: 25,),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Text("Arkadaşlarınla davet kodunu paylaş, ülkemizdeki geri dönüşüm alışkanlığını artırmak için destek ver çevren kazanırken sen de kazan!",
                        style: GoogleFonts.inter(fontSize: 15,color: Color.fromRGBO(65, 64, 64, 1)),textAlign: TextAlign.center,),
                      SizedBox(height: 25,),
                      Text("Biriktir'e gelen her arkadaşın için 10 çevre puanı kazanırsın.",
                        style: GoogleFonts.inter(fontSize: 15,color: Color.fromRGBO(65, 64, 64, 1)),textAlign: TextAlign.center,)
                    ],
                  ),
                )
            ),
            SizedBox(height: 20,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Material(
                  child: InkWell(
                    child: MyButtons.biriktirBlueButton(MediaQuery.of(context).size.width,"Davet Et"),
                    onTap: () {
                      _onShare(context, "https://biriktir.app/davet.php?davetKodu=${KullaniciBilgileri.davetKodu}");
                    },
                  ),
                )
            ),
            SizedBox(height: 10,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Material(
                  child: InkWell(
                    child: Ink(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Color.fromRGBO(10, 130, 214, 1),width: 2),
                            color: Color.fromRGBO(242, 249, 255, 1)
                        ),
                        child: Center(child: Text("Davet Kodu Kullan",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),)
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DavetKoduKullanSayfasi())),
                  ),
                )
            ),
            SizedBox(height: 30,),
          ],
        )), context);
  }

  _onShare(BuildContext context,String url) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(url,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
