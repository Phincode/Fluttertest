import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<List<Uint8List>> getImage(ImgSource source,context) async {
  List<Uint8List> imageList=new List<Uint8List>();
  var image = await ImagePickerGC.pickImage(
    context: context,
    source: source,
    cameraIcon: Icon(
      Icons.add,
      color: Colors.brown,
    ),//cameraIcon and galleryIcon can change. If no icon provided default icon will be present
  );

  if(image!=null){
    StoreImage(ImagetoBase64(image));
    imageList=await GetImage();
  }
 return imageList;
}


ImagetoBase64(image){
  List<int> imageBytes = image.readAsBytesSync();
  print(imageBytes);
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}


StoreImage(String image) async {
SharedPreferences pref= await SharedPreferences.getInstance();
List<String> imageList=new List<String>();
if(pref.containsKey("ImDb")){
  imageList=pref.getStringList("ImDb");
  pref.remove("ImDb");
  imageList.add(image);
  pref.setStringList("ImDb", imageList);
}else{
  imageList.add(image);
  pref.setStringList("ImDb", imageList);
}

}

Future<List<Uint8List>> GetImage() async {
  List<String> imageList=new List<String>();
  List<Uint8List> imageList2=new List<Uint8List>();
  SharedPreferences pref= await SharedPreferences.getInstance();
  imageList.addAll(pref.getStringList("ImDb"));
  imageList.forEach((element) {
    imageList2.add(Base64Decoder().convert(element));
  });
return imageList2;
}

Future<List<Uint8List>>DeleteImage(List img,index) async {
  SharedPreferences pref= await SharedPreferences.getInstance();
  List<String> imageList=new List<String>();
  img.removeAt(index);
  img.forEach((element) {
    imageList.add(base64Encode(element));
  });
  pref.setStringList("ImDb", imageList);

return img;
}
