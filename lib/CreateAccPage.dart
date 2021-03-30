import 'package:provider/provider.dart';
import 'Models/CevrePuani.dart';
import 'Models/Functions.dart';
import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:biriktir/Models/Constants.dart';
import 'package:biriktir/SigninPage.dart';
import 'package:biriktir/Widgets/BilgilendirmePopUp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'HomePage.dart';
import 'Models/UserModel.dart';
import 'Widgets/MyButtons.dart';
import 'Widgets/SehirSecPopUp.dart';

class CreateAccPage extends StatefulWidget {
  String adSoyad = "",ePosta = "";
  CreateAccPage({this.adSoyad,this.ePosta});
  @override
  _CreateAccPageState createState() => _CreateAccPageState();
}

class _CreateAccPageState extends State<CreateAccPage> {


  bool passwordVisible = true;

  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode nameNode = new FocusNode();
  FocusNode mailNode = new FocusNode();
  FocusNode passNode = new FocusNode();
  
  
  List<DropdownMenuItem<IlModel>> _ilDropdownMenuItems;
  List<DropdownMenuItem<IlceModel>> _ilceDropdownMenuItems;
  List<IlModel> _ilList = [];
  List<IlceModel> _ilceList = [];
  IlModel _ilSelectedItem;
  IlceModel _ilceSelectedItem;

