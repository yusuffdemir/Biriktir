import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButtons{

  static biriktirGreenButton(double buttonWidth,String title) {
    return Container(

        width: buttonWidth,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(38, 208, 124, 1),
              Color.fromRGBO(0, 167, 101, 1),
            ],
          ),
        ),
        child: Center(
          child: Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15)),
        )
    );
  }

  static biriktirBlueButton(double buttonWidth,String title) {
    return Ink(
        width: buttonWidth,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color.fromRGBO(6, 119, 227, 1),
        ),
        child: Center(
          child: Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15)),
        )
    );
  }

  static biriktirgradientButton(double buttonWidth,String title) {
    return Ink(
        width: buttonWidth,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(38, 208, 124, 1),
              Color.fromRGBO(6, 119, 227, 1),
            ]
          ),
        ),
        child: Center(
          child: Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15)),
        )
    );
  }

  static googleLoginButton(double buttonWidth){
    return Ink(
        width: buttonWidth,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color.fromRGBO(10, 130, 214, 1),width: 2),
          color: Color.fromRGBO(242, 249, 255, 1)
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(child: SvgPicture.asset("assets/buttons/google.svg"),alignment: Alignment(-0.85,0),),
            Text("Google ile devam et",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),)
          ],
        )
    );
  }

}


