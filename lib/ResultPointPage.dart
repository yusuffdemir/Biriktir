import 'package:biriktir/Models/UserModel.dart';
import 'package:biriktir/Widgets/MyButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';


class ResultPointPage extends StatefulWidget {
  double co2Degeri;
  int cevrePuani;
  ResultPointPage(this.cevrePuani,this.co2Degeri);
  @override
  _ResultPointPageState createState() => _ResultPointPageState();
}

class _ResultPointPageState extends State<ResultPointPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: screenSize.height*1.9/3,
              width: screenSize.width,
              child: Image.asset("assets/pages/resultBack.png",fit: BoxFit.fill,),
            ),
          ),
          Align(
            alignment: Alignment(-0.95,-0.9),
            child: InkWell(child: Container(
                height: 50,
                width: 50,
                child: Icon(Icons.arrow_back,color: Colors.white,)
            ),
              onTap: () => Navigator.pop(context),
            )
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: screenSize.height/4,
                      width: screenSize.width*2.2/3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset("assets/pages/resultCong.png"),
                          SizedBox(height: 5,),
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17.54)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 2,),
                                Text(KullaniciBilgileri.adSoyad,style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w700,color: Color.fromRGBO(67, 79, 99, 1)),),
                                SizedBox(height: 3,),
                                Text("Sonuçlarınız burada",style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w600,color: Color.fromRGBO(67, 79, 99, 1)),),
                                Container(color: Color.fromRGBO(230, 225, 222, 1),height: 1,margin: EdgeInsets.symmetric(horizontal: 25),)
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                  SizedBox(height: 5,),
                  Container(
                    height: screenSize.height*1.4/3,
                    width: screenSize.width*2.2/3,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: screenSize.height*1.1/3,
                            width: screenSize.width*2.2/3,
                            padding: EdgeInsets.only(bottom: 30,right: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(17.54),topRight: Radius.circular(17.54)),
                                image: DecorationImage(image: AssetImage("assets/pages/commm1.png"))
                            ),
                            child: Center(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/buttons/yaprakallwhite.svg",width: 15,),
                                SizedBox(height: 5,),
                                Text(widget.cevrePuani.toString(),style: GoogleFonts.inter(color: Colors.white,fontSize: 35,fontWeight: FontWeight.w600,),),
                                SizedBox(height: 5,),
                                Text('Çevre Puanı', style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
                              ],
                            ),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            height: screenSize.height*0.3/3+1,
                            width: screenSize.width*2.2/3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17.54),bottomRight: Radius.circular(17.54)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 28,
                                    offset: Offset(0, 46) // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: '${widget.co2Degeri} kg CO', style: GoogleFonts.inter(color: Color.fromRGBO(38, 208, 124, 1),fontSize: 18,fontWeight: FontWeight.bold)),
                                      TextSpan(text: '2', style: TextStyle(color: Color.fromRGBO(38, 208, 124, 1),fontSize: 11,fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                                Text("Karbon ayak izini azalttın",style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500,),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                      height: 120,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child: MyButtons.biriktirGreenButton(screenSize.width*2.2/3, "Video İzle (+5 Puan Kazan)"),
                              onTap: () async {
                                Toast.show(
                                    "Bu özellik yakın zamanda aktif olacaktır",
                                    context,
                                    duration: 2,
                                    gravity: 1,
                                    backgroundColor: Colors.red.shade600,
                                    textColor: Colors.white,
                                    backgroundRadius: 8
                                );

                              },
                            ),
                            SizedBox(height: 10,),
                            InkWell(
                              child:  Container(
                                  width: screenSize.width*2.2/3,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Color.fromRGBO(27, 196, 117, 1)),
                                      color: Colors.white
                                  ),
                                  child: Center(
                                    child: Text("Paylaş",style: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Color.fromRGBO(27, 196, 117, 1),fontSize: 15)),
                                  )
                              ),
                              onTap: () {
                                Toast.show(
                                    "Bu özellik yakın zamanda aktif olacaktır",
                                    context,
                                    duration: 2,
                                    gravity: 1,
                                    backgroundColor: Colors.red.shade600,
                                    textColor: Colors.white,
                                    backgroundRadius: 8
                                );
                              }
                            )
                          ]
                      )
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }



}
