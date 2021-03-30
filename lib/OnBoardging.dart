import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'SigninPage.dart';

class Onboarding extends StatefulWidget {
  static final style = TextStyle(
    fontSize: 30,
    fontFamily: "Billy",
    fontWeight: FontWeight.w600,
  );

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int page = 0;
  LiquidController liquidController;
  UpdateType updateType;


  Color pageIndexFillColor = Color.fromRGBO(6, 119, 226, 1);
  Color pageIndexBorderColor = Color.fromRGBO(6, 119, 226, 1);
  Color noPageIndexCoverColor = Colors.white;
  Color arrowColor = Colors.white;
  Color arrowFillColor = Color.fromRGBO(6, 119, 226, 1);
  Color atlaColor = Colors.black;
  String biriktirAsset = "assets/pages/biriktir.svg";


  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [

    Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
        image: DecorationImage(image: AssetImage("assets/biriktir/p1.png"),fit: BoxFit.fill)
      ),
    ),
    Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(6, 119, 226, 1),
          image: DecorationImage(image: AssetImage("assets/biriktir/p2.png"),fit: BoxFit.fill)
      ),
    ),
    Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(38, 208, 124, 1),
          image: DecorationImage(image: AssetImage("assets/biriktir/p3.png"),fit: BoxFit.fill)
      ),
    ),
    Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: AssetImage("assets/biriktir/p4.png"),fit: BoxFit.fill)
      ),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              enableSlideIcon: true,
              enableLoop: false,
              positionSlideIcon: 0.52,
              slideIconWidget: Container(
                margin: EdgeInsets.only(right: 15),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: arrowFillColor,
                    border: Border.all(color: arrowFillColor)
                ),
                child: Icon(Icons.arrow_back_ios_outlined,color: arrowColor,size: 20,),
              ),
              ignoreUserGestureWhileAnimating: true,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0,top: 50),
                child: FlatButton(
                  onPressed: () {
                    _onBoardOk();
                  },
                  child: Text("Atla",style: GoogleFonts.poppins(fontSize: 16,color: atlaColor,fontWeight: FontWeight.w600),),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0,top: 60),
                child: SvgPicture.asset(biriktirAsset,width: 100,)
              ),
            ),
            Align(
              alignment: Alignment(-1,0.80),
              child: Container(
                margin: EdgeInsets.only(left: 50),
                height: 50,
                width: 100,
                child: Row(
                  children: List.generate(4, (index) => Container(
                    margin: EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                        color: index == page ? pageIndexFillColor : noPageIndexCoverColor,
                        border: Border.all(color: pageIndexBorderColor),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    width: 13,
                    height: 13,
                  ),)
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {

    setState(() {
      print(lpage);
      if(page == 3 && lpage == 3){
        _onBoardOk();
      }
      page = lpage;
      if(lpage == 0){
        pageIndexFillColor = Color.fromRGBO(6, 119, 226, 1);
        pageIndexBorderColor = Color.fromRGBO(6, 119, 226, 1);
        noPageIndexCoverColor = Colors.white;
        arrowColor = Colors.white;
        arrowFillColor = Color.fromRGBO(6, 119, 226, 1);
        biriktirAsset = "assets/pages/biriktir.svg";
        atlaColor = Colors.black;
      }else if(lpage ==1){
        pageIndexFillColor = Color.fromRGBO(38, 208, 124, 1);
        pageIndexBorderColor = Color.fromRGBO(38, 208, 124, 1);
        noPageIndexCoverColor = Color.fromRGBO(6, 119, 226, 1);
        arrowColor = Colors.white;
        arrowFillColor = Color.fromRGBO(38, 208, 124, 1);
        biriktirAsset = "assets/pages/biriktirWhite.svg";
        atlaColor = Colors.white;
      }else if(lpage ==2){
        pageIndexFillColor = Colors.white;
        pageIndexBorderColor = Colors.white;
        noPageIndexCoverColor = Colors.transparent;
        arrowColor = Color.fromRGBO(38, 208, 124, 1);
        arrowFillColor = Colors.white;
        biriktirAsset = "assets/pages/biriktirWhite.svg";
        atlaColor = Colors.white;
      }else{
        pageIndexFillColor = Color.fromRGBO(6, 119, 226, 1);
        pageIndexBorderColor = Color.fromRGBO(6, 119, 226, 1);
        noPageIndexCoverColor = Colors.white;
        arrowColor = Colors.white;
        arrowFillColor = Color.fromRGBO(6, 119, 226, 1);
        biriktirAsset = "assets/pages/biriktir.svg";
        atlaColor = Colors.black;
      }
    });
  }


  _onBoardOk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("isFirstOpen","false");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
          (Route<dynamic> route) => false,);
  }
}