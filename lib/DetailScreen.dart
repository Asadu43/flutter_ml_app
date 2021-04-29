import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  String selectedItem ="";

  File pickImage;
  var imageFile;
  var result  = '';

  bool isImageLoaded = false;


  getImageFromGallery() async {

    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickImage = File(tempImage.path);
      isImageLoaded = true;
    });


  }

  getTextFromImage () async {
    result = ' ';
    FirebaseVisionImage myimage = await FirebaseVisionImage.fromFile(pickImage);
    TextRecognizer textRecognizer = await FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(myimage);

    for (TextBlock block in visionText.blocks){
      for(TextLine line in block.lines){
        for(TextElement word in line.elements ){
          setState(() {
            result = result + ' ' + word.text;
          });
        }

      }
    }

  }

  decodeBarcode() async{
    result = '';
    FirebaseVisionImage myimage = await FirebaseVisionImage.fromFile(pickImage);
    BarcodeDetector barcodeDetector = await FirebaseVision.instance.barcodeDetector();
    List barCode = await barcodeDetector.detectInImage(myimage);

    for(Barcode readable in barCode){

      setState(() {
        result = readable.displayValue;
      });

    }


  }


  Future scanLabel() async{

    result = ' ';
    FirebaseVisionImage myimage = FirebaseVisionImage.fromFile(pickImage);
    ImageLabeler imageLabel = FirebaseVision.instance.imageLabeler();
    List labels = await imageLabel.processImage(myimage);

    for(ImageLabel label in labels){
      final String text = label.text;
      final double confidence = label.confidence;

      print(" $text   ---- $confidence");

      setState(() {
        result = result + " " + "$text    ----     $confidence" + "\n" ;
      });

    }


  }



  @override
  Widget build(BuildContext context) {

    selectedItem = ModalRoute.of(context).settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItem),
        centerTitle: true,
        actions: [
          FlatButton(onPressed: getImageFromGallery, child: Icon(
            Icons.camera_alt,
            color: Colors.white,
          )
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 50,),
          isImageLoaded ? Center(
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(pickImage),
                  fit: BoxFit.scaleDown
                ),
              ),
            ),
          ) : Container(),
          SizedBox(height: 40.0,),
          Text(result),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanLabel,
        child: Icon(Icons.check),
      ),
    );
  }
}
