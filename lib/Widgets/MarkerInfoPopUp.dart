import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkInfo extends StatelessWidget {
  String atikTuru,poiIsim,uzaklik,uzaklikTuru;
  int noktaId;
  double puani;
  MarkInfo(this.atikTuru,this.poiIsim,this.uzaklik,this.uzaklikTuru);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/3,left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10),
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        height: 195,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(6, 119, 226, 1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
              ),
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Center(
                      child: Text("$atikTuru Noktası",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),)
                      ,),
                  ),
                  IconButton(icon: Icon(Icons.cancel_outlined,color: Colors.white,), onPressed: () => Navigator.pop(context,),)
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 80,
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10,top: 15),
                    child: Column(
                      children: [
                        Text(uzaklik,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
                        Text(uzaklikTuru,style: GoogleFonts.poppins(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 18),)
                      ],
                    )
                  ),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    width: 2,
                  ),
                  Expanded(child: Container(
                    child: Text(poiIsim,style: GoogleFonts.inter(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 15),maxLines: 2,),
                  ))
                ],
              ),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(6, 119, 227, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(6, 119, 227, 0.25),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(2, 3), // changes position of shadow
                      ),
                    ]
                ),
                height: 40,
                margin: EdgeInsets.only(top: 5,right: 50,left: 50),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: Text("Başla",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15)),),
              ),
              onTap: () => Navigator.pop(context,'Ok'),
            )
          ],
        ),
      ),
    );
  }
}
