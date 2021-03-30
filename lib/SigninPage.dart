import 'Models/Functions.dart';
import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:biriktir/Widgets/SehirSecPopUp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:biriktir/HomePage.dart';
import 'package:biriktir/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'CreateAccPage.dart';
import 'Models/Constants.dart';
import 'Widgets/BilgilendirmePopUp.dart';
import 'Widgets/MyButtons.dart';
import 'package:provider/provider.dart';
import 'Models/CevrePuani.dart';



class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  FocusNode mailNode = new FocusNode();
  FocusNode passNode = new FocusNode();
  bool passwordVisible = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'profile',
      'email'
    ],
  );



  @override
  Widget build(BuildContext context) {
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
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              SizedBox(height: 30,),
              Container(
                child: SvgPicture.asset("assets/pages/Group1.svg",width: MediaQuery.of(context).size.width/3),
              ),
              SizedBox(height: 35,),
              Container(
                child: SvgPicture.asset("assets/pages/biriktir.svg"),
              ),
              SizedBox(height: 35,),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(6, 119, 226, 1),width: 2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      width: MediaQuery.of(context).size.width/1.3,
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
                      decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(6, 119, 226, 1),width: 2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      width: MediaQuery.of(context).size.width/1.3,
                      child: TextFormField(
                        controller: _passwordController,
                        focusNode: passNode,
                        obscureText: passwordVisible,
                        style: GoogleFonts.inter(),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Şifre",
                          hintStyle: GoogleFonts.inter(),
                          icon: Icon(Icons.lock_outline,color: Colors.black,),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Column(
                children: [
                  Material(
                    child: InkWell(
                      child : MyButtons.biriktirgradientButton(MediaQuery.of(context).size.width/1.3,"Giriş Yap"),
                      onTap: () {
                        _signIn();
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Material(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                          child: MyButtons.googleLoginButton(MediaQuery.of(context).size.width/1.3),
                          onTap: () {
                            _handleSignIn();
                          },
                        )
                    ),
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Henüz bir hesabın yok mu? ', style: GoogleFonts.inter(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500)),
                          TextSpan(text: 'Kayıt ol', style: GoogleFonts.inter(color: Color.fromRGBO(6, 119, 226, 1),fontSize: 14,fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccPage()));
                    },
                  ),
                  SizedBox(height: 30,),
                ],
              )
            ],
          ),
        )
    ), context);
  }



  void _ozelRegister(String kullaniciAdSoyad,String kullaniciMail) async {
    var body = jsonEncode({
      "kullanici_adSoyad" : kullaniciAdSoyad,
      "kullanici_mail" : kullaniciMail.toLowerCase().split(" ").map((str) => StringUtils.capitalize(str)).join(" ")
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

    if (response.statusCode == 201 || response.statusCode == 400) {
      print(response.statusCode);
      FocusScope.of(context).requestFocus(new FocusNode());
      _ozelSignIn(kullaniciMail);
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
  void _ozelSignIn(String kullaniciMail) async {
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
      KullaniciBilgileri.ppUrl = kullanici["kullanici_ppName"] != null ? Constants.generaPpUrl+kullanici["kullanici_ppName"] : Constants.noPpUrl;
      KullaniciBilgileri.ilceId = kullanici["kullanici_ilceId"];
      KullaniciBilgileri.id = kullanici["kullanici_id"];
      KullaniciBilgileri.mail = kullanici["kullanici_mail"];
      KullaniciBilgileri.davetEtti = kullanici["kullanici_davetEtti"] == 1 ? true : false;
      KullaniciBilgileri.davetKodu = kullanici["kullanici_davetKodu"];
      context.read<CevrePuani>().equals(int.parse(kullanici["kullanici_toplamKazandigi"].toString()) - int.parse(kullanici["kullanici_toplamHarcadigi"].toString()));
      KullaniciBilgileri.co2Puani = double.parse(kullanici["kullanici_co2Puani"].toString());
      KullaniciBilgileri.gunlukPuan = int.parse(kullanici["gunluk_puan"].toString());
      KullaniciBilgileri.tel = kullanici["kullanici_tel"].toString();
      KullaniciBilgileri.sifre = _passwordController.text;
      print(KullaniciBilgileri.il);
      prefs.setString("mail", KullaniciBilgileri.mail);
      prefs.setString("pass", _passwordController.text);
      prefs.setBool("ozelMi", true);
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
  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.signOut();
      _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
        GoogleSignInAuthentication auth = await acc.authentication;
        print(acc.id);
        print(acc.email);
        print(acc.displayName);
        print(acc.photoUrl);

        acc.authentication.then((GoogleSignInAuthentication auth) async {
          print(auth.idToken);
          print(auth.accessToken);
        });
        _ozelRegister(acc.displayName,acc.email);
      });
    } catch (error) {
      print(error);
    }
  }
  void _signIn() async {
    if(_emailController.text.isEmpty ||_passwordController.text.isEmpty){
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
    showDialog(context: context,builder: (context) => Container(child: lottie.Lottie.asset("assets/loading_editor.json",),padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3.5 ),));
    String md5Sifre = generateMd5(_passwordController.text.trimRight());
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
          "E-posta veya şifre yanlış",
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
}
