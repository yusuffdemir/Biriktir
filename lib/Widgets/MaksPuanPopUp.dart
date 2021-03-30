import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart' as lottie;



class MaksPuanDialog extends StatelessWidget {
  String bilgiMesaji;
  MaksPuanDialog(this.bilgiMesaji);
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
            height: 325,
            child: Column(
              children: [
                Container(
                    height: 150,
                    child: lottie.Lottie.asset("assets/award.json",)
                ),
                Expanded(child: Container(
                    child: Text(bilgiMesaji,style: TextStyle(color: Colors.black,fontSize: 16),maxLines: 4,textAlign: TextAlign.start,),
                    margin: EdgeInsets.only(top: 2,bottom: 5),
                    padding: EdgeInsets.only(left: 15,top: 20,bottom: 10,right: 10)
                ),),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 45,
                    width: MediaQuery.of(context).size.width/1.2,
                    child: Center(
                      child: Text("Tamam",style: GoogleFonts.roboto(color: Colors.white),),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(6, 119, 226, 1)
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ));
  }
}