  var phoneFormatter = new MaskTextInputFormatter(mask: '# (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _illeriGetir();
  }
  @override
  Widget build(BuildContext context) {
    _nameSurnameController.text = widget.adSoyad;
    _emailController.text = widget.ePosta;
    return Functions.constScreeen(Scaffold(
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
        body:  Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5,top: 5),
                child: Align(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  alignment: Alignment.topLeft,)
              ),
              Container(
                child: SvgPicture.asset("assets/pages/Group1.svg",width: MediaQuery.of(context).size.width/3),
              ),
              SizedBox(height: 15,),
              Container(
                child: SvgPicture.asset("assets/pages/biriktir.svg",width: MediaQuery.of(context).size.width/3),
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(6, 119, 226, 1),width: 2),
                    borderRadius: BorderRadius.circular(15)
                ),
                width: MediaQuery.of(context).size.width/1.2,
                child: TextFormField(
                  controller: _nameSurnameController,
                  focusNode: nameNode,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.inter(),
                  onFieldSubmitted: (v){
                    nameNode.unfocus();
                    FocusScope.of(context).requestFocus(mailNode);
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Ad-Soyad",
                      hintStyle: GoogleFonts.inter(),
                      icon: Icon(Icons.person_outline,color: Colors.black,)
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(6, 119, 226, 1),width: 2),
                    borderRadius: BorderRadius.circular(15)
                ),
                width: MediaQuery.of(context).size.width/1.2,
                child: TextFormField(
                  controller: _emailController,
                  focusNode: mailNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.inter(),
                  onFieldSubmitted: (v){
                    mailNode.unfocus();
                    FocusScope.of(context).requestFocus(passNode);
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "E-Posta",
                      hintStyle: GoogleFonts.inter(),
                      icon: Icon(Icons.mail_outline,color: Colors.black,)
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(6, 119, 226, 1),width: 2),
                    borderRadius: BorderRadius.circular(15)
                ),
                width: MediaQuery.of(context).size.width/1.2,
                child: TextFormField(
                  controller: _passwordController,
                  focusNode: passNode,
                  obscureText: passwordVisible,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.inter(),
                  onFieldSubmitted: (v){
                    passNode.unfocus();
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Şifre",
                      hintStyle: GoogleFonts.inter(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue.shade900
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      icon: Icon(Icons.lock_outline,color: Colors.black,)
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                width: MediaQuery.of(context).size.width/1.2,
                child: DropdownButton<IlModel>(
                  value: _ilSelectedItem,
                  style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w500),
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
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                width: MediaQuery.of(context).size.width/1.2,
                child: DropdownButton<IlceModel>(
                  value: _ilceSelectedItem,
                  style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w500),
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
              SizedBox(height: 5,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
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
                      TextSpan(text: ' ve ', style: GoogleFonts.poppins(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w500)),
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
              SizedBox(height: 15,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                child: Material(
                  child: InkWell(
                    child: MyButtons.biriktirgradientButton(MediaQuery.of(context).size.width/1.2,"Kayıt Ol"),
                    onTap: ()  {
                      _register();
                    },
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        )
    ), context);
  }
  void _register() async {
    if(_nameSurnameController.text.isEmpty || _emailController.text.isEmpty ||_passwordController.text.isEmpty){
      Toast.show(
          "Lütfen tüm alanları doldurduğunuzdan emin olun.",
          context,
          duration: 1,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      return;
    }
    if(_passwordController.text.length < 7){
      showDialog(
          context: context,
          builder: (context) => BilgilendirmeDialog("Şifreniz en az 7 haneli olmak zorunda"));
      return;
    }
    String kullaniciAdSoyad = _nameSurnameController.text.toLowerCase().split(" ").map((str) => StringUtils.capitalize(str)).join(" ");
    var body = jsonEncode({
      "kullanici_adSoyad" : kullaniciAdSoyad,
      "kullanici_mail" : _emailController.text,
      "kullanici_sifre" : generateMd5(_passwordController.text),
      "kullanici_ilceId" : _ilceSelectedItem.ilceId,
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    showDialog(context: context,builder: (context) => Container(child: lottie.Lottie.asset("assets/loading_editor.json",),padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3.5 ),));
    var response = await http.post(
        "APIURL",
        headers: {
          'Content-Type': 'application/json'
        },
        body: body
    );

    if (response.statusCode == 201) {

      FocusScope.of(context).requestFocus(new FocusNode());
      Toast.show(
          "Kaydınız başarıyla gerçekleşti. Giriş yapılıyor.",
          context,
          duration: 2,
          gravity: 0,
          backgroundColor: Colors.green.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      _signIn(_emailController.text, _passwordController.text);
    }
    else {
      var data = json.decode(response.body);
      FocusScope.of(context).requestFocus(new FocusNode());
      Navigator.pop(context);
      Toast.show(
          data["hataMesaj"],
          context,
          duration: 2,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 8
      );
    }



  }


  void _signIn(String mail,String password) async {
    String md5Sifre = generateMd5(password.trimRight());
    var response = await http.get(
      "APIURL",
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var kullanici = jsonDecode(response.body);
      KullaniciBilgileri.adSoyad = kullanici["kullanici_adSoyad"];
      KullaniciBilgileri.cinsiyet = kullanici["kullanici_cinsiyet"];
      KullaniciBilgileri.dogumTarihi = kullanici["kullanici_dogumTarihi"];
      KullaniciBilgileri.ilce = kullanici["kullanici_ilce"];
      KullaniciBilgileri.il = kullanici["kullanici_il"];
      KullaniciBilgileri.ilceId = kullanici["kullanici_ilceId"];
      KullaniciBilgileri.id = kullanici["kullanici_id"];
      KullaniciBilgileri.mail = kullanici["kullanici_mail"];
      KullaniciBilgileri.davetEtti = kullanici["kullanici_davetEtti"] == 1 ? true : false;
      KullaniciBilgileri.davetKodu = kullanici["kullanici_davetKodu"];
      KullaniciBilgileri.ppUrl = kullanici["kullanici_ppName"] != null ? Constants.generaPpUrl+kullanici["kullanici_ppName"] : Constants.noPpUrl;
      context.read<CevrePuani>().equals(int.parse(kullanici["kullanici_toplamKazandigi"].toString()) - int.parse(kullanici["kullanici_toplamHarcadigi"].toString()));
      KullaniciBilgileri.co2Puani = double.parse(kullanici["kullanici_co2Puani"].toString());
      KullaniciBilgileri.gunlukPuan = int.parse(kullanici["gunluk_puan"].toString());
      KullaniciBilgileri.tel = kullanici["kullanici_tel"].toString();
      KullaniciBilgileri.sifre = _passwordController.text;
      print(KullaniciBilgileri.il);
      prefs.setString("mail", KullaniciBilgileri.mail);
      prefs.setString("pass", _passwordController.text);
      prefs.setBool("ozelMi", false);
      Functions.fbTokenGuncelle();
      if(KullaniciBilgileri.ilce == null || KullaniciBilgileri.il == null || KullaniciBilgileri.ilceId == null){
        Navigator.pop(context);
        showDialog(context: context,builder: (context) => SehirSecDialog(KullaniciBilgileri.id),barrierDismissible: false);
        return;
      }
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    else {
      FocusScope.of(context).requestFocus(new FocusNode());
      Navigator.pop(context);
      Toast.show(
          "Bir hata oluştu",
          context,
          duration: 2,
          gravity: 0,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
    }



  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
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


class IlModel{
  int ilId;
  String ilTitle;
  IlModel(this.ilId,this.ilTitle);
}

class IlceModel{
  int ilceId;
  int ilceIlId;
  String ilceTitle;
  IlceModel(this.ilceId,this.ilceIlId,this.ilceTitle);
}