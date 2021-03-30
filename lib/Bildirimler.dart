import 'dart:convert';

import 'package:biriktir/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'Models/Constants.dart';


List<Bildirimler> bildirimlerList = [];
class BildirimlerSayfasi extends StatefulWidget {
  @override
  _BildirimlerSayfasiState createState() => _BildirimlerSayfasiState();
}

class _BildirimlerSayfasiState extends State<BildirimlerSayfasi> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bildirimGetir();
  }
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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 70),
            child: SingleChildScrollView(
              child: Column(
                  children: List.generate(bildirimlerList.length, (index) {
                    return Column(
                      children: [
                        Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width-5,
                                    height: 105,
                                    color:  bildirimlerList[index].okunduMu ? Colors.white : Color.fromRGBO(6, 119, 226, 0.06),
                                    child: InkWell(
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 14,left: 35,right: 35,bottom: 14),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(child: Row(
                                                children: [
                                                  SvgPicture.asset("assets/pages/Group1.svg",width: 25,),
                                                  SizedBox(width: 10,),
                                                  Expanded(child:  Text(bildirimlerList[index].body,maxLines: 3,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 12,color: Color.fromRGBO(67, 79, 99, 1)),),)
                                                ],
                                              ),),
                                              Padding(
                                                padding: EdgeInsets.only(left: 35,right: 35),
                                                child: Text(bildirimlerList[index].tarihi,style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w500),),
                                              )
                                            ],
                                          ),
                                      ),
                                      onTap: () {
                                        showDialog(context: context,builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          title: Text(bildirimlerList[index].title,style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
                                          content: Text(bildirimlerList[index].body,style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500)),
                                          actions: [
                                            FlatButton(
                                              child: Text("Tamam",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600),),
                                              onPressed: () => Navigator.pop(context),
                                            )
                                          ],
                                        ));
                                        setState(() {
                                          _bildirimUpdate(bildirimlerList[index].id,index,false);
                                        });
                                      },
                                    )
                                ),
                                Container(width: 2,height: 100,color: bildirimlerList[index].okunduMu ? Colors.white : Color.fromRGBO(6, 119, 226, 1),)
                              ],
                            ),
                            secondaryActions: slidable(bildirimlerList[index].okunduMu, index)
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                        ),
                      ],
                    );
                  })),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Column(
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
                              "Bildirimler",
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
                ],
              )
          ),
        ],
      )
    );
  }

  List<Widget> slidable(bool okunduMu,int index){
    List<Widget> slidableList = [];
    if(!okunduMu){
      slidableList= [
        IconSlideAction(
            caption: 'Okundu',
            color: Color.fromRGBO(6, 119, 226, 1),
            icon: Icons.beenhere,
            foregroundColor: Colors.white,
            onTap: () {
              _bildirimUpdate(bildirimlerList[index].id,index,false);
            }
        ),
        IconSlideAction(
            caption: 'Sil',
            color: Color.fromRGBO(38, 208, 124, 1),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            onTap: () {
              _bildirimUpdate(bildirimlerList[index].id,index,true);
            }
        ),
      ];
    }else{
      slidableList= [
        IconSlideAction(
            caption: 'Sil',
            color: Color.fromRGBO(38, 208, 124, 1),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            onTap: () {
              _bildirimUpdate(bildirimlerList[index].id,index,true);
            }
        ),
      ];
    }
    return slidableList;
  }
  
  _bildirimGetir() async {
    var response = await http.get("APIURL");
    
    var bildirimler = jsonDecode(response.body);
    bildirimlerList.clear();
    for(var bildirim in bildirimler){
      String bildirimTarihi = new DateFormat.yMMMMd('tr').format(DateTime.parse(bildirim["bildirim_tarih"].toString()));
      bildirimlerList.add(Bildirimler(bildirim["rlbk_id"], bildirim["bildirim_title"], bildirim["bildirim_body"], bildirim["rlbk_okundu"] == 1 ? true : false, bildirimTarihi));
    }
    setState(() {

    });
    
  }


  _bildirimUpdate(int id,int index,bool silindiMi) async{
    var body = jsonEncode({
      "rlbkId": id,
      "silindiMi": silindiMi ? "yes" : "no",
    });
    var response = await http.post("APIURL",
        headers: {
          'Content-Type': 'application/json'
        },
        body: body);
    print(response.statusCode);
    if(response.statusCode == 200){
      if(silindiMi){
        setState(() {
          bildirimlerList.removeAt(index);
        });
      }else{
        setState(() {
          bildirimlerList[index].okunduMu = true;
        });
      }
    }else{
      if(silindiMi){
        showDialog(context: context,builder: (context)=> AlertDialog(
          title: Text("Hata!"),
          content: Text("Bildirimi silerken sorun oluştu"),
        ));
      }
    }

  }

  _fbTokenGuncelle() async{
    var body = jsonEncode({
      "kullaniciId": KullaniciBilgileri.id,
      "fbToken": "",
    });
    var response = await http.post("${Constants.apiUrl}?apiPage=fbtoken",
        headers: {
          'Content-Type': 'application/json'
        },
        body: body);
    print(response.statusCode);

  }
}


class Bildirimler{

  int id;
  String title;
  String body;
  String tarihi;
  bool okunduMu;

  Bildirimler(this.id,this.title,this.body,this.okunduMu,this.tarihi);
}