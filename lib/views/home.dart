import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertest/logic/picImage.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return new _home();
  }


}

class _home extends State<home>{
  List<Uint8List> imageList=new List<Uint8List>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetImage().then((value){
      imageList=value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/1.9,
              child: ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: 100,
                    color: Colors.brown,
                  ),
            )),
            Positioned(
              top: MediaQuery.of(context).size.height/2.5,
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                 GestureDetector(
                   onTap: (){
                     // take and add image
                     getImage(ImgSource.Both, context).then((value){
                       if(value.isNotEmpty){
                         setState(() {
                           imageList=value;
                         });
                       }
                     });
                   },
                   child:  new Card(
                       color: Colors.white,
                       elevation: 2,
                       child: Container(
                         height: 150,
                         width: 150,
                         child: new Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Icon(Icons.add_circle_outline,color: Colors.brown,size: 30,),
                             new Text("Add new image")
                           ],
                         ),
                       )
                   ),
                 ),
                 Expanded(
                   child: ListView.builder(itemCount:imageList.length,scrollDirection:Axis.horizontal,itemBuilder: (BuildContext context,index){
                     return new Card(
                         color: Colors.white,
                         elevation: 2,
                         child: Stack(
                           children: <Widget>[
                             Container(
                               height: 150,
                               width: 150,
                               decoration: BoxDecoration(image: DecorationImage(image:MemoryImage(imageList[index]),fit: BoxFit.fill)),
                             ),
                             Positioned(
                               top: 0,
                               right: 1,
                               child: GestureDetector(
                                 onTap: (){
                                   DeleteImage(imageList,index).then((value){
                                     setState(() {
                                       imageList=value;
                                     });
                                   });
                                 },
                                 child: new Icon(Icons.cancel,color: Colors.white,),
                               ),
                             )
                           ],
                         )
                     );
                   }),
                 ),
                ],
              ) ,
            ),

          ],

        ),
      ),
    );
  }


}