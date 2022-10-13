import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:memix/models/alert_dialog_action.dart';
import 'package:memix/widgets/consts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class SaveMeme {
  final consts = Consts();

  //----------------------| Request storage permission |-------------------------
  Future requestPermission(BuildContext context, GlobalKey globalKey) async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    final info = statuses[Permission.storage];
    if (info == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter somethong here to display on snackbar")));(
          consts.getSnackBar("You must accept the permission to save memes"));//user denied the permission
    } else if (info == PermissionStatus.permanentlyDenied) {
      showDialog(
          context: context,
          builder: (context) => consts.getAlertDialog(
              'Permission',
              'Please Accept the storage permission to save the memes',
              [
                AlertDialogAction(() => Navigator.of(context).pop(), 'Cancel'),//user permanently denied the permission
                AlertDialogAction(() async {
                  await openAppSettings();
                  Navigator.of(context).pop();
                }, 'Confirm'),
              ],
              context));
    }else if(info == PermissionStatus.granted){
      saveImage(globalKey,context).catchError((e)=> ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter somethong here to display on snackbar"))));
      ("Something went wrong! ");

    }
  }

  //----------------------------| Save image to gallery |------------------------------
  Future saveImage(GlobalKey globalKey, BuildContext context) async {
    try {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => consts.getLoadingDialog(context, 'Saving image...'));
      final RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      final ui.Image image = await boundary.toImage(pixelRatio: 4.0);
      final ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(pngBytes, quality: 100);
      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter somethong here to display on snackbar")));
        (consts.getSnackBar("Saved"));
      }
      else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter somethong here to display on snackbar")));
          (consts.getSnackBar("Something went wrong! $result"));
      }
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      throw e;
    }
  }
}


