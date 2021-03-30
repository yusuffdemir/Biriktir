import 'package:biriktir/OdulDetay.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'Models/CevrePuani.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'Models/Functions.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:basic_utils/basic_utils.dart';
import 'package:biriktir/Menu.dart';
import 'package:biriktir/Models/Constants.dart';
import 'package:biriktir/Models/UserModel.dart';
import 'package:biriktir/ResultPointPage.dart';
import 'package:biriktir/Widgets/MarkerInfoPopUp.dart';
import 'package:biriktir/Widgets/my_flutter_app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'Widgets/MaksPuanPopUp.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {


  PolylinePoints polylinePoints;

  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  List<Marker> allMarkers = [];
  List<LatLng> polylineCoordinates = [];
  List<IlceSkorModel> ilceSkorList = [];
  List<KullaniciSkorModel> kullaniciSkorList = [];
  List<OdulModel> odullerList = [];
  List<OdullerimModel> odullerimList = [];

  Map<PolylineId, Polyline> polylines = {};


  BitmapDescriptor myIcon;
  Uint8List markerIcon;


  LatLng latLng;
  LatLng curLatLng;
  LatLng desLatLng;
  LatLng destination;


  CameraPosition cameraPosition;


  bool isGoing = false;
  bool odulKazandiMi = false;
  bool isTouchedScreen = false;
  bool isLoadAd = false;


  StreamSubscription positionStream;
  StreamSubscription positionCameraStream;

  String adress;
  String deneme = "";
  String distance = "";
  String appbarTitle = "Anasayfa";
  String distanceTime = "";
  String anasayfaYazisi = "";

  int pageIndex = 0;
  int test = 1;



  File imageFile;
  String base64Image;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    anasayfaYaziGetir();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed || state == AppLifecycleState.paused) {
      _controller.setMapStyle("[]");
    }
  }



  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<CevrePuani>(context);
    var screenSize = MediaQuery.of(context).size;
    cameraPosition = CameraPosition(
        bearing: 0,
        target: LatLng(40.967658401788,29.084511995316),
        tilt: 0,
        zoom: 10);
    List<Widget> sayfalar = [_anaSayfa(),haritaSayfasi(),_odullerSayfasi(),_skorSayfasi()];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Functions.constScreeen(Scaffold(
        backgroundColor: Colors.white,
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
            sayfalar[pageIndex],
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 60,
                width: screenSize.width,
                color: pageIndex != 1 ? Colors.white : Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                            child: Icon(Icons.menu,color: Color.fromRGBO(6, 119, 226, 1),size: 25,),
                            height: 33,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white
                            ),
                          ),
                          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => MenuSayfasi())),
                        ),
                        SizedBox(width: 20,),
                        Visibility(
                          child: Text(
                          appbarTitle,
                            style: GoogleFonts.poppins(
                                color: Color.fromRGBO(9,127,217,1,),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          visible: pageIndex == 1 ? false : true,
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      height: 30,
                      width: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${context.watch<CevrePuani>().cevrePuani}",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                                color: Color.fromRGBO(9,127,217,1,),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 2,),
                          SvgPicture.asset("assets/buttons/yaprak.svg",)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:  Container(
          padding: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
              child: GNav(
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                gap: 8,
                selectedIndex: pageIndex,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 700),
                tabBackgroundColor: Colors.grey[100],
                onTabChange: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                  _setPages(index);
                },
                tabs: [
                  GButton(
                    backgroundGradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(38, 208, 124, 1.0),
                        Color.fromRGBO(6, 119, 226, 1)
                      ],
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                    ),
                    icon: MyFlutterApp.home,
                    text: 'Anasayfa',
                  ),
                  GButton(
                    backgroundGradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(38, 208, 124, 1.0),
                        Color.fromRGBO(6, 119, 226, 1)
                      ],
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                    ),
                    icon: MyFlutterApp.location,
                    text: 'Harita',
                  ),
                  GButton(
                    backgroundGradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(38, 208, 124, 1.0),
                        Color.fromRGBO(6, 119, 226, 1)
                      ],
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                    ),
                    icon: MyFlutterApp.shoppingcart,
                    text: 'Ödüller',
                  ),
                  GButton(
                    backgroundGradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(38, 208, 124, 1.0),
                        Color.fromRGBO(6, 119, 226, 1)
                      ],
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                    ),
                    icon: MyFlutterApp.madal,
                    text: 'Skor',
                  ),

                ],
              ),
            )
          ),
        )
      ), context),
    );

  }

  _setPages(int index){
    switch(index) {
      case 0 :
        appbarTitle = "Anasayfa";
        isTouchedScreen = true;
        break;
      case 1 :
        isTouchedScreen = false;
        _updateCurrentLocation();
        appbarTitle = "Harita";
        break;
      case 2 :
        _odulleriGetir();
        _odullerimiGetir();
        appbarTitle = "Ödüller";
        isTouchedScreen = true;
        break;
      case 3 :
        _skorGetir();
        appbarTitle = "Skor";
        isTouchedScreen = true;
        break;
    }
  }
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Dikkat!',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
        content: Text('Uygulamadan çıkmak istiyor musunuz?',style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.bold),),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Hayır',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
          ),
          FlatButton(
            onPressed: () => exit(0),
            /*Navigator.of(context).pop(true)*/
            child: Text('Evet',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    ) ??
        false;
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }
  _updateTimeDistance(int atikId,int atikPuan,double atikCo2)async {
    if(!await Functions.internetDurumu(context)) return;
    positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen(
            (Position position) async {
          var response = await http.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${position.latitude},${position.longitude}&language=tr-TR&destinations=${destination.latitude},${destination.longitude}&mode=walking&key=YOURKEY");
          var data = jsonDecode(response.body);
          setState(() {
            distance = data["rows"][0]["elements"][0]["distance"]["text"];
            distanceTime = data["rows"][0]["elements"][0]["duration"]["text"].toString().replaceAll("saat", "sa.").replaceAll("dakika", "dk.");
          });
          double disMet;
          if(data["rows"][0]["elements"][0]["distance"]["text"].toString().contains(" m")){
            disMet = double.parse(data["rows"][0]["elements"][0]["distance"]["text"].toString().replaceAll(" m", ""));
            if(disMet < 10){
              setState(() {
                isTouchedScreen = true;
                positionStream.pause();
                isGoing = false;
                polylines.clear();
                polylineCoordinates.clear();
              });
              if(!odulKazandiMi){
                if(KullaniciBilgileri.gunlukPuan == 90){
                  showDialog(context: context, builder: (context) => Container(child: lottie.Lottie.asset("assets/check.json",),padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/5,left: MediaQuery.of(context).size.width/5)));
                  Timer(Duration(milliseconds: 1200), () {
                    Navigator.pop(context);
                  });
                  return;
                }else if(atikPuan +KullaniciBilgileri.gunlukPuan >= 90){
                  atikPuan = 90-atikPuan;
                }
                String image = await imageSelector(context);
                if(image.isNotEmpty){
                  bool puanRequest = await _puanKazan(atikId,atikPuan,atikCo2,image);
                  if(puanRequest){
                    showDialog(context: context, builder: (context) => Container(child: lottie.Lottie.asset("assets/check.json",),padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/5,left: MediaQuery.of(context).size.width/5)));
                    Timer(Duration(milliseconds: 1200), () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPointPage(atikPuan,atikCo2)));
                    });

                  }
                }
                odulKazandiMi = true;
              }
            }

          }
        });
  }
  void getData() async{
    if(!await Functions.internetDurumu(context)) return;
    var response = await http.get("APIURL");
    var points = jsonDecode(response.body);
    for(var point in points){
      switch(point["nokta_atikTuru"]){
        case "Ambalaj Atığı":
          markerIcon = await getBytesFromAsset('assets/markers/ambalaj.png', 65);
          break;
        case "Atık Pil":
          markerIcon = await getBytesFromAsset('assets/markers/pil.png', 65);
          break;
        case "Atık Yağ":
          markerIcon = await getBytesFromAsset('assets/markers/yag.png', 65);
          break;
        case "Cam Atığı":
          markerIcon = await getBytesFromAsset('assets/markers/cam.png', 65);
          break;
        case "Elektronik Atık":
          markerIcon = await getBytesFromAsset('assets/markers/eatik.png', 65);
          break;
        case "Atık Tekstil":
          markerIcon = await getBytesFromAsset('assets/markers/tekstil.png', 65);
          break;
      }
      latLng = LatLng(point["nokta_enlem"], point["nokta_boylam"]);
      setState(() {
        allMarkers.add(Marker(
            markerId: MarkerId(point["nokta_id"].toString()),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            draggable: true,
            onTap: () async{
              desLatLng = LatLng(point["nokta_enlem"], point["nokta_boylam"]);
              var response = await http.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${curLatLng.latitude},${curLatLng.longitude}&destinations=${desLatLng.latitude},${desLatLng.longitude}&mode=walking&key=YOURKEY");
              var data = jsonDecode(response.body);
              _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    bearing: 270.0,
                    target: desLatLng,
                    tilt: 30.0,
                    zoom: 18,
                  ),
                ),
              );
              String uzaklikBilgi = data["rows"][0]["elements"][0]["distance"]["text"];
              String mesafe = uzaklikBilgi.substring(0,uzaklikBilgi.indexOf(' '));
              String mesafeTuru = uzaklikBilgi.substring(uzaklikBilgi.indexOf(' ')+1,uzaklikBilgi.length).toUpperCase();

              showDialog(context: context,builder: (context) => MarkInfo(point["nokta_atikTuru"],point["nokta_poiIsim"],mesafe,mesafeTuru))..then((value) async{
                if(value.toString() == "Ok"){
                  destination = LatLng(point["nokta_enlem"], point["nokta_boylam"]);
                  setState(() {
                    isGoing = true;
                  });
                  odulKazandiMi = false;
                  isTouchedScreen = false;
                  await _updateCurrentLocation();
                  if(KullaniciBilgileri.gunlukPuan == 90){
                    showDialog(context: context,builder: (context) => MaksPuanDialog("Maksimum günlük çevre puanına ulaştın. Geri dönüşüm yapmaya devam edebilirsin ancak puanların yarın artmaya devam edecek."));
                  }else if(int.parse(point["nokta_atikPuan"].toString()) +KullaniciBilgileri.gunlukPuan >= 90){
                    showDialog(context: context,builder: (context) => MaksPuanDialog("Bu geri dönüşüm ile maksimum günlük çevre puanına ulaşacağın için ${90-int.parse(point["nokta_atikPuan"])} puan kazanacaksın."));
                  }
                  await _updateTimeDistance( point["nokta_id"], int.parse(point["nokta_atikPuan"].toString()),double.parse(point["nokta_co2Deger"].toString()));
                  await _createPolylines(curLatLng, LatLng(point["nokta_enlem"], point["nokta_boylam"]));
                }
              });
            },
            position: latLng));
      });
    }

  }
  _createPolylines(LatLng start, LatLng destination) async {
    if(!await Functions.internetDurumu(context)) return;
    polylinePoints = PolylinePoints();
    setState(() {
      polylineCoordinates.clear();
      polylines.clear();
    });
    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "YOURKEY",
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      geodesic: true,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    // Adding the polyline to the map
  }
  _checkLocationPermission() async {

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission != LocationPermission.always && permission != LocationPermission.whileInUse){
      LocationPermission permissions = await Geolocator.requestPermission();
    }

  }
  _updateCurrentLocation()  {
    double zoom;
    double tilt;

    positionCameraStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best).listen(
            (Position position)  {
              if(isGoing){
                zoom = 19;
                tilt = 40;
              }else{
                zoom = 15;
                tilt = 0;
              }
              curLatLng = new LatLng(position.latitude, position.longitude);
              if(test == 1){
                getData();
                test = 0;
              }
              if(!isTouchedScreen){
                _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                  bearing: 0.0,
                  target: LatLng(position.latitude,position.longitude),
                  tilt: tilt,
                  zoom: zoom,
                ),)
                );
              }
        });



  }

  Future<bool> _puanKazan(int atikId,int atikPuan,double atikCo2,String imageName) async {
    if(!await Functions.internetDurumu(context)) return false;
    var body = jsonEncode({
      "kullaniciId" : KullaniciBilgileri.id,
      "atikNoktaId" : atikId,
      "hareketTuru" : 1,
      "hareketPuan" : KullaniciBilgileri.gunlukPuan+atikPuan,
      "hareketCo2Deger" : KullaniciBilgileri.co2Puani+atikCo2,
      "image" : base64Image,
      "name" : "${KullaniciBilgileri.id}_${atikId}_$imageName",
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    var response = await http.post(
        "APIURL",
        headers: {
          'Content-Type': 'application/json'
        },
        body: body
    );

    if (response.statusCode == 201) {
      KullaniciBilgileri.co2Puani += atikCo2;
      context.read<CevrePuani>().incDesc(atikPuan);
      KullaniciBilgileri.gunlukPuan += atikPuan;
      anasayfaYaziGetir();
      return true;
    }
    else {
      return false;
    }



  }

  void _skorGetir() async {
    if(!await Functions.internetDurumu(context)) return;
    var response = await http.get(
      "${Constants.apiUrl}?apiPage=skor&ilcelerMi=0",
    );
    kullaniciSkorList.clear();
    if (response.statusCode == 200) {
      var kullanicilar = jsonDecode(response.body);
      for(var kullanici in kullanicilar){
        kullaniciSkorList.add(KullaniciSkorModel(kullanici["kullanici_adSoyad"].toLowerCase().split(" ").map((str) => StringUtils.capitalize(str)).join(" "),kullanici["kullanici_ilceIsmi"],int.parse(kullanici["kullanici_puanToplam"].toString()),kullanici["kullanici_ppName"] != null ? Constants.generaPpUrl+kullanici["kullanici_ppName"] : Constants.noPpUrl));
      }
      setState(() {

      });
    }
    response = await http.get(
      "${Constants.apiUrl}?apiPage=skor&ilcelerMi=1",
    );
    ilceSkorList.clear();
    if (response.statusCode == 200) {
      var ilceler = jsonDecode(response.body);
      for(var ilce in ilceler){

        ilceSkorList.add(IlceSkorModel(ilce["ilce_title"],int.parse(ilce["ilce_puanToplam"].toString()),Constants.ilceLogoUrl+ilce["ilce_logo"]));
      }
      setState(() {
        
      });
    }



  }

  void _odulleriGetir() async {
    if(!await Functions.internetDurumu(context)) return;
    var response = await http.get(
      "${Constants.apiUrl}?apiPage=oduller&odullerim=no",
    );
    odullerList.clear();
    if (response.statusCode == 200) {
      var oduller = jsonDecode(response.body);
      for(var odul in oduller){
        odullerList.add(
            OdulModel(odul["odul_id"],odul["odul_puan"],odul["odul_baslik"],
                odul["odul_aciklama"],odul["odul_magaza"],Constants.urunUrl+odul["odul_gorsel1"],Constants.urunUrl+odul["odul_gorsel2"],DateTime.parse(odul["odul_gecTarihi"].toString())));
      }
      setState(() {
      });
    }

  }

  void _odullerimiGetir() async {
    if(!await Functions.internetDurumu(context)) return;
    var response = await http.get(
      "${Constants.apiUrl}?apiPage=oduller&odullerim=yes&kullaniciId=${KullaniciBilgileri.id}",
    );
    odullerimList.clear();
    if (response.statusCode == 200) {
      var oduller = jsonDecode(response.body);
      for(var odul in oduller){
        odullerimList.add(
            OdullerimModel(odul["kod_odulKodu"],odul["odul_baslik"],
                odul["odul_aciklama"],odul["odul_magaza"],Constants.urunUrl+odul["odul_gorsel1"],Constants.urunUrl+odul["odul_gorsel2"],DateTime.parse(odul["odul_gecTarihi"].toString())));
      }
      setState(() {
      });
    }

  }

  void anasayfaYaziGetir(){
    if(KullaniciBilgileri.gunlukPuan == 0){
      anasayfaYazisi = "Bugün hiç geri dönüşüm yapmadın.\nŞimdi başla!";
    }else if((KullaniciBilgileri.gunlukPuan/90*100) <= 60){
      anasayfaYazisi = "Güzel bir başlangıç. Atıklarını geri dönüştürerek devam etmelisin!";
    }else if((KullaniciBilgileri.gunlukPuan/90*100) <= 99){
      anasayfaYazisi = "Geri dönüşüm miktarı yeterli olmadığı için dakikada 100 dönüm ağaç kesiliyor. Biraz daha devam et!";
    }else{
      anasayfaYazisi = "Günlük geri dönüşüm hedefini tamamladın. Yarın geri dönüşüme tekrar devam et! ♻💯";
    }
  }


  Widget enIyiler() {
    return ListView.builder(
        itemCount: kullaniciSkorList.length,
        itemBuilder: (context,index) {
          return Padding(
            padding: EdgeInsets.only(left: 10,right: 10,top: index == 0 ? 5:0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 5,bottom: 5),
                        margin: EdgeInsets.only(top: 4,bottom: 4),
                        child: Row(
                          children: [
                            Container(child: Text((index+1).toString(),maxLines: 1,style: GoogleFonts.poppins(fontSize: 14,color:Color.fromRGBO(38, 208, 124, 1),fontWeight: FontWeight.w700)),width: 18,),
                            Expanded(child: ListTile(
                              leading: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              kullaniciSkorList[index].kullaniciPpUrl
                                          )
                                      )
                                  )
                              ),
                              title: Text(kullaniciSkorList[index].kullaniciIsim,style: GoogleFonts.inter(fontSize: 16),),
                              trailing: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromRGBO(38, 208, 124, 1)
                                ),
                                child: Center(
                                  child: Text("${kullaniciSkorList[index].kullaniciPuan}",style: GoogleFonts.inter(color: Colors.white,fontSize: 14),),
                                ),
                              ),
                            ),)
                          ],
                        )
                    ),
                    index == 0 ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: SvgPicture.asset("assets/pages/badge1.svg"),
                        )
                    ): Container(),
                    index == 1 ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: SvgPicture.asset("assets/pages/badge2.svg"),
                        )
                    ): Container(),
                    index == 2 ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: SvgPicture.asset("assets/pages/badge3.svg"),
                        )
                    ): Container()
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }
  Widget ilceler() {
    return ListView.builder(
      itemCount: ilceSkorList.length,
        itemBuilder: (context,index) {
          return Padding(
            padding: EdgeInsets.only(left: 10,right: 10,top: index == 0 ? 5:0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 5,bottom: 5),
                        margin: EdgeInsets.only(top: 4,bottom: 4),
                        child: Row(
                          children: [
                            Container(child: Text((index+1).toString(),maxLines: 1,style: GoogleFonts.poppins(fontSize: 14,color:Color.fromRGBO(38, 208, 124, 1),fontWeight: FontWeight.w700)),width: 18,),
                            Expanded(child: ListTile(
                              leading: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            ilceSkorList[index].ilceLogo
                                        )
                                    )
                                ),
                              ),
                              title: Text(ilceSkorList[index].ilceIsim,style: GoogleFonts.inter(fontSize: 16),),
                              trailing: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromRGBO(38, 208, 124, 1)
                                ),
                                child: Center(
                                  child: Text("${ilceSkorList[index].ilcePuan}",style: GoogleFonts.inter(color: Colors.white,fontSize: 14),),
                                ),
                              ),
                            ),)
                          ],
                        )
                    ),
                    index == 0 ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: SvgPicture.asset("assets/pages/badge1.svg"),
                        )
                    ): Container(),
                    index == 1 ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: SvgPicture.asset("assets/pages/badge2.svg"),
                        )
                    ): Container(),
                    index == 2 ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: SvgPicture.asset("assets/pages/badge3.svg"),
                        )
                    ): Container()
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }


  Widget odullerHepsi() {
    return ListView.builder(
        itemCount: odullerList.length,
        itemBuilder: (context,index) {
          return Padding(
            padding: EdgeInsets.only(left: 10,right: 10,top: index == 0 ? 5:0),
            child: InkWell(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 275,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                            image: DecorationImage(image: NetworkImage(odullerList[index].gorsel1),fit: BoxFit.fill),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.12),
                                offset: Offset(0, 10),
                                blurRadius: 99,
                              ),
                            ],
                          ),
                          width: double.infinity,
                          height: 200,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.12),
                                offset: Offset(0, 10),
                                blurRadius: 99,
                              ),
                            ],
                          ),
                          width: double.infinity,
                          height: 75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(odullerList[index].baslik,style: GoogleFonts.inter(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w600)),
                                  Text(odullerList[index].magaza,style: GoogleFonts.inter(fontSize: 13,color: Color.fromRGBO(32, 80, 114, 1)),),
                                ],
                              ),
                              Text(DateFormat('dd.MM.yyyy').format(odullerList[index].gecTarihi),style: GoogleFonts.inter(fontSize: 15,color: Color.fromRGBO(32, 80, 114, 1)),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 10,top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      height: 30,
                      width: 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${odullerList[index].puan}",
                            style: GoogleFonts.inter(
                                color: Color.fromRGBO(32, 80, 114, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 3,),
                          SvgPicture.asset("assets/buttons/yaprak.svg",
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OdulDetaySayfasi(odullerList[index]))),
            )
          );
        });
  }

  Widget odullerim() {
    return ListView.builder(
        itemCount: odullerimList.length,
        itemBuilder: (context,index) {
          return Padding(
              padding: EdgeInsets.only(left: 10,right: 10,top: index == 0 ? 5:0),
              child: InkWell(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 275,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                              image: DecorationImage(image: NetworkImage(odullerimList[index].gorsel1),fit: BoxFit.fill,colorFilter: new ColorFilter.mode(Colors.black.withOpacity(DateTime.now().isBefore(odullerimList[index].gecTarihi.add(Duration(days: 1)))  ? 1 : 0.3), BlendMode.dstATop),),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.12),
                                  offset: Offset(0, 10),
                                  blurRadius: 99,
                                ),
                              ],
                            ),
                            width: double.infinity,
                            height: 200,
                            child: Center(
                              child: Container(
                                height: 50,
                                color: Colors.white,
                                child: Center(
                                  child: Text(odullerimList[index].odulKodu,
                                    style: GoogleFonts.inter(fontSize: 40,fontWeight: FontWeight.w500,color: Color.fromRGBO(69, 79, 99, 1)),
                                  ),
                                ),
                              )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.12),
                                  offset: Offset(0, 10),
                                  blurRadius: 99,
                                ),
                              ],
                            ),
                            width: double.infinity,
                            height: 75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(odullerimList[index].baslik,style: GoogleFonts.inter(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w600)),
                                    Text(odullerimList[index].magaza,style: GoogleFonts.inter(fontSize: 13,color: Color.fromRGBO(32, 80, 114, 1)),),
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: "Bitiş Tarihi: ",style: GoogleFonts.inter(fontSize: 14,fontWeight: FontWeight.w600,color: Color.fromRGBO(69, 79, 99, 1)),),
                                      TextSpan(text: DateFormat('dd.MM.yyyy').format(odullerimList[index].gecTarihi),style: GoogleFonts.inter(fontSize: 15,color: Color.fromRGBO(69, 79, 99, 1)),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: DateTime.now().isBefore(odullerimList[index].gecTarihi.add(Duration(days: 1)))  ? Container(
                        margin: EdgeInsets.only(left: 10,top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        height: 22,
                        width: 55,
                        child: Center(
                          child: Text("AKTİF",
                            style: GoogleFonts.poppins(
                                color: Color.fromRGBO(38, 208, 124, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ) : Container(
                          margin: EdgeInsets.only(left: 10,top: 10),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          height: 22,
                          width: 80,
                          child: Center(
                            child: Text("SÜRESİ DOLDU",
                              style: GoogleFonts.poppins(
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      content: Text(odullerimList[index].aciklama,style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w600),),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Tamam',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  );
                }
              )
          );
        });
  }



  Widget _anaSayfa() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 70,right: 25,left: 25),
            child: Container(
              height: 75,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x14282828),
                    offset: Offset(0, 28),
                    blurRadius: 46,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Merhaba ${StringUtils.capitalize(KullaniciBilgileri.adSoyad.substring(0,KullaniciBilgileri.adSoyad.indexOf(' ')))},",style: GoogleFonts.inter(fontSize: 18,fontWeight: FontWeight.w600),),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Bugüne kadar ', style: GoogleFonts.inter(color: Color.fromRGBO(51, 50, 50, 1),fontSize: 12,fontWeight: FontWeight.w500,)),
                        TextSpan(text: '${KullaniciBilgileri.co2Puani} kg CO', style: GoogleFonts.inter(color: Color.fromRGBO(6, 119, 226, 1),fontSize: 12,fontWeight: FontWeight.w500)),
                        TextSpan(text: '2', style: GoogleFonts.inter(color: Color.fromRGBO(6, 119, 226, 1),fontSize: 9,fontWeight: FontWeight.w500)),
                        TextSpan(text: ' tasarrufu sağladın', style: GoogleFonts.inter(color: Color.fromRGBO(51, 50, 50, 1),fontSize: 12,fontWeight: FontWeight.w500,)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10,right: 25,left: 25),
                child: Container(
                  height: 75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x14282828),
                        offset: Offset(0, 28),
                        blurRadius: 46,
                      ),
                    ],
                  ),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                          radius: MediaQuery.of(context).size.width/2,
                          lineWidth: 10.0,
                          percent: KullaniciBilgileri.gunlukPuan/90,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Padding(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/pages/anasayfacircle.svg"),
                                  SizedBox(height: 10,),
                                  Text("%${(KullaniciBilgileri.gunlukPuan/90*100).toStringAsFixed(0)}",style: GoogleFonts.inter(fontSize: 20,fontWeight: FontWeight.w600,color: Color.fromRGBO(6, 119, 226, 1))),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.only(top: 30,bottom: 20),
                          ),
                          progressColor: Color.fromRGBO(6, 119, 226, 1)
                      ),
                      SizedBox(height: 25,),
                      Padding(
                        padding: EdgeInsets.only(left: 15,right: 15,bottom: 5),
                        child: Text(anasayfaYazisi,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 13,color: Color.fromRGBO(51, 50, 50, 1))),
                      )
                    ],
                  ),
                ),
              ),),
          Padding(
            padding: EdgeInsets.only(top: 20,right: 25,left: 25,bottom: 20),
            child: InkWell(
              child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Color.fromRGBO(6, 119, 226, 1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x14282828),
                        offset: Offset(0, 28),
                        blurRadius: 46,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Icon(MyFlutterApp.madal,color: Colors.white,size: 20,),
                      ),
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Çevre Puanı",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${context.watch<CevrePuani>().cevrePuani}",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 5,),
                              SvgPicture.asset("assets/buttons/yaprakwhite.svg",),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width-240,),
                      Container(
                        height: 27,
                        width: 27,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white)
                        ),
                        child: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 10,),
                      ),
                    ],
                  )
              ),
              onTap: () => showDialog(context: context,builder: (context) => _cevrePuaniDialog()),
            ),
          ),
        ],
      )
    );
  }
  Widget haritaSayfasi(){
    return  AbsorbPointer(
      absorbing: false,
      child: Listener(
        child: Container(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: cameraPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _controller.setMapStyle("[]");
                },
                mapToolbarEnabled: false,

                markers: Set.from(allMarkers),
                polylines: Set<Polyline>.of(polylines.values),
              ),
              !isGoing ? Align(
                alignment: Alignment.bottomCenter,
                child:Container(
                ),
              ) : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color.fromRGBO(6, 119, 227, 1),width: 2),
                                  color: Colors.white
                              ),
                              height: 50,
                              width: 50,
                              child: Icon(Icons.close,size: 35,color: Color.fromRGBO(6, 119, 227, 1),),
                              margin: EdgeInsets.only(left: 40),
                            ),
                            onTap: () {
                              setState(() {
                                positionStream.pause();
                                isGoing = false;
                                polylines.clear();
                                polylineCoordinates.clear();
                              });
                            },
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Align(
                          child: Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Hedefe",style: GoogleFonts.poppins(color: Color.fromRGBO(6, 119, 226, 1),fontWeight: FontWeight.w600,fontSize: 18),),
                                SizedBox(height: 7,),
                                Text(distanceTime,style: GoogleFonts.inter(fontSize: 17),),
                                SizedBox(height: 7,),
                                Text("$distance",style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 17),),
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                        )
                      ],
                    )
                ),
              ),
              Align(
                  alignment: Alignment(0.95,0.65),
                  child:InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      height: 45,
                      width: 45,
                      padding: EdgeInsets.all(12),
                      child: SvgPicture.asset("assets/buttons/focusnew.svg",),
                    ),
                    onTap: () async {
                      isTouchedScreen=false;
                    },
                  )
              ),
              Align(
                  alignment: Alignment(0.95,0.45),
                  child:InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(6, 119, 226, 1),
                          shape: BoxShape.circle
                      ),
                      height: 45,
                      width: 45,
                      padding: EdgeInsets.all(0),
                      child: Center(child: FaIcon(FontAwesomeIcons.question,color: Colors.white,size: 20,),)
                    ),
                    onTap: () async {
                     showDialog(context: context,builder: (context) => _atikBilgiDialog());
                    },
                  )
              ),
            ],
          ),
        ),
        onPointerDown: (v) {
          isTouchedScreen = true;
        },
      ),

    );
  }
  _skorSayfasi()  {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.only(top: 50),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: TabBar(tabs: [
                      Tab(
                        child: Text("En İyiler",style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      ),
                      Tab(
                        child: Text("İlçeler",style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      )
                    ],
                      labelColor: Color.fromRGBO(38, 208, 124, 1),
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Color.fromRGBO(38, 208, 124, 1),
                    ),
                  ),
                  Expanded(child: Container(
                    child: TabBarView(
                      children: [
                        enIyiler(),
                        ilceler()
                      ],
                    ),
                  ))
                ],
              ),
            )
        ),
      ],
    );
  }


  Widget _odullerSayfasi() {
    return Container(
        padding: EdgeInsets.only(top: 50),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 50,
                child: TabBar(tabs: [
                  Tab(
                    child: Text("Hepsi",style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  ),
                  Tab(
                    child: Text("Ödüllerim",style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  )
                ],
                  labelColor: Color.fromRGBO(38, 208, 124, 1),
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Color.fromRGBO(38, 208, 124, 1),
                ),
              ),
              Expanded(child: Container(
                child: TabBarView(
                  children: [
                    odullerHepsi(),
                    odullerim()
                  ],
                ),
              ))
            ],
          ),
        )
    );
  }




  Future<String> imageSelector(BuildContext context) async {
    imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);
    if (imageFile != null) {
      base64Image = base64Encode(imageFile.readAsBytesSync());
      return imageFile.path.split('/').last;
    } else {
      print("You have not taken image");
      return "";
    }
    setState(() {

    });
  }

  Widget _cevrePuaniDialog() {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 540,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  height: 140,
                  width: 140,
                  child: SvgPicture.asset("assets/buttons/yaprak.svg"),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  width: double.infinity,
                  child: Center(
                      child:  Text("Çevre Puanı",
                          style: GoogleFonts.inter(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600)
                      )
                    )
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Geri dönüşüm yapacağın yere vardığında açılan kamera ile atıklarının fotoğrafını çektiğinde  her atık türü için belirli bir çevre puanı kazanırsın. Elindeki çevre puanlarıyla ödüller sayfasından istediğin ödülün sahibi olabilirsin.\n\n"
                            "Günlük maksimum 90 çevre puanı kazanabilirsin.\n\n"
                            "Arkadaşlarını davet ederek yeşil halkayı büyütürken ekstra çevre puanı kazanmaya devam edebilirsin.",
                        style: GoogleFonts.poppins(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    )
                )
              ],
            ),
            Align(
              alignment: Alignment(1,-1),
              child: IconButton(
                icon: Icon(Icons.cancel_outlined,color: Color.fromRGBO(6, 119, 226, 0.75),size: 30,),
                onPressed: () => Navigator.pop(context),
              )
            )
          ],
        ),
      )
    );
  }

  Widget _atikBilgiDialog() {
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 25,vertical: 65),
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: 30,),
                Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 40,left: 5,right: 5),
                        width: 50,
                        height: 100,
                        child: SvgPicture.asset("assets/biriktir/AtikElektronik.svg"),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Elektronik Atık",style: GoogleFonts.poppins(fontSize: 15,color: Color.fromRGBO(182, 59, 170, 1),fontWeight: FontWeight.bold),),
                          Text("Klavye, bilgisayar, telefon, televizyon gibi kullanım ömrü sona ermiş elektronik eşyaların tümü",style: GoogleFonts.inter(fontSize: 12,color: Color.fromRGBO(50, 49, 49, 1)),)
                        ],
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 55),
                        width: 50,
                        height: 100,
                        child: SvgPicture.asset("assets/biriktir/AtikCam.svg"),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cam Atığı",style: GoogleFonts.poppins(fontSize: 15,color: Color.fromRGBO(38, 208, 124, 1),fontWeight: FontWeight.bold),),
                          Text("İçecek şişeleri, kavanozlar, bardak, sürahi, pencere, araba camları ve farları, beyaz ve renkli soda şişeleri gibi cam ürünler",style: GoogleFonts.inter(fontSize: 12,color: Color.fromRGBO(50, 49, 49, 1)),)
                        ],
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 60,left: 5,right: 5),
                        width: 50,
                        height: 100,
                        child: SvgPicture.asset("assets/biriktir/AtikAmbalaj.svg"),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ambalaj Atığı",style: GoogleFonts.poppins(fontSize: 15,color: Color.fromRGBO(6, 119, 226, 1),fontWeight: FontWeight.bold),),
                          Text("Kağıt, karton, temizlik ürünleri ambalajları, kirlenmemiş gıda paketleri, plastik şişeler, metal ve alüminyum kutular",style: GoogleFonts.inter(fontSize: 12,color: Color.fromRGBO(50, 49, 49, 1)),)
                        ],
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 60,left: 5,right: 5),
                        width: 50,
                        height: 100,
                        child: SvgPicture.asset("assets/biriktir/AtikPil.svg"),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Atık Pil",style: GoogleFonts.poppins(fontSize: 15,color: Color.fromRGBO(237, 16, 16, 1),fontWeight: FontWeight.bold),),
                          Text("Kullanım ömrünü tamamlamış veya uğramış olduğu fiziksel hasar sonucu kullanılmayacak duruma gelmiş pillerin tümü",style: GoogleFonts.inter(fontSize: 12,color: Color.fromRGBO(50, 49, 49, 1)),)
                        ],
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 60,left: 5,right: 5),
                        width: 50,
                        height: 100,
                        child: SvgPicture.asset("assets/biriktir/AtikTekstil.svg"),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Atık Tekstil",style: GoogleFonts.poppins(fontSize: 15,color: Color.fromRGBO(241, 47, 117, 1),fontWeight: FontWeight.bold),),
                          Text("Kıyafet, deri olmayan ayakkabı, elyaf, havlu, masa örtüsü, halı, perde, nevresim, örtü, battaniye ",style: GoogleFonts.inter(fontSize: 12,color: Color.fromRGBO(50, 49, 49, 1)),)
                        ],
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 60,left: 5,right: 5),
                        width: 50,
                        height: 100,
                        child: SvgPicture.asset("assets/biriktir/AtikYag.svg"),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cam Atığı",style: GoogleFonts.poppins(fontSize: 15,color: Color.fromRGBO(0, 0, 0, 1),fontWeight: FontWeight.bold),),
                          Text("Kullanılmış kızartmalık yağlar, son kullanma tarihi geçmiş katı veya sıvı yağlar",style: GoogleFonts.inter(fontSize: 12,color: Color.fromRGBO(50, 49, 49, 1)),)
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment(1,-1),
                child: IconButton(
                  icon: Icon(Icons.cancel_outlined,color: Color.fromRGBO(6, 119, 226, 0.75),size: 30,),
                  onPressed: () => Navigator.pop(context),
                )
            )
          ],
        ),
    );
  }


}

class IlceSkorModel{
  String ilceIsim;
  int ilcePuan;
  String ilceLogo;
  IlceSkorModel(this.ilceIsim,this.ilcePuan,this.ilceLogo);
}

class KullaniciSkorModel{
  String kullaniciIsim;
  String kullaniciIlce;
  int kullaniciPuan;
  String kullaniciPpUrl;
  KullaniciSkorModel(this.kullaniciIsim,this.kullaniciIlce,this.kullaniciPuan,this.kullaniciPpUrl);
}


class OdulModel{
  int id;
  int puan;
  String baslik;
  String magaza;
  String aciklama;
  String gorsel1;
  String gorsel2;
  DateTime gecTarihi;
  OdulModel(this.id,this.puan,this.baslik,this.aciklama,this.magaza,this.gorsel1,this.gorsel2,this.gecTarihi);
}


class OdullerimModel{
  String baslik;
  String magaza;
  String aciklama;
  String gorsel1;
  String gorsel2;
  String odulKodu;
  DateTime gecTarihi;
  OdullerimModel(this.odulKodu,this.baslik,this.aciklama,this.magaza,this.gorsel1,this.gorsel2,this.gecTarihi);
}