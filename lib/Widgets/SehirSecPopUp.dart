import 'dart:convert';

import 'package:biriktir/Models/Constants.dart';
import 'package:biriktir/Models/UserModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../CreateAccPage.dart';
import '../HomePage.dart';

class SehirSecDialog extends StatefulWidget {
  int kullaniciId;
  SehirSecDialog(this.kullaniciId);
  @override
  _SehirSecDialogState createState() => _SehirSecDialogState();
}

class _SehirSecDialogState extends State<SehirSecDialog> {

  List<DropdownMenuItem<IlModel>> _ilDropdownMenuItems;
  List<DropdownMenuItem<IlceModel>> _ilceDropdownMenuItems;
  List<IlModel> _ilList = [];
  List<IlceModel> _ilceList = [];
  IlModel _ilSelectedItem;
  IlceModel _ilceSelectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _illeriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10),
          child: Container(
            height: 280,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text("Yaşadığınız Şehir ve İlçe",
                    style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15),
                    textAlign: TextAlign.center,),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: MediaQuery.of(context).size.width/1.2,
                  child: DropdownButton<IlModel>(
                    value: _ilSelectedItem,
                    style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600),
                    isExpanded: true,
                    items: _ilDropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        _ilSelectedItem = value;
                        _ilceleriGetir(_ilSelectedItem.ilId);
                      });
                    },
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromRGBO(6, 119, 226, 1),width: 2),
                      borderRadius: BorderRadius.circular(15)
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: MediaQuery.of(context).size.width/1.2,
                  child: DropdownButton<IlceModel>(
                    value: _ilceSelectedItem,
                    style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600),
                    isExpanded: true,
                    items: _ilceDropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        _ilceSelectedItem = value;
                      });
                    },
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromRGBO(6, 119, 226, 1),width: 2),
                      borderRadius: BorderRadius.circular(15)
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Kayıt olarak ', style: GoogleFonts.inter(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: 'Kullanım koşulları',
                            style: GoogleFonts.inter(color: Color.fromRGBO(6, 119, 226, 1),fontSize: 11,fontWeight: FontWeight.w500),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              print("Kullanım");
                            }
                        ),
                        TextSpan(text: ' ve ', style: GoogleFonts.inter(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: 'Aydınlatma Metnini',
                            style: GoogleFonts.inter(color: Color.fromRGBO(6, 119, 226, 1),fontSize: 11,fontWeight: FontWeight.w500),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              print("Kullanım");
                            }
                        ),
                        TextSpan(text: ' kabul ediyorum.', style: GoogleFonts.inter(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w500)),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 45,
                    width: MediaQuery.of(context).size.width/1.2,
                    child: Center(
                      child: Text("TAMAM",style: GoogleFonts.poppins(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(6, 119, 226, 1)
                    ),
                  ),
                  onTap: () {
                    _ilceDuzenle(widget.kullaniciId,_ilceSelectedItem.ilceId);
                    KullaniciBilgileri.ilce = _ilceSelectedItem.ilceTitle;
                    KullaniciBilgileri.il = _ilSelectedItem.ilTitle;
                    KullaniciBilgileri.ilceId = _ilceSelectedItem.ilceId;
                  },
                )
              ],
            ),
          ),
        ));
  }

  _ilceDuzenle(int kullaniciId,int ilceId) async {
    var body = jsonEncode({
      "ilceId" : ilceId,
      "kullaniciId" : kullaniciId
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    var response = await http.post(
        "APIURL",
        headers: {
          'Content-Type': 'application/json'
        },
        body: body
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  _illeriGetir() async {
    var response = await http.get(
        "APIURL"
    );
    var responseIller = jsonDecode(response.body);
    for(var il in responseIller){
      _ilList.add(IlModel(il["il_id"], il["il_title"]));
    }
    setState(() {
      _ilDropdownMenuItems = buildDropDownMenuItems(_ilList);
      _ilSelectedItem = _ilDropdownMenuItems[0].value;
      _ilceleriGetir(_ilSelectedItem.ilId);
    });
  }

  _ilceleriGetir(int ilId) async {
    var response = await http.get(
        "APIURL"
    );
    var responseIlceler = jsonDecode(response.body);
    for(var ilce in responseIlceler){
      _ilceList.add(IlceModel(ilce["ilce_id"], ilce["ilce_ilId"],ilce["ilce_title"]));
    }
    setState(() {
      _ilceDropdownMenuItems = buildDropDownMenuItems2(_ilceList);
      _ilceSelectedItem = _ilceDropdownMenuItems[0].value;
    });
  }

  List<DropdownMenuItem<IlModel>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<IlModel>> items = List();
    for (IlModel listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.ilTitle),
          value: listItem,
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<IlceModel>> buildDropDownMenuItems2(List listItems) {
    List<DropdownMenuItem<IlceModel>> items = List();
    for (IlceModel listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.ilceTitle),
          value: listItem,
        ),
      );
    }
    return items;
  }
}

