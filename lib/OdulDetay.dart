import 'dart:convert';

import 'package:biriktir/HomePage.dart';
import 'package:biriktir/Models/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'Models/CevrePuani.dart';
import 'Models/Constants.dart';

class OdulDetaySayfasi extends StatefulWidget {
  OdulModel odulModel;
  OdulDetaySayfasi(this.odulModel);
  @override
  _OdulDetaySayfasiState createState() => _OdulDetaySayfasiState();
}

class _OdulDetaySayfasiState extends State<OdulDetaySayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(image: NetworkImage(widget.odulModel.gorsel2),fit: BoxFit.fill),
                  ),
                  width: double.infinity,
                  height: 360,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,color: Colors.white,),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.odulModel.baslik,style: GoogleFonts.inter(fontSize: 40,fontWeight: FontWeight.w600,color: Color.fromRGBO(69, 79, 99, 1)),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(widget.odulModel.aciklama,textAlign: TextAlign.center,style: GoogleFonts.inter(fontSize: 15,fontWeight: FontWeight.w500,color: Color.fromRGBO(69, 79, 99, 1)),),
            ),
            SizedBox(height: 10,),
            Container(
              height: 2,
              width: double.infinity,
              color: Color.fromRGBO(227, 227, 227, 1),
            ),
            Container(
              height: 65,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.odulModel.magaza,style: GoogleFonts.inter(fontSize: 14,fontWeight: FontWeight.w700,color: Color.fromRGBO(69, 79, 99, 1)),),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: "Bitiş Tarihi: ",style: GoogleFonts.inter(fontSize: 14,fontWeight: FontWeight.w600,color: Color.fromRGBO(69, 79, 99, 1)),),
                        TextSpan(text: DateFormat('dd.MM.yyyy').format(widget.odulModel.gecTarihi),style: GoogleFonts.inter(fontSize: 14,color: Color.fromRGBO(69, 79, 99, 1)),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              width: double.infinity,
              color: Color.fromRGBO(227, 227, 227, 1),
            ),
            Container(
              height: 65,
              width: double.infinity,
              padding: EdgeInsets.only(left: 20,top: 10,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("${widget.odulModel.puan}",
                    style: GoogleFonts.poppins(
                        color: Color.fromRGBO(9,127,217,1,),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/buttons/yaprak.svg",
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                      child: InkWell(
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color.fromRGBO(6, 119, 227, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(90, 171, 248, 0.25),
                                  offset: Offset(0, 18),
                                  blurRadius: 42,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text("Ödülü Al",style: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15)),
                            )
                        ),
                        onTap: () {
                          if(Provider.of<CevrePuani>(context, listen: false).cevrePuani< widget.odulModel.puan)  {
                            Toast.show(
                                "Yetertsiz puan",
                                context,
                                duration: 1,
                                gravity: 1,
                                backgroundColor: Colors.red.shade600,
                                textColor: Colors.white,
                                backgroundRadius: 5
                            );
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              content: Text('Bu ödülü almayı onaylıyor musunuz?',style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.bold),),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Hayır',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _oduluAl();
                                  },
                                  child: Text('Evet',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  _oduluAl() async {
    if(Provider.of<CevrePuani>(context, listen: false).cevrePuani< widget.odulModel.puan)  {
      Toast.show(
          "Yetersiz puan",
          context,
          duration: 2,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      return;
    }
    showDialog(context: context,builder: (context) => Container(child: Lottie.asset("assets/loading_editor.json",),padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3.5 ),));
    var response = await http.get("APIURL");
    Navigator.pop(context);
    if(response.statusCode == 200){
      var odulDetay = jsonDecode(response.body);
      context.read<CevrePuani>().incDesc(-widget.odulModel.puan);
      showDialog(context: context,builder: (context) => _odulKodDialog(odulDetay["kod_odulKodu"]));
    }else if(response.statusCode == 400){
      var hataDetay = jsonDecode(response.body);
      if(hataDetay["hataMesaj"].toString().contains("Kod buluna")){
        Toast.show(
            "Malesef bu ödüle ait kuponlarımız tükendi",
            context,
            duration: 2,
            gravity: 1,
            backgroundColor: Colors.red.shade600,
            textColor: Colors.white,
            backgroundRadius: 5
        );
      }
    }else{
      Toast.show(
          "Bir hata oluştu",
          context,
          duration: 1,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
    }
    print(response.statusCode);
    print(response.body);
  }


  Widget _odulKodDialog(String odulKodu) {
    return Dialog(
      backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          height: 350,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text("Tebrikler!",style: GoogleFonts.poppins(fontSize: 27,fontWeight: FontWeight.w600,color: Color.fromRGBO(6, 119, 226, 1))),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20,right: 30,left: 30),
                child: Text("Çevre Puanlarını kullanarak indirim kazandın. Atıklarını geri dönüştürmeye devam ederek ödülleri kazanmaya devam et!!",textAlign: TextAlign.center,style: GoogleFonts.inter(fontSize: 14,color: Colors.black)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Text(odulKodu,style: GoogleFonts.poppins(fontSize: 35,fontWeight: FontWeight.bold,color: Color.fromRGBO(6, 119, 226, 1))),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 25),
                child: InkWell(
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color.fromRGBO(6, 119, 227, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(90, 171, 248, 0.25),
                            offset: Offset(0, 18),
                            blurRadius: 42,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text("Tamam",style: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15)),
                      )
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              )
            ],
          )
        )
    );
  }
}
