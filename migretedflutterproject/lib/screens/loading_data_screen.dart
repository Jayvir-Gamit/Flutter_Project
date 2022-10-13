import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../wrapper.dart';
import '../providers/memes.dart';
import '../widgets/consts.dart';
import '../providers/photos.dart';
import 'package:provider/provider.dart';

class LoadingDataScreen extends StatefulWidget {
  static const routeName = 'loading';

  @override
  _LoadingDataScreenState createState() => _LoadingDataScreenState();
}

class _LoadingDataScreenState extends State<LoadingDataScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Consts consts = Consts();

  @override
  void initState() {
    Future.delayed(Duration.zero,() =>
    Provider.of<Photos>(context, listen: false)
        .getPhotosFromWeb()
        .then((_) => Provider.of<Memes>(context, listen: false)
            .fetchMemes()
            .then((_) => Navigator.of(context).pushReplacementNamed(Wrapper.routeName))
            .catchError((e) => ScaffoldMessenger.of(context).showSnackBar(consts.getSnackBar(e.toString()))))
        .catchError((e) => ScaffoldMessenger.of(context).showSnackBar(consts.getSnackBar(e.toString()))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(backgroundColor: Colors.white),
            SizedBox(
              height: 30,
            ),
            TypewriterAnimatedTextKit(
              repeatForever: true,
              speed: Duration(milliseconds: 100),
              text: [
                "Loading data...",
              ],
              textStyle: TextStyle(fontSize: 30.0, color: Colors.white),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
