import 'package:flutter/material.dart';


class BilgilendirmeDialog extends StatelessWidget {
  String bilgiMesaji;
  BilgilendirmeDialog(this.bilgiMesaji);
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
            height: bilgiMesaji.length < 70 ? 140 : 160,
            child: Stack(
              children: [
                Align(
                  child: Container(
                      child: Text(bilgiMesaji,style: TextStyle(color: Colors.black,fontSize: 17),maxLines: 4,textAlign: TextAlign.center,),
                      margin: EdgeInsets.only(top: 2,bottom: 5),
                      padding: EdgeInsets.only(left: 5,top: 20,bottom: 10,right: 5)
                  ),
                  alignment: Alignment.topCenter,
                ),
                Align(
                  child: Divider(color: Colors.grey,thickness: 1,),
                  alignment: Alignment(0,0.4),
                ),
                Align(
                  child: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Container(
                        child: Text("TAMAM",style: TextStyle(color: Colors.blue,),textAlign: TextAlign.center,),
                        width: double.infinity,
                      )
                  ),
                  alignment: Alignment.bottomCenter,
                )
              ],
            ),
          ),
        ));
  }
}
