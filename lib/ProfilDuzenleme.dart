import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:biriktir/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'Models/Constants.dart';
import 'Models/Functions.dart';
import 'Widgets/MyButtons.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' as lottie;

import 'Widgets/MenuButton.dart';

class ProfilDuzenleme extends StatefulWidget {
  @override
  _ProfilDuzenlemeState createState() => _ProfilDuzenlemeState();
}

class _ProfilDuzenlemeState extends State<ProfilDuzenleme> {
  final TextEditingController _nameSurnameController = TextEditingController(text: KullaniciBilgileri.adSoyad);
  final TextEditingController _emailController = TextEditingController(text: KullaniciBilgileri.mail);
  final TextEditingController _phoneController = TextEditingController(text: KullaniciBilgileri.tel == "null" ? "" : KullaniciBilgileri.tel);
  DateTime now = DateTime.now();
  bool birthdayOk =false;
  String birthDay = KullaniciBilgileri.dogumTarihi;
  FocusNode nameNode = new FocusNode();
  FocusNode mailNode = new FocusNode();
  FocusNode passNode = new FocusNode();
  FocusNode phoneNode = new FocusNode();
  var phoneFormatter = new MaskTextInputFormatter(mask: '# (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });


  String selectedKey = KullaniciBilgileri.cinsiyet == null ? "Cinsiyet" : KullaniciBilgileri.cinsiyet;

  List<String> keys = <String>[
    'Erkek',
    'Kadın',
  ];




  File imageFile;
  String base64Image;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
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
        body: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 70),
              child: ListView(
                children: [
                  SizedBox(height: 20,),
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
                                color: Colors.white,
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
                                  InkWell(
                                    child: Text("Profil fotoğrafını değiştir",style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 15,color: Color.fromRGBO(6, 119, 227, 1),),),
                                    onTap: () {
                                      showDialog(context: context,builder: (context) => Container(child: lottie.Lottie.asset("assets/loading_editor.json",),padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3.5 ),));
                                      imageSelector(context);
                                    },
                                  ),
                                  Text("${KullaniciBilgileri.ilce},${KullaniciBilgileri.il}",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(89, 173, 255, 1),width: 2),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 25),
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
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(89, 173, 255, 1),width: 2),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      focusNode: mailNode,
                      readOnly: true,
                      style: GoogleFonts.inter(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "E-Posta",
                          hintStyle: GoogleFonts.inter(),
                          icon: Icon(Icons.mail_outline,color: Colors.black,)
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color.fromRGBO(89, 173, 255, 1),width: 2),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          width: (MediaQuery.of(context).size.width)/2 -28,
                          height: 54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset("assets/pages/calenderIcon.svg"),
                              birthDay == null ? Text("Doğum Tarihi",style: GoogleFonts.inter()) : Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(birthDay)),style: GoogleFonts.inter()),
                            ],
                          ),
                        ),
                        onTap: () {
                          callDatePicker();
                        },
                      ),
                      SizedBox(width: 5,),
                      MenuButton<String>(
                        menuButtonBackgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color.fromRGBO(89, 173, 255, 1),width: 2),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          width: (MediaQuery.of(context).size.width)/2 -28,
                          height: 54,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 11),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                    child: Text(selectedKey,style: GoogleFonts.inter(), overflow: TextOverflow.ellipsis)
                                ),
                                const SizedBox(
                                  width: 12,
                                  height: 17,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        items: keys,
                        itemBuilder: (String value) => Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
                          child: Text(value,style: GoogleFonts.inter(),),
                        ),
                        toggledChild: Container(

                        ),
                        divider: Container(
                          height: 1,
                          color: Colors.grey.shade200,
                        ),
                        onItemSelected: (String value) {
                          setState(() {
                            selectedKey = value;
                            FocusScope.of(context).requestFocus(new FocusNode());
                          });
                        },
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(3.0))
                        ),
                        onMenuButtonToggle: (bool isToggle) {
                          print(isToggle);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(89, 173, 255, 1),width: 2),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _phoneController,
                      textInputAction: TextInputAction.done,
                      focusNode: phoneNode,
                      style: GoogleFonts.inter(),
                      inputFormatters: [
                        phoneFormatter,
                        FilteringTextInputFormatter.allow(RegExp("[0-9() -]"))
                      ],
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Cep No",
                          hintStyle: GoogleFonts.inter(),
                          icon: Icon(Icons.phone_android_outlined,color: Colors.black,)
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        child: InkWell(
                          child: MyButtons.biriktirBlueButton(screenSize.width,"Kaydet"),
                          onTap: () {
                            _updateProfile();
                          },
                        ),
                      )
                  ),
                ],
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
                                "Ayarlar",
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
        )), context);
  }


  Future<DateTime> getDate() {
    return showDatePicker(
      locale: Locale('tr',''),
      helpText: "DOĞUM TARİHİNİZİ SEÇİNİZ",
      confirmText: "TAMAM",
      cancelText: "İPTAL",
      context: context,
      initialDate: KullaniciBilgileri.dogumTarihi != null ? DateTime.parse(KullaniciBilgileri.dogumTarihi) : now,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.from(colorScheme: ColorScheme.light(background: Colors.white,onSurface: Colors.black,primary: Color.fromRGBO(38, 208, 124, 1),)),
          child: child,
        );
      },
    );
  }
  void callDatePicker() async {
    var order = await getDate();
    if(order != null){
      setState(() {
        FocusScope.of(context).requestFocus(new FocusNode());
        now = order;
        birthdayOk = true;
        birthDay = DateFormat('yyy-MM-dd').format(order);
      });
    }
  }



  Future imageSelector(BuildContext context) async {
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);


    if (imageFile != null) {

      _cropImage(imageFile.path);
    } else {
      print("You have not taken image");
    }
  }

  startUpload(String fileName) {

    fileName = fileName.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {

    String ppName = "${KullaniciBilgileri.id}-${KullaniciBilgileri.adSoyad.replaceAll(" ", "")}-$fileName";
    http.post("APIURL", body: {
      "kullaniciId" : KullaniciBilgileri.id.toString(),
      "image": base64Image,
      "name": ppName,
    }).then((result) {
      if(result.statusCode == 200){
        setState(() {
          KullaniciBilgileri.ppUrl = Constants.generaPpUrl+ppName;
        });
      }
      print(result.body);
    }).catchError((error) {
      print(error);
    });
    Navigator.pop(context);
  }

  Future<void> _cropImage(String imagePath) async {
    final croppedPhoto = await ImageCropper.cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 80,
      maxHeight: 700,
      maxWidth: 700,
      cropStyle: CropStyle.circle,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: "Fotoğrafı Kırp",
      ),
      iosUiSettings: IOSUiSettings(
        title: "Fotoğrafı Kırp",
      ),
    );
    imageFile?.delete();
    base64Image = base64Encode(croppedPhoto.readAsBytesSync());

    startUpload(croppedPhoto.path);
  }

  void _updateProfile() async {
    if(_nameSurnameController.text.isEmpty || _phoneController.text.isEmpty){
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
    if(selectedKey != "Erkek" && selectedKey != "Kadın"){
      Toast.show(
          "Lütfen cinsiyetinizi seçiniz.",
          context,
          duration: 1,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      return;
    }
    if(birthDay == null){
      Toast.show(
          "Lütfen doğum tarihinizi seçiniz.",
          context,
          duration: 1,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      return;
    }
    String kullaniciAdSoyad = _nameSurnameController.text.toLowerCase().split(" ").map((str) => StringUtils.capitalize(str)).join(" ");

    var body = jsonEncode({
      "kullaniciAdSoyad" : kullaniciAdSoyad,
      "kullaniciCinsiyet" : selectedKey,
      "kullaniciDogumTarihi" : birthDay,
      "kullaniciCepNo" : _phoneController.text.replaceAll("(","").replaceAll(")","").replaceAll("-","").replaceAll(" ",""),
      "kullaniciId" : KullaniciBilgileri.id
    });
    print(body);
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
      Navigator.pop(context);
      Toast.show(
          "Bilgilerinizi başarıyla değiştirdiniz.",
          context,
          duration: 2,
          gravity: 1,
          backgroundColor: Colors.green.shade600,
          textColor: Colors.white,
          backgroundRadius: 5
      );
      KullaniciBilgileri.cinsiyet = selectedKey;
      KullaniciBilgileri.dogumTarihi = birthDay;
      KullaniciBilgileri.adSoyad = kullaniciAdSoyad;
    }
    else {
      print(response.body);
      print(response.statusCode);
      FocusScope.of(context).requestFocus(new FocusNode());
      Navigator.pop(context);
      Toast.show(
          "Sistem Hatası",
          context,
          duration: 2,
          gravity: 1,
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          backgroundRadius: 8
      );
    }



  }

}
